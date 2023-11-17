#ifndef _DT_BLKFX_PARAM_H_
#define _DT_BLKFX_PARAM_H_
/**************************************************************************************************
Copyright (c) 2005-2006 Darrell Tam
email: darrell.barrell@gmail.com

BlkFxParam : namespace to help with VST parameters used by DtBlkFx

History
        Date       Version    Programmer         Comments
        01/12/05    1.0        Darrell Tam		Created


This program is free software; you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation; either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

***************************************************************************************************/

#include "NoteFreq.h"
#include "misc_stuff.h"
#include "rfftw_float.h"
#include <math.h>
#include <juce_audio_processors/juce_audio_processors.h>
#include <vector>
#include <map>
#include <stdexcept>

// namespace to hold stuff to do with vst params used in dt blkfx

/**
 * Namespace containing everything associated with the plugin parameters used in DtBlkFx.
 **/
namespace BlkFxParam {
    using namespace juce;

    /**
    * \brief Enum that contains the plugin ids for the parameters as well as the number of parameters.
    *
    * The first set is for the  global parameters, giving the associated ids.
    * The last entry of the set `NUM_GLOBAL_PARAMS` tells how many global params there are.
    *
    * The second set is for the parameters of one FX set. Each entry gives the local index for
    * the different parameters. The last entry `NUM_FX_PARAMS` tells how many parameters there are per FX set.
    *
    * `NUM_FX_SETS` says how many FX sets there are in total for this plugin.
    * `TOTAL_NUM` contains the total number of plugin parameters for the plug in.
    *
    * `TIKS_PER_BEAT` contain how many time ticks per beat there are for the interpolation.
    *
    * `AUDIO_CHANNELS` contains the number of audio channels.
    * \warning `AUDIO_CHANNELS` may be removed in the future if the number of channels is decided at runtime.
    **/
    typedef enum {
      // global params that apply to all fx
      MIX_BACK = 0, // original mix back fraction & power match control
      DELAY,        // delay units is 1/4 * signature * bpm
      FFT_LEN,      // fft len is
      OVERLAP,      // overlap fraction
      NUM_GLOBAL_PARAMS,

      // each set of fx has these params (add i*NUM_FX+NUM_GLOBAL)
      FX_FREQ_A = 0,
      FX_FREQ_B,
      FX_AMP,
      FX_TYPE,
      FX_VAL,
      NUM_FX_PARAMS,

      NUM_FX_SETS = 8,
      TOTAL_NUM = NUM_GLOBAL_PARAMS + NUM_FX_PARAMS * NUM_FX_SETS,

      // number of ticks per beat
      TICKS_PER_BEAT = 16,

# define STEREO
    //TODO: Make MONO/STEREO selection dynamic instead of precompiled
#ifdef STEREO
      AUDIO_CHANNELS = 2
#elif MONO
      AUDIO_CHANNELS = 1
#else
#  error define STEREO or MONO
#endif
    } constants;

    /** Function that generates the parameter layout for the plugin.
     **/
    AudioProcessorValueTreeState::ParameterLayout generateParameterLayout();

    /* Array that makes it possible to recover the associated Identifier
     * for a particular parameter index. May be necessary to address
     * parameters stored in a `AudioProcessorValueTreeState`.
     **/
    const std::array<juce::Identifier, TOTAL_NUM> paramsIds = {
        /*-----Global Parameters-------*/
        Identifier("MIX_BACK"),
        Identifier("DELAY"),
        Identifier("FFTLEN"),
        Identifier("OVERLAP"),
        /*-----FX_1 Parameters---------*/
        Identifier("FX_1_FREQ_A"),
        Identifier("FX_1_FREQ_B"),
        Identifier("FX_1_FX_AMP"),
        Identifier("FX_1_FX_TYPE"),
        Identifier("FX_1_FX_VAL"),
        /*-----FX_2 Parameters---------*/
        Identifier("FX_2_FREQ_A"),
        Identifier("FX_2_FREQ_B"),
        Identifier("FX_2_FX_AMP"),
        Identifier("FX_2_FX_TYPE"),
        Identifier("FX_2_FX_VAL"),
        /*-----FX_3 Parameters---------*/
        Identifier("FX_3_FREQ_A"),
        Identifier("FX_3_FREQ_B"),
        Identifier("FX_3_FX_AMP"),
        Identifier("FX_3_FX_TYPE"),
        Identifier("FX_3_FX_VAL"),
        /*-----FX_4 Parameters---------*/
        Identifier("FX_4_FREQ_A"),
        Identifier("FX_4_FREQ_B"),
        Identifier("FX_4_FX_AMP"),
        Identifier("FX_4_FX_TYPE"),
        Identifier("FX_4_FX_VAL"),
        /*-----FX_5 Parameters---------*/
        Identifier("FX_5_FREQ_A"),
        Identifier("FX_5_FREQ_B"),
        Identifier("FX_5_FX_AMP"),
        Identifier("FX_5_FX_TYPE"),
        Identifier("FX_5_FX_VAL"),
        /*-----FX_6 Parameters---------*/
        Identifier("FX_6_FREQ_A"),
        Identifier("FX_6_FREQ_B"),
        Identifier("FX_6_FX_AMP"),
        Identifier("FX_6_FX_TYPE"),
        Identifier("FX_6_FX_VAL"),
        /*-----FX_7 Parameters---------*/
        Identifier("FX_7_FREQ_A"),
        Identifier("FX_7_FREQ_B"),
        Identifier("FX_7_FX_AMP"),
        Identifier("FX_7_FX_TYPE"),
        Identifier("FX_7_FX_VAL"),
        /*-----FX_8 Parameters---------*/
        Identifier("FX_8_FREQ_A"),
        Identifier("FX_8_FREQ_B"),
        Identifier("FX_8_FX_AMP"),
        Identifier("FX_8_FX_TYPE"),
        Identifier("FX_8_FX_VAL"),
    };

