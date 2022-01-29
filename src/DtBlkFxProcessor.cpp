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
#include <stdio.h>
#include <string.h>

#include "wrapprocessfloatvec.h"

#include "DtBlkFxProcessor.h"
#include "DtBlkFxEditor.h"
#include "rfftw_float.h"

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

    _mixback = get(&GetInterp, _mixback_param);


        // blk mix update
        _blk_mix_fn_n = get(&GetInterp, _blk_mix_param, _blk_mix_fn);

        if (_mixback >= 1.0f) {
          prepMixOut();
          // no ffts because 100% mixback
          for (int i = 0; i < _pre_fft_buffer.getNumChannels(); ++i) {
            float* x0_dat = _pre_fft_buffer.getWritePointer(i);
            mixToX3(P1Src(x0_dat + _pre_buffer_index), i);
          }
        }
    else {
      // normal case, we need to do the FFTs
      doFFT();
      //if (gui())
      //  gui()->FFTDataRdy(0 /*input*/);
      if (hasEditor()) {
          //TODO Gui Connection
      }

      prepMixOut();

      procFFT();
      if (hasEditor()){
        //gui()->FFTDataRdy(1 /*output*/);
        }
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
  } else {
    // special case: there is a gap between the end of prev data and the current fft blk

    // zero-fill gap (and a bit extra because we will still cross-fade to the current blk)
    long zero_o = _x3_end_abs - _curr_samp_abs;
    long zero_n = -_fadein_n;

    // arbitrary fade in of current fft blk
    _fadein_n = 16;

    // zero data in the gap (unless x3 is already cleared)
    if (!_x3_is_clear) {
      PZero pzero;
      for (int i = 0; i < _x3.getNumChannels(); ++i){
        wrapProcess(pzero, _x3.getWritePointer(i), _x3_o + zero_o, zero_n + _fadein_n);
      }
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
      for (int i = 0; i < _x3.getNumChannels(); ++i) {
        PSrcDstWrap<PNoSrc, PRampDst> p;
        p.dst.setMix(/*start*/ 1, /*end*/ 0);
        wrapProcess(p, _x3.getWritePointer(i), _x3_o + prev_fade_o, prev_fade_n);
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

template <typename SRC> inline void DtBlkFxAudioProcessor::mixToX3(SRC src, int ch)
// internal method
//
{
  // position to start fade-in
  long x3_o = _dst_fft_abs - _curr_samp_abs + _x3_o;

  // use lerp'd mix function for fade in
  if (_fadein_n > 0) {
    PLinInterp<PMix<SRC>> p(_blk_mix_fn, _blk_mix_fn_n);
    p.proc.src = src;
    x3_o = wrapProcess(p, _x3.getWritePointer(ch), x3_o, _fadein_n);
    src = p.proc.src;
  }

  // number of samples in mid section
  long cp_n = _time_fft_n - _fadein_n - _fadeout_n;

  // copy mid section
  if (cp_n > 0) {
    PSrcDstWrap<SRC, PBlatDst> p;
    p.src = src;
    x3_o = wrapProcess(p, _x3.getWritePointer(ch), x3_o, cp_n);
    src = p.src;
  }

  // linear cross-mix
  if (_fadeout_n > 0) {
    PSrcDstWrap<SRC, PMixDst> p;
    p.src = src;
    p.dst.setMix(/*start*/ 0, /*end*/ 1);
    wrapProcess(p, _x3.getWritePointer(ch), x3_o, _fadeout_n);
  }
}

void DtBlkFxAudioProcessor::doFFT(){
  int i;

  // work out where we'll transform from
  long x0_xform_i = _pre_buffer_index - _processed_data_pre_buffer_num;//TODO check if this is _data_pre_x0_n
  if (x0_xform_i < 0)
    x0_xform_i += _pre_buffer_size;

  // find the amount of shoulder data that we can apply a window function to (window is symmetrical)
  int shoulder_n =
      std::min(/*right*/ _processed_data_pre_buffer_num, /*left*/ _freq_fft_n - _time_fft_n - _processed_data_pre_buffer_num);

  // if the shoulder windowing needs to be applied then we'll copy input data to "x2", window and
  // then transform
  if (shoulder_n > /*arbirary*/ 12) {

    // get the shoulder function to apply
    Array<float, 48> shoulder_fn;
    int shoulder_fn_n = get(&GetInterp, _blk_shoulder_wdw_param, shoulder_fn);

    for (i = 0; i < _pre_fft_buffer.getNumChannels(); ++i) {
      // position within x0
      long x0_x = x0_xform_i;

      // get x0 data range excluding overflow region
      Rng<float> x0(_pre_fft_buffer.getWritePointer(i), _pre_buffer_num);

      // apply window to left shoulder
      PLinInterp<PScaleCopyOut> p0(shoulder_fn, shoulder_fn_n);
      p0.proc.dst = _chan[0].x2; // always channel 0 to improve caching performance
      x0_x = wrapProcess(p0, x0, x0_x, shoulder_n);

      // copy mid section directly
      PCopyOut p1;
      p1.dst = p0.proc.dst;
      x0_x = wrapProcess(p1, x0, x0_x, _freq_fft_n - shoulder_n * 2);

      // apply window to right shoulder
      PLinInterp<PScaleCopyOut, /*reverse*/ 1> p2(shoulder_fn, shoulder_fn_n);
      p2.proc.dst = p1.dst;
      x0_x = wrapProcess(p2, x0, x0_x, shoulder_n);

      // and do the fft
      FFTWf::execute_dft_r2c(g_fft_plan[_plan], _chan[0].x2, to_fftwf_complex(FFTdata(i)));
    }
  }
  else {
    // do some data alignment to keep fftw happy

    // adjust pre-data to do the rounding
    int round_down = x0_xform_i & ~X0_INDEX_ROUNDING_MASK;
    x0_xform_i -= round_down;
    _extra_data += round_down;
    _processed_data_pre_buffer_num += round_down;
    _time_fft_n -= round_down;

    // shouldn't happen
    ASSERTX(_time_fft_n >= 0, VAR(_time_fft_n));
    if (_time_fft_n < 0)
      _time_fft_n = 0;

    // no windowing of data, make sure it is contiguous in x0 if it has wrapped past the end
    long x0_sz_ext = _pre_buffer_size + _pre_buffer_num_past_end;
    long split_n = (x0_xform_i + _freq_fft_n) - x0_sz_ext;
    if (split_n > 0) {
      for (i = 0; i < _pre_fft_buffer.getNumChannels(); ++i) {
        float* x0_dat = _pre_fft_buffer.getWritePointer(i);
        memcpy(x0_dat + x0_sz_ext, x0_dat + _pre_buffer_num_past_end, split_n);
      }
      _pre_buffer_num_past_end += split_n;
    }

    // do the fft
    for (i = 0; i < _pre_fft_buffer.getNumChannels(); ++i) {
      float* x0_dat = _pre_fft_buffer.getWritePointer(i);
      FFTWf::execute_dft_r2c(g_fft_plan[_plan], x0_dat + x0_xform_i, to_fftwf_complex(FFTdata(i)));
    }
  }

  // scale spectrum and find power for power matching
  float scale = 1.0f / (float)_freq_fft_n;
  for (i = 0; i < _x3.getNumChannels(); ++i) {
    // find power of spectrum (so that we can match to this afterwards)
    float acc = 0.0f;

    CplxfPtrPair in(FFTdata(i), _freq_fft_n / 2 + 1);
    for (; !in.equal(); ++(in.a)) {
      in() = in() * scale;
      acc += norm(*in.a);
    }

    _chan[i].total_out_pwr = acc;
    _chan[i].total_in_pwr = acc;
  }
}

void DtBlkFxAudioProcessor::procFFT()
{
    int i;

    // run all of the 1.0 effects (collect params first & then process)
    for (i = 0; i < BlkFxParam::NUM_FX_SETS; ++i) {
        _fx1_0[i].prepare();
    }
    for (i = 0; i < BlkFxParam::NUM_FX_SETS; ++i) {
        _fx1_0[i].process();
    }

    // power match amount
    float pwr_match = get(&GetInterp, _pwr_match_param);

    // post process, work pwr out scaling
    for (i = 0; i < AUDIO_CHANNELS; ++i) {

        float out_pwr = GetPwr(FFTdata(i), _freq_fft_n / 2 + 1);

        // match the output to the input power
        // power match mode, scale output to match input power
        double pwr_scale = 1.0f;
        if (out_pwr > 1e-30)
            pwr_scale *= _chan[i].total_in_pwr / out_pwr;

        if (pwr_scale > 1e30)
            pwr_scale = 1.0f; // too big
        if (pwr_scale < 1e-30)
            pwr_scale = 0.0f; // too small (or worse, negative)

        _chan[i].out_pwr_scale = lin_interp(pwr_match, 1.0f, (float)pwr_scale);
        _chan[i].out_scale = sqrtf(_chan[i].out_pwr_scale);
    }
}


void ifftAndMixOut(){
  // do iFFT, then fade-in, direct copy and fade-out to output buffer
  for (int i = 0; i < _x2.getNumChannels(); ++i) {
    //float* x2 = _chan[0].x2; // always use x2 from ch0 to help cache performance
    float* x2 = _x2.getWritePointer(i, 0);

    // inverse fft, always ifft into channel-0 x2 to improve cache hits
    FFTWf::execute_dft_c2r(g_ifft_plan[_plan], /*in*/ to_fftwf_complex(FFTdata(i)), /*out*/ x2);

    // skip pre data
    x2 += _data_pre_x0_n;

#if 0
    // scale data
    for(int j = 0; j < _time_fft_n; j++) x2[j] *= chan.out_scale;

    // line mixer
    float* x1 = (float*)chan.x1.ptr;
    LineMix(/*in*/x2, /*in*/chan.x0+_x0_i, /*out*/x1, _time_fft_n, _mixback, /*yscale*/100);
    mixToX3(P1Src(x1, /*scale*/1), i);
#endif

    // output data is completely fft blk
    float x2_scale = (1.0f - _mixback) * _chan.out_scale;
    if (_mixback <= 0.0f)
      mixToX3(P1Src(x2, x2_scale), i);

    else {
      // output data is a mix of original and processed
      P2Src src;
      float* x0_dat = chan.x0;
      src.a = P1Src(x0_dat + _x0_i, _mixback);
      src.b = P1Src(x2, x2_scale);
      mixToX3(src, i);
    }
  }
}

inline void DtBlkFxAudioProcessor::nextBlk()
// internal method
// update everything ready for the next block
//
{
  // get next blk forward
  _next_blk_fwd_n = BlkFxParam::getBlkShiftFwd(get(&GetInterp, _overlap_param), _time_fft_n);

  // get the next overlap param to see if blksync is on

  // synchronize next blk to start-of-beat position if beat_sync
  float beat_sync = get(&GetInterp, _beat_sync_param) * _samps_per_beat;
  if (beat_sync > /*arbitrary*/ 16) {
    // next blk sample position as determined from current overlap param
    long next_blk_samp_abs = _blk_samp_abs + _next_blk_fwd_n;

    // find the sample position of the closest sync position before current next blk
    float units = ceilf((_beat_start_abs - next_blk_samp_abs) / beat_sync);
    long sync_abs = (long)(_beat_start_abs - units * beat_sync);
    long sync_fwd = sync_abs - _blk_samp_abs;

    // LOG("", "nextBlk, blksync" <<VAR(_next_blk_fwd_n) <<VAR(sync_fwd) <<VAR(_blk_samp_abs)
    // <<VAR(next_blk_samp_abs)<<VAR(beats)<<VAR(sync_abs)<<VAR(overlap_param));
    if (sync_fwd > _min_blk_fwd_samps && sync_fwd <= _next_blk_fwd_n)
      _next_blk_fwd_n = sync_fwd;
  }

  _params_state = PARAMS_CHK_SYNC;
  _params_need_processing = true;
}

inline void DtBlkFxAudioProcessor::pollUpdate(bool force)
// internal method, called regularly from process methods
//
// update polled variables from vst host (to do with tempo)
//
{
  if (!force && _curr_samp_abs - _prev_poll_abs < _samps_per_poll)
    return;

  // ask host for tempo
  VstTimeInfo* ti = getTimeInfo(kVstTempoValid | kVstPpqPosValid);
  if (ti) {
    //((MyInfo*)ti)->dbgprint();
    if (ti->flags & kVstTempoValid)
      _samps_per_beat = (float)(60.0 * sampleRate / ti->tempo);

    float ppq_pos = (float)ti->ppqPos;
    float ppq_frac = ppq_pos - floorf(ppq_pos);

    // work out sample position of the start of the current beat
    if (ti->flags & kVstPpqPosValid)
      _beat_start_abs = _curr_samp_abs - (long)(ppq_frac * _samps_per_beat);
  }

  // calculate samples per tick (based on tempo)
  float samps_per_tick = (1.0f / (float)BlkFxParam::TICKS_PER_BEAT) * _samps_per_beat;

  // interpolate params 1/4 beat before the value changes
  _params.setExpectedDist((long)(_samps_per_beat * .25f));

  // LOG("", "pollUpdate"
  // <<VAR(_samps_per_beat)<<VAR(ppq_pos)<<VAR(ppq_frac)<<VAR(_beat_start_abs));

  // poll every beat
  _samps_per_poll = (long)(_samps_per_beat);
  _prev_poll_abs = _curr_samp_abs;

  // min number of samps we can mv fwd to get the next blk
  _min_blk_fwd_samps = max(64L, (long)samps_per_tick);
}
