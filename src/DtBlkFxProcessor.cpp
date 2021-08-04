/*
 * See LICENSE.md for copyright and licensing information.
 *
 * This file is part of DtBlkFx.
 *
 * DtBlkFx is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * DtBlkFx is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with DtBlkFx.  If not, see <https://www.gnu.org/licenses/>.
 */

#include "DtBlkFxProcessor.h"
#include "DtBlkFxEditor.h"
#include <cstring>

DtBlkFxAudioProcessor::DtBlkFxAudioProcessor()
    : AudioProcessor(BusesProperties().withInput("Input", juce::AudioChannelSet::stereo())
                                      .withOutput("Output", juce::AudioChannelSet::stereo())
                    ),
    _pre_fft_buffer(2, MAX_FFT_SZ)
{
}

DtBlkFxAudioProcessor::~DtBlkFxAudioProcessor() {}

const juce::String DtBlkFxAudioProcessor::getName() const
{
  return JucePlugin_Name;
}

bool DtBlkFxAudioProcessor::acceptsMidi() const
{
  return false;
}

bool DtBlkFxAudioProcessor::producesMidi() const
{
  return false;
}

bool DtBlkFxAudioProcessor::isMidiEffect() const
{
  return false;
}

double DtBlkFxAudioProcessor::getTailLengthSeconds() const
{
  return 0.0;
}

int DtBlkFxAudioProcessor::getNumPrograms()
{
  return 1; // NB: some hosts don't cope very well if you tell them there are 0 programs,
            // so this should be at least 1, even if you're not really implementing programs.
}

int DtBlkFxAudioProcessor::getCurrentProgram()
{
  return 0;
}

void DtBlkFxAudioProcessor::setCurrentProgram(int index)
{
  juce::ignoreUnused(index);
}

const juce::String DtBlkFxAudioProcessor::getProgramName(int index)
{
  juce::ignoreUnused(index);
  return {};
}

void DtBlkFxAudioProcessor::changeProgramName(int index, const juce::String& newName)
{
  juce::ignoreUnused(index, newName);
}

void DtBlkFxAudioProcessor::prepareToPlay(double sampleRate, int samplesPerBlock)
{
  // Use this method as the place to do any pre-playback
  // initialisation that you need..
  juce::ignoreUnused(sampleRate, samplesPerBlock);
}

void DtBlkFxAudioProcessor::releaseResources()
{
  // When playback stops, you can use this as an opportunity to free up any
  // spare memory, etc.
}

/**
 * \brief Checks if the layout is supported.
 * This method checks whether the given buslayout is supported or not.
 * \param[in] layouts  The bus layout to check
 *
 * \return true if the layout is supported, else false.
 */
bool DtBlkFxAudioProcessor::isBusesLayoutSupported(const BusesLayout& layouts) const
{
  if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono() &&
      layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
  {
    return false;
  }

  return true;
}

void DtBlkFxAudioProcessor::processBlock(juce::AudioBuffer<float>& buffer,
                                         juce::MidiBuffer& midiMessages)
{
  juce::ignoreUnused(midiMessages);
  //SCOPE_NO_FP_EXCEPTIONS_OR_DENORMALS;
  //
  copyDataToBuffer(buffer);
  _buf_end_abs += _curr_samp_abs + buffer.getNumSamples();

  while(true){
      //TODO: Process params
    // how much extra data is there over what we need to process the blk?
    _extra_data = _pre_buffer_num + _processed_data_pre_buffer_num - _next_blk_fwd_n - _freq_fft_n;

    // determine whether we are forced to output a blk because of the delay or
    // we've run out of input buffer
    bool force_out = (_buf_end_abs - _dst_fft_abs > 0 || _pre_buffer_num >= _pre_buffer_force_out_size);

    // chk whether we should process the blk (forced to output or we have interpolate params
    // and we have enough data for a blk)
    bool should_proc = force_out || (_params_state == PARAMS_INTERP_OK && _extra_data >= 0);
    if (!should_proc)
      break;

    findBlockInPos();

    //_mixback = get(&GetInterp, _mixback_param);
    //TODO: Getmixback value

    // blk mix update
    // _blk_mix_fn_n = get(&GetInterp, _blk_mix_param, _blk_mix_fn);

    if (_mixback >= 1.0f) {
      prepMixOut();
      // no ffts because 100% mixback
      for (int i = 0; i < AUDIO_CHANNELS; i++) {
        float* x0_dat = _chan[i].x0;
        mixToX3(P1Src(x0_dat + _x0_i), i);
      }
    }
    else {
      // normal case, we need to do the FFTs
      doFFT();
      if (gui())
        gui()->FFTDataRdy(0 /*input*/);
      prepMixOut();

      procFFT();
      if (gui())
        gui()->FFTDataRdy(1 /*output*/);
      ifftAndMixOut();
    }
    nextBlk();

    // ensure stop if we run out of data to process
    if (_extra_data <= 0)
      break;
  }

  //_x3_o = wrap(samps + _x3_o, _chan[0].x3);
}

