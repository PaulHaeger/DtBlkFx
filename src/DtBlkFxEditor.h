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

#pragma once

#include <array>
#include <vector>
#include <algorithm>
#include "DtBlkFxProcessor.h"
#include <juce_gui_basics/juce_gui_basics.h>
#include <juce_gui_extra/juce_gui_extra.h>
#include <juce_audio_processors/juce_audio_processors.h>


/** \brief Creates a group of sliders that can be mapped to an effect group
 *
 * For the Layout see the code of:
 * \see AudioProcessorValueTreeState::ParameterLayout generateParameterLayout()
 **/
struct EffectUIRow {
  juce::Slider freq_a;
  juce::Slider freq_b;
  juce::Slider amp;
  juce::ComboBox type;
  juce::Slider value;
};

struct EffectUIRowAttachment {
  juce::AudioProcessorValueTreeState::SliderAttachment freq_a_attachment;
  juce::AudioProcessorValueTreeState::SliderAttachment freq_b_attachment;
  juce::AudioProcessorValueTreeState::SliderAttachment amp_attachment;
  juce::AudioProcessorValueTreeState::ComboBoxAttachment type_attachment;
  juce::AudioProcessorValueTreeState::SliderAttachment value_attachment;

  EffectUIRowAttachment(juce::AudioProcessorValueTreeState& state, const juce::String& prefix,  EffectUIRow& row)
    : freq_a_attachment(state, prefix + "_FREQ_A", row.freq_a)
      ,freq_b_attachment(state, prefix + "_FREQ_B", row.freq_b)
      ,amp_attachment(state, prefix + "FX_AMP", row.amp)
      ,type_attachment(state, prefix + "FX_TYPE", row.type)
      ,value_attachment(state, prefix + "FX_VAL", row.value)

  {}
};

// TODO: UI implementation in progress - commented out for now
//std::vector<EffectUIRowAttachment> attach_fx_arrays(juce::AudioProcessorValueTreeState& state, std::array<EffectUIRow, 8>& rows);

//==============================================================================
class DtBlkFxAudioProcessorEditor : public juce::AudioProcessorEditor {
public:
  explicit DtBlkFxAudioProcessorEditor(DtBlkFxAudioProcessor&);
  ~DtBlkFxAudioProcessorEditor() override;

  //==============================================================================
  void paint(juce::Graphics&) override;
  void resized() override;

private:
  // This reference is provided as a quick way for your editor to
  // access the processor object that created it.
  DtBlkFxAudioProcessor& processorRef;
  //Global parameters
  // TODO: UI implementation in progress - commented out for now
  /*juce::Slider mix_back_;
  juce::AudioProcessorValueTreeState::SliderAttachment mix_back_attachment_;
  juce::Slider delay_;
  juce::AudioProcessorValueTreeState::SliderAttachment delay_attachment_;
  juce::ComboBox fft_len_;
  juce::AudioProcessorValueTreeState::SliderAttachment fft_len_attachment_;
  juce::Slider overlap_;
  juce::AudioProcessorValueTreeState::SliderAttachment overlap_attachment_;
  //Set of Parametes for each effect
  std::array<EffectUIRow, 8> effects_;
  std::vector<EffectUIRowAttachment> attachments_;*/

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DtBlkFxAudioProcessorEditor)
};
