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

#include "DtBlkFxEditor.h"
#include "DtBlkFxProcessor.h"

DtBlkFxAudioProcessorEditor::DtBlkFxAudioProcessorEditor(DtBlkFxAudioProcessor& p)
    : AudioProcessorEditor(&p)
    , processorRef(p)
    // TODO: UI implementation in progress - commented out for now
    /*, mix_back_attachment_(p.getParamsRef(), "MIX_BACK", mix_back_)
    , delay_attachment_(p.getParamsRef(), "DELAY", delay_)
    , fft_len_attachment_(p.getParamsRef(), "FFTLEN", fft_len_)
    , overlap_attachment_(p.getParamsRef(), "overlap", overlap_)
    , attachments_(attach_fx_arrays(p.getParamsRef(), effects_))*/
{
  juce::ignoreUnused(processorRef);
  // Make sure that before the constructor has finished, you've set the
  // editor's size to whatever you need it to be.
  setSize(500, 900);
  /*mix_back_.setSliderStyle (juce::Slider::LinearBarVertical);
  mix_back_.setRange (0.0, 127.0, 1.0);
  mix_back_.setTextBoxStyle (juce::Slider::NoTextBox, false, 90, 0);
  mix_back_.setPopupDisplayEnabled (true, false, this);
  //mix_back_.setTextValueSuffix (" Volume");
  //mix_back_.setValue (1.0);
    // this function adds the slider to the editor
  addAndMakeVisible (&mix_back_);

  delay_.setSliderStyle (juce::Slider::LinearBarVertical);
  delay_.setRange (0.0, 127.0, 1.0);
  delay_.setTextBoxStyle (juce::Slider::NoTextBox, false, 90, 0);
  delay_.setPopupDisplayEnabled (true, false, this);
    // this function adds the slider to the editor
  addAndMakeVisible (&delay_);

  overlap_.setSliderStyle (juce::Slider::LinearBarVertical);
  overlap_.setRange (0.0, 127.0, 1.0);
  overlap_.setTextBoxStyle (juce::Slider::NoTextBox, false, 90, 0);
  overlap_.setPopupDisplayEnabled (true, false, this);
  overlap_.setTextValueSuffix (" Volume");
  overlap_.setValue (1.0);
    // this function adds the slider to the editor
  addAndMakeVisible (&overlap_);

  addAndMakeVisible(&fft_len_);*/
}

DtBlkFxAudioProcessorEditor::~DtBlkFxAudioProcessorEditor() {
  // TODO: UI implementation in progress - commented out for now
  //attachments_.clear() //Delete Attachments before the slider gets deleted
}

void DtBlkFxAudioProcessorEditor::paint(juce::Graphics& g)
{
  // (Our component is opaque, so we must completely fill the background with a solid colour)
  g.fillAll(getLookAndFeel().findColour(juce::ResizableWindow::backgroundColourId));

  g.setColour(juce::Colours::white);
  g.setFont(15.0f);
  g.drawFittedText("Hello World!", getLocalBounds(), juce::Justification::centred, 1);
}

void DtBlkFxAudioProcessorEditor::resized()
{
  // This is generally where you'll want to lay out the positions of any
  // subcomponents in your editor..
}

// TODO: UI implementation in progress - commented out for now
/*std::vector<EffectUIRowAttachment> attach_fx_arrays(juce::AudioProcessorValueTreeState& state, std::array<EffectUIRow, 8>& rows){
  std::array<juce::String, 8> prefixes = {"FX_1", "FX_2", "FX_3", "FX_4", "FX_5", "FX_6", "FX_7", "FX_8" };

  std::vector<EffectUIRowAttachment> res;
  res.reserve(8);
  std::transform(std::begin(rows), std::end(rows), std::begin(prefixes),
                 std::back_inserter(res),
                 [&state](EffectUIRow& row, const juce::String& prefix){return EffectUIRowAttachment(state, prefix, row);}
                 );
  return res;
}*/