bool DtBlkFxAudioProcessor::hasEditor() const
{
  return true; // (change this to false if you choose to not supply an editor)
}

juce::AudioProcessorEditor* DtBlkFxAudioProcessor::createEditor()
{
  return new DtBlkFxAudioProcessorEditor(*this);
}

void DtBlkFxAudioProcessor::getStateInformation(juce::MemoryBlock& destData)
{
  // You should use this method to store your parameters in the memory block.
  // You could do that either as raw data, or use the XML or ValueTree classes
  // as intermediaries to make it easy to save and load complex data.
  juce::ignoreUnused(destData);
}

void DtBlkFxAudioProcessor::setStateInformation(const void* data, int sizeInBytes)
{
  // You should use this method to restore your parameters from this memory block,
  // whose contents will have been created by the getStateInformation() call.
  juce::ignoreUnused(data, sizeInBytes);
}

// This creates new instances of the plugin..
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
  return new DtBlkFxAudioProcessor();
}


/**
 * \brief Appends the given data into the buffer and wraps it if needed.
 * This method appends the given data into the internal audiobuffer. If the
 * data would cause an overflow the data is wrapped around the buffer.
 * \param[in] buffer  The input buffer with the new data
 *
 */
void DtBlkFxAudioProcessor::copyDataToBuffer(const juce::AudioBuffer<float>& buffer)
{
    long in_buf_offset;
    long buf_n = buffer.getNumSamples();
    while(buf_n){
        // how many samples to copy
        long n = buf_n;

        // offset into buffer at which to write data
        long t = _pre_buffer_index + _pre_buffer_num;

        // wrap to the start of the buffer if need be
        if (t >= _pre_buffer_size){
          t -= _pre_buffer_size;
        }

        // find how much the copy will overflow past _pre_buffer_size
        long overflow = t + buf_n - _pre_buffer_size;

        // don't overflow at all if there's too much data - I don't expect this to ever happen
        // (this is the only way that the loop could run more than once)
        if (overflow > MAX_FFT_SZ) {
          n -= overflow;
          overflow = 0;
        }
        if (overflow >= 0)
          _pre_buffer_num_past_end = overflow;

        const size_t copy_len = sizeof(float) *  (n - overflow);

        //Copy all the data into the buffer
        for(int i = 0; i < _pre_fft_buffer.getNumChannels(); ++i){
            const float* source_buffer = buffer.getReadPointer(0);
            float* dest_buffer = _pre_fft_buffer.getWritePointer(0);
            memcpy(dest_buffer + _pre_buffer_num,
                        source_buffer,
                        copy_len);
            if(overflow > 0){
               memcpy(dest_buffer, source_buffer + n - overflow,
                       sizeof(float) * overflow);
            }
        }

        buf_n -= n;
        in_buf_offset += n;
        _pre_buffer_num += n;
    }
}

