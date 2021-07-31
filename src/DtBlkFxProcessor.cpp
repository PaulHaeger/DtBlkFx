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

  //_process(inputs, samps);
  for (int i = 0; i < buffer.getNumChannels(); ++i) {
    //PAddOut p(outputs[i]);
    //wrapProcess(p, _chan[i].x3, _x3_o, samps);
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