    const Identifier idNodeProgram("PROGRAM");
    const Identifier idProgName("PROGRAMNAME");
    const Identifier idNodeGlobal("GLOBAL");
    const Identifier idNodeFX1("FX1");
    const Identifier idNodeFX2("FX2");
    const Identifier idNodeFX3("FX3");
    const Identifier idNodeFX4("FX4");
    const Identifier idNodeFX5("FX5");
    const Identifier idNodeFX6("FX6");
    const Identifier idNodeFX7("FX7");
    const Identifier idNodeFX8("FX8");

    /** Returns an identifier for the parameter group the given parameter with
     * Id `index` belongs to. In case the index is out of range a `std::runtime_error` is
     * thrown.
     **/
    inline const Identifier& getGroupForIndex(unsigned int index){
        //Global parameters
        if(index >= TOTAL_NUM){
            throw std::out_of_range("Index higher than number of parameters.");
        }
        if(index < NUM_GLOBAL_PARAMS){
            return idNodeGlobal;
        }
        auto shifted = index - NUM_GLOBAL_PARAMS;
        auto fx_slot = shifted % NUM_FX_PARAMS;
        switch(fx_slot){
            case 0:
                return idNodeFX1;
            case 1:
                return idNodeFX2;
            case 2:
                return idNodeFX3;
            case 3:
                return idNodeFX4;
            case 4:
                return idNodeFX5;
            case 5:
                return idNodeFX6;
            case 6:
                return idNodeFX7;
            case 7:
                return idNodeFX8;
        }

        //This should be unreachable
        throw std::runtime_error("This should be unreachable!");
    }

    /* \brief Generates a ValueTree that can be used to swap APVTS states.
     *
     * \note This Function will return an invalid tree if the APVTS has an invalid tree.
     *
     * \param[in] apvts The APVTS the structure will be based of. The resulting tree can be used
     *     for a swap.
     *
     * \return The generated ValueTree.
     */
    ValueTree generateValueTree(AudioProcessorValueTreeState& apvts);

    /* \brief Loads the data from the old format.
     * This Function uses a reference to the apvts to construct the appropiate
     * ValueTree structure. Then it reads the data and writes it into the structure.
     * Upon error an invalid tree will be returned.
     *
     * \param[in] apvts ValueTreeState used to construct the tree from.
     * \param[in] stringData The string containing the data.
     *
     * \return The read ValueTree
     */
    ValueTree loadFromLegacyFormat(AudioProcessorValueTreeState& apvts, const String& stingData);


    /** Function used internally. Initializes a std::map that makes it possible
     * to transform a parameter identifier to the corresponding index.
     **/
    inline std::map<Identifier, unsigned int> createIdIndexMap() {
        std::map<Identifier, unsigned int> idMap;
        for (unsigned int i=0; i < paramsIds.size(); ++i) {
            idMap.emplace(paramsIds[i], i);
        }
        return idMap;
    };

    /** Maps that transforms a parameter identifier to the corresponding index. **/
    const std::map<Identifier, unsigned int> idIndexMap = createIdIndexMap();