void DtBlkFxAudioProcessor::findBlockInPos()
{
  // this should never happen: not enough data to go forward
  ASSERTX(_next_blk_fwd_n <= _x0_n, VAR(_next_blk_fwd_n) << VAR(_x0_n));

  // move forward in the input buffer
  _pre_buffer_index += _next_blk_fwd_n;
  _pre_buffer_num -= _next_blk_fwd_n;
  _blk_samp_abs += _next_blk_fwd_n;

  // wrap to the start of the buffer (assume fwd_n is < the size of the prebuffer)
  if (_pre_buffer_index >= _pre_buffer_size)
    _pre_buffer_index -= _pre_buffer_size;

  // chk whether we have enough data to do blk size & windowing requested
  if (_extra_data >= 0) {
    // all good, enough data to process
  } else if (_time_fft_n <= _pre_buffer_num) {
    // there's enough data if we don't honour exact spectrum windowing requested
    _processed_data_pre_buffer_num = _freq_fft_n - _pre_buffer_num;
    _extra_data = 0;

    // shouldn't happen, x0 pre-data becomes negative
    ASSERTX(_data_pre_x0_n < 0, VAR(_data_pre_x0_n) << VAR(_x0_n));
    if (_processed_data_pre_buffer_num < 0)
      _processed_data_pre_buffer_num = 0;
  } else {
    // not enough data, reduce fft length to what data we have
    _plan = reducePlan(_plan, _pre_buffer_num);
    _time_fft_n = _freq_fft_n = g_fft_sz[_plan];

    // now do we have enough data?
    _extra_data = _pre_buffer_num - _freq_fft_n;
    _processed_data_pre_buffer_num = 0;

    // if there's no extra data then pad with old data
    if (_extra_data < 0) {
      _processed_data_pre_buffer_num = -_extra_data;
      _time_fft_n = _pre_buffer_num;
      _extra_data = 0;
    }
  }
}

inline void DtBlkFxAudioProcessor::prepMixOut()
// internal method
//
// Prepare to mix blk to output by finding the number of samples that the current blk overlaps
// with the previous blk (_fadein_n & _fadeout_n)
//
{
  // the amount of xfade-in corresponds to the overlap of this fft blk with existing data
  _fadein_n = _x3_end_abs - _dst_fft_abs;

  // normal case is not to xfade-out current fft-blk because next blk will do the xfade
  _fadeout_n = 0;

  // get the absolute ending position of blk
  long dst_fft_end_abs = _dst_fft_abs + _time_fft_n;

  // how much the new fft blk will increase the amount of data in x3
  long extend_x3 = dst_fft_end_abs - _x3_end_abs;

  if (_fadein_n >= 0) {
    // normal case: previous data and the current fft blk overlap, cross-fade

    if (extend_x3 < 0) {
      // special case: current fft blk ends up entirely within existing x3 data,

      // do nothing if the blk ends prior to the current output position (should not happen)
      if (_curr_samp_abs - dst_fft_end_abs >= 0) {
        //TODO: LOG("", "mixToOutputBuffer possible ERROR" << VAR(_curr_samp_abs - dst_fft_end_abs));
        return;
      }

      // cross fade all of fft blk in & out
      _fadein_n = _time_fft_n / 2;
      _fadeout_n = _time_fft_n - _fadein_n;

      // one case is not handled, part of current blk is before current sample position
      // (should never happen)
    }
  }
  else {
    // special case: there is a gap between the end of prev data and the current fft blk

    // zero-fill gap (and a bit extra because we will still cross-fade to the current blk)
    long zero_o = _x3_end_abs - _curr_samp_abs;
    long zero_n = -_fadein_n;

    // arbitrary fade in of current fft blk
    _fadein_n = 16;

    // zero data in the gap (unless x3 is already cleared)
    if (!_x3_is_clear) {
      PZero pzero;
      for (int i = 0; i < AUDIO_CHANNELS; i++)
        wrapProcess(pzero, _chan[i].x3, _x3_o + zero_o, zero_n + _fadein_n);
    }
    _x3_is_clear = false;

    // arbitrary fade out of previous data
    long prev_fade_n = 16;
    long prev_fade_o = zero_o - prev_fade_n;

    // don't fade data that has already been output
    if (prev_fade_o < 0) {
      prev_fade_n += prev_fade_o;
      prev_fade_o = 0;
    }
    if (prev_fade_n > 0) {
      for (int i = 0; i < AUDIO_CHANNELS; i++) {
        PSrcDstWrap<PNoSrc, PRampDst> p;
        p.dst.setMix(/*start*/ 1, /*end*/ 0);
        wrapProcess(p, _chan[i].x3, _x3_o + prev_fade_o, prev_fade_n);
      }
    }
    // LOG("", "mixToOutputBuffer gap" << VAR(zero_o) << VAR(zero_n) << VAR(prev_fade_n) <<
    // VAR(prev_fade_o));
  }

  // update the end position of data in x3 if it is extended (this is slightly early but that
  // doesn't matter)
  if (extend_x3 > 0)
    _x3_end_abs = dst_fft_end_abs;

  // ensure fade in is not too big
  if (_fadein_n > _time_fft_n)
    _fadein_n = _time_fft_n;
}
