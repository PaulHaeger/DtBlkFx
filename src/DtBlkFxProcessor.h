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

#include "MorphParam.h"

#pragma once

#include <juce_audio_processors/juce_audio_processors.h>

class DtBlkFxAudioProcessor : public juce::AudioProcessor {
public:
  DtBlkFxAudioProcessor();
  ~DtBlkFxAudioProcessor() override;

  void prepareToPlay(double sampleRate, int samplesPerBlock) override;
  void releaseResources() override;

  bool isBusesLayoutSupported(const BusesLayout& layouts) const override;

  void processBlock(juce::AudioBuffer<float>&, juce::MidiBuffer&) override;
  using AudioProcessor::processBlock;

  juce::AudioProcessorEditor* createEditor() override;
  bool hasEditor() const override;

  const juce::String getName() const override;

  bool acceptsMidi() const override;
  bool producesMidi() const override;
  bool isMidiEffect() const override;
  double getTailLengthSeconds() const override;

  int getNumPrograms() override;
  int getCurrentProgram() override;
  void setCurrentProgram(int index) override;
  const juce::String getProgramName(int index) override;
  void changeProgramName(int index, const juce::String& newName) override;

  void getStateInformation(juce::MemoryBlock& destData) override;
  void setStateInformation(const void* data, int sizeInBytes) override;

private:
  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DtBlkFxAudioProcessor)
public:
  MorphParam _mixback_param;
  MorphParam _delay_param;
  MorphParam _fft_len_param;
  MorphParam _overlap_param;

  MorphParam _pwr_match_param; // 0=filter mode, 1=pwr match
  MorphParam _beat_sync_param;
  MorphParam _param_sync_param;

  // blk fraction to be used as a shoulder - the shoulder is extra data on
  // the left and right of the blk that is transformed but not mixed back to output
  MorphParam _blk_shoulder_frac_param;

  // window applied to shoulder (only applicable when _blk_shoulder_frac_param is > 0)
  MorphParam _blk_shoulder_wdw_param;

  // interpolation envelope for blk mix
  MorphParam _blk_mix_param;

  // which vst param index is in focus in the GUI
  VstParamIdx _vst_param_idx_focus;
  void* _vst_param_idx_focus_cookie;

  // access program number
  int currProgramNum() { return limit_range(curProgram, 0, (int)_program.size() - 1); }

  // access current preset
  BlkFxProgram& currProgram() { return _program[currProgramNum()]; }

public: // gui state stuff
  //
  bool _param_morph_mode;
  bool isMorphMode() const { return _param_morph_mode; }

public:
  // contiguous space for chunk data & presets when saving
  std::valarray<unsigned char> _chunk_data;
};