    /**\brief Get the parameter offset given an fx set.
     *
     * For the index of a fx_set it returns how many parameters were there before.
     **/
    inline unsigned int paramOffs(unsigned int fx_set)
    {
      return NUM_GLOBAL_PARAMS + fx_set * NUM_FX_PARAMS;
    }

    /** \brief Struct holding information about a parameter index.
     *
     * This struct makes it possible to query further information about
     * a parameter id. For example with this you can determine if the parameter is
     * global or belongs to a fx set, as well as the 'local' parameter index.
     * This information is determined automatically be the struct.
     **/
    struct SplitParamNum {
      int param;      /** The index of the parameter. */
      bool isOk;        /** Is `true` if the parameter index `param` is in range and thus valid.*/
      int glob_param; /** If the index `param` belongs to a global parameter, it will contain 'local' index of the parameter. Else it will be `-1`, meaning the param belongs to an effect set or invalid. */
      int fx_set;     /** If the index `param` belongs to an effect set, then this will contain
     the index of the fx_set it belongs to. Else it will be `-1`, meaning the param is global or invalid.. */
      int fx_param;   /** If the index `param` belongs to an effect set, this will contain the 'local' parameter index. Else it will be `-1`, meaning the param is global or invalid. */

      /** This constructor determines all the extra information for
       * a given parameter index.
       **/
      SplitParamNum(int param_num)
      {
        param = param_num;
        fx_param = -1;
        glob_param = -1;
        fx_set = -1;
        isOk = false;
        if (param_num < 0 || param_num >= TOTAL_NUM)
          return;

        isOk = true;
        fx_set = param_num - NUM_GLOBAL_PARAMS;
        if (fx_set < 0) {
          // global param
          fx_set = -1;
          glob_param = param_num;
        }
        else {
          // param belongs to effect set
          fx_param = fx_set % NUM_FX_PARAMS;
          fx_set = limit_range(fx_set / NUM_FX_PARAMS, 0, NUM_FX_SETS - 1);
        }
      }
    };

    // --- MIXBACK
    // ---------------------------------------------------------------------------------------------
    inline float getPwrMatch(float /*0..1*/ mixback_param)
    // get pwr match part of mixback param
    {
      return mixback_param <= 0.5f ? 1.0f : 0.0f;
    }

    inline float getMixBackFrac(float /*0..1*/ mixback_param)
    // get the mixback fraction of the mixback param
    {
      return limit_range(mixback_param <= 0.5f ? mixback_param * 2.0f
                                               : (1.0f - mixback_param) * (1.0f / 0.499f),
                         0.0f,
                         1.0f);
    }

    inline float /*0..1*/ getMixbackParam(float /*0..1*/ mixback_frac, bool pwr_match)
    // combine pwr match and mixback fraction into overlap param
    {
      return pwr_match ? limit_range(mixback_frac * 0.5f, 0.0f, 0.5f)
                       : limit_range(1.0f - mixback_frac * 0.499f, 0.501f, 1.0f);
    }

    // --- DELAY
    // -----------------------------------------------------------------------------------------------
    struct Delay
        : public SplitParam<2>
    // f_part is converted to delay units (beats or msec)
    {
      // possible values for i_part
      typedef enum { BEATS = 0, MSEC = 1 } Units;

      // split param
      Delay(float /*0..1*/ param = 0.0f) { operator()(param); }

      // construct using amount
      Delay(Units units, float amount) { setAmount(units, amount); }

      // set param in given beats or msec
      void setAmount(Units units, float amount /* beats or msec */)
      {
        setUnits(units);
        f_part = limit_range(
            amount * (i_part == MSEC ? 1.0f / 6000.0f : 2.0f * TICKS_PER_BEAT / 255.0f), 0.0f, 1.0f);
      }

      // return fractional part as beats or msec (depending on i_part)
      float /*beats or msec*/ getAmount() const
      {
        return f_part * (i_part == MSEC ? 6000.0f : 0.5f * 255.0f / TICKS_PER_BEAT);
      }

      // get/set i_part in units
      Units getUnits() const { return (Units)i_part; }
      void setUnits(Units new_units) { i_part = (int)new_units; }

      //
      static Delay beats(float /*beats*/ v) { return Delay(BEATS, v); }
      static Delay msec(float /*msec*/ v) { return Delay(MSEC, v); }
    };

    // --- FFT_LEN
    // ---------------------------------------------------------------------------------------------
    inline long /*plan index*/ getPlan(float /*0..1*/ fft_len_param)
    // given vst param for fft_len, return fft plan number
    {
      // scaling is compatible with 1.0 version
      return limit_range((int)(fft_len_param * 255.0f / 4.0f - 1.5f), 0, NUM_FFT_SZ - 1);
    }

