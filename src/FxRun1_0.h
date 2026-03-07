#ifndef _FX_RUN_1_0_H_
#define _FX_RUN_1_0_H_
/**************************************************************************************************
Copyright (c) 2005-2006 Darrell Tam
email: darrell.barrell@gmail.com

I am trying to move away from the 1.0 style effects because they were developed prior to param
morphing, can't store effect specific params and have become clumsy to deal with

FxRun1_0 : run time object to do the effect, one object per effect
FxRun only exists during the processing of a block. It has no data that persists between blocks.


History
        Date       Version    Programmer         Comments
        16/2/03    1.0        Darrell Tam		Created


This program is free software; you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation; either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

***************************************************************************************************/

#include <juce_core/juce_core.h>
#include "BlkFxParam.h"
#include "MorphParam.h"
#include <string.h>
#include <vector>

class DtBlkFxAudioProcessor;
class FxState1_0;

// number of 1.0 effects
extern const size_t g_num_fx_1_0;

//-------------------------------------------------------------------------------------------------
class FxRun1_0
// 1.0 effects were stateless between runs and processed via this class, one instance per effect
{
protected:
  /** Effect name. */
  juce::String _name;

  /** Whether a particular fx set param is used by this effect.*/
  bool _params_used[BlkFxParam::NUM_FX_PARAMS];

public:
  /** Construct the effect with the given name.*/
  FxRun1_0(juce::String name = "?")
  {
    _name = name;

    // default to all params being used
    for (int i = 0; i < BlkFxParam::NUM_FX_PARAMS; ++i)
      _params_used[i] = true;
  }

  virtual ~FxRun1_0() {}

  /** Performes the effect processing using the given state.*/
  virtual void process(FxState1_0* s) {juce::ignoreUnused(s);}

  /** \brief Appends the display text corresponding to "val".
   *
   * \pram[in] s the state of the current effect.
   * \param[in, out] text the string to append the text to.
   * \param[in] val the value to output.
   **/
  virtual juce::String& dispVal(FxState1_0* s, juce::String& text, float /*0..1*/ val)
  {
      juce::ignoreUnused(s);
      juce::ignoreUnused(val);
    return text << "-";
  }

  /** Gets the effect name. */
  virtual const juce::String& name() const { return _name; }

  /** \brief Checks if for a particular effect the (local) parameter is used.
   *
   * The valid indices are between `0`` and `NUM_FX_PARAMS-1`.
   **/
  virtual bool paramUsed(int param_idx) { return _params_used[param_idx]; }

   /** Return true if amp is used as a mix between instead of -inf to 0 dB but normal after that
   * default is amp is dB all the time
   *
   * \return false if amp is dB and true if not.
   **/
  virtual bool ampMixMode() { return false; }

public: // methods for the GUI
  // is this a mask effect or a normal?
  virtual bool isMask() { return false; }

  //
  virtual const char* getValueName(size_t idx)
  {
    if (!idx_within(idx, _value_presets))
      return nullptr;
    return _value_presets[idx].str.toRawUTF8();
  }

  /** Returns the value for parameter `idx`. If `idx` is out of range,
   * `curr_val` will be returned.
   **/
  virtual float getValue(size_t idx, float curr_val)
  {
    return idx >= _value_presets.size() ? curr_val : _value_presets[idx].val;
  }

public: // internal stuff to do with value presets

  struct ValuePreset {
    float val;
    juce::String str;
  };

  /* Internal Method. Appends to `_value_presets` the number of `num_presets` values
   * and fills them in a linear fashion, starting from `out_min`
   * going up to one step short of `out_max`. If `rng_inclusive` is set, the values
   * will increase fully to `out_max`
   **/
  void _fillValues(size_t num_presets, float out_min = 0.0f, float out_max = 1.0f,
                   bool rng_inclusive = true);

  /** Appends the values from the `Rng<float>` to the `_value_presets` array.
   * */
  void _fillValues(Rng<float> values);

  //
  std::vector<ValuePreset> _value_presets;
};

// get fx run corresponding to "idx"
FxRun1_0* GetFxRun1_0(size_t idx);

#endif