    inline float /*0..1*/ getFFTLenParam(int plan_index)
    // turn plan index into fft length
    {
      // scaling is compatible with 1.0 version
      return limit_range(((float)plan_index + 2.0f) * (4.0f / 255.0f), 0.0f, 1.0f);
    }

    // --- OVERLAP
    // ---------------------------------------------------------------------------------------------
    inline bool getBlkSync(float /*0..1*/ overlap_param)
    // get blk sync part of the overlap param
    {
      return overlap_param > 0.5f;
    }

    inline float getOverlapPart(float /*0..1*/ overlap_param)
    // get the overlap part of the overlap param
    {
      return overlap_param > 0.5f ? 2.0f - overlap_param * 2.0f : overlap_param * 2.0f;
    }

    inline long getBlkShiftFwd(float /*0..1*/ overlap_param, int blk_len)
    // return number of samples we will shift forward in the blk given the overlap_param
    {
      long fwd_n = (long)lin_interp(overlap_param,
                                    (float)(blk_len - 16), // overlap=0: maximum shift
                                    (float)blk_len * .15f  // overlap=1: mimimum shift
      );
      if (fwd_n < 32)
        fwd_n = 32;
      return fwd_n;
    }

    inline float /*0..1*/ getOverlapParam(float /*0..1*/ overlap_part, bool sync)
    //
    // combine overlap part and sync into overlap param
    //
    // overlap_part units are 0=approx 0%, 1=approx 85% (depends on blk sz)
    //
    {
      return sync ? limit_range((2.0f - overlap_part) * 0.5f, 0.501f, 1.0f)
                  : limit_range(overlap_part * 0.5f, 0.0f, 0.499f);
    }

    // --- FX_FREQ_A/FX_FREQ_B --------------------------------------------------------------------
    // freq params correspond to exponential frequency which means that octaves are
    // linear and the param is actually a note offset from c0

    // number of notes spanned in freq param
    inline float noteSpan()
    {
      return 255.0f * 0.5f;
    }

    // number of octaves spanned in freq param
    inline float octaveSpan()
    {
      return noteSpan() / 12.0f;
    }

    // fraction of freq param corresponding to 1 octave
    inline float octaveFrac()
    {
      return 1.0f / octaveSpan();
    }

    // fraction of freq param corresponding to 1 note
    inline float noteFrac()
    {
      return 1.0f / noteSpan();
    }

    inline float /*freq hz*/ getHzNonZero(float /*0..1*/ param)
    // map the vst param to a freq (with no 0 hz)
    {
      return NoteOffsToHz(/*offs c0*/ param * noteSpan());
    }

    inline float /*freq hz*/ getHz(float /*0..1*/ param)
    // if param is 0 then return 0, otherwise return "getFreqNonZero"
    {
      return param <= 0.0f ? 0.0f : getHzNonZero(param);
    }

    inline void genPixelToHz(Rng<float> /*out*/ dst_data)
    {
      ValStp<float> param(0.0f, 1.0f / (float)dst_data.n);
      for (int i = 0; i < (int)dst_data.n; i++) {
        dst_data[i] = BlkFxParam::getHz(param);
        param.next();
      }
    }

    // --- FX_TYPE --------------------------------------------------------------------------------
    unsigned int /*index*/ getEffectType(float /*0..1*/ param);

    // inverse function to return the effect type param given an index
    float /*param 0..1*/ getEffectTypeInv(long index);

    // --- FX_AMP ---------------------------------------------------------------------------------
    inline float /*dB*/ getEffectAmp(float /*0..1*/ param)
    {
      return lin_interp(param, -60.0f, 40.0f);
    }

    // turn db into param
    inline float /*0..1*/ getAmpParam(float db /*-60 .. 40*/)
    {
      return limit_range(db * 0.01f + 0.6f, 0.0f, 1.0f);
    }

    // get 0dB point of amp param
    inline float getAmpParam0dB()
    {
      return getAmpParam(0);
    }

    inline float /*multiply*/ getEffectAmpMult(float /*0..1*/ param, bool mix_mode)
    // convert amp param into linear multiplier (i.e. param->dB->linear)
    // if mix_mode is true and amp is less than 0dB point, linear
    {
      // check for mix_mode linear range
      if (mix_mode && param < getAmpParam0dB())
        return param * (1.0f / getAmpParam0dB());

      // normal exponential range
      return param <= 0.0f ? 0.0f : powf(10.0f, getEffectAmp(param) * 0.05f);
    }

}; // namespace BlkFxParam

#endif
