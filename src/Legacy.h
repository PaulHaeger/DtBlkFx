/**
 * \brief This header contains the legacy conversion functions necessary for the old format.
 **/
#ifndef _DT_BLKFX_LEGACY_H
#define _DT_BLKFX_LEGACY_H

#include "NoteFreq.h"
#include "misc_stuff.h"
#include <math.h>
#include <map>
#include <functional>
#include "BlkFxParam.h"

namespace BlkFxParam{
namespace Legacy{
  using namespace juce;
  //
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

// --- FFT_LEN
// ---------------------------------------------------------------------------------------------
inline long /*plan index*/ getPlan(float /*0..1*/ fft_len_param)
// given vst param for fft_len, return fft plan number
{
  // scaling is compatible with 1.0 version
  return limit_range((int)(fft_len_param * 255.0f / 4.0f - 1.5f), 0, NUM_FFT_SZ - 1);
}

inline float getPlanf(float fft_len_param){
  return static_cast<float>(getPlan(fft_len_param));
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
inline long /*index*/ getEffectType(float /*0..1*/ param)
{
  // align to renoise effect values, allow for up to 32 possible effects
  return (long)(param * 255.0) / 8;
}

inline float getEffectTypef(float param){
  return static_cast<float>(getEffectType(param));
}

// inverse function to return the effect type param given an index
inline float /*param 0..1*/ getEffectTypeInv(long index)
{
  return (float)(index * 8 + 4) / 255.0f;
}

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

/** Identity function, this returns the argument*/
inline float identity(float x) { return x; }

inline std::map<juce::Identifier, std::function<float(float)>> _generateMap(){
   std::map<juce::Identifier, std::function<float(float)>> m;

   //GLOBAL PARAMETERS
   m[paramsIds[0]] = identity; //MIX_BACK
   m[paramsIds[1]] = identity; //DELAY
   m[paramsIds[2]] = getPlanf;
   m[paramsIds[3]] = identity; //OVERLAP

   //Local Parameters, do this for each group
   //NOTE: Preset data is already normalized (0..1), so we use identity for all params
   //including FX_TYPE. The old getEffectTypef was wrong - it expected unnormalized data.
   for(unsigned int i=0; i < NUM_FX_SETS; ++i){
    m[paramsIds[NUM_GLOBAL_PARAMS + NUM_FX_PARAMS * i]] = identity; //FREQ_A
    m[paramsIds[NUM_GLOBAL_PARAMS + NUM_FX_PARAMS * i + 1]] = identity; //FREQ_B
    m[paramsIds[NUM_GLOBAL_PARAMS + NUM_FX_PARAMS * i + 2]] = identity; //FX_AMP
    m[paramsIds[NUM_GLOBAL_PARAMS + NUM_FX_PARAMS * i + 3]] = identity; //FX_TYPE (already normalized!)
    m[paramsIds[NUM_GLOBAL_PARAMS + NUM_FX_PARAMS * i + 4]] = identity; //FX_VAL
   }

   return m;
}

const std::map<juce::Identifier, std::function<float(float)>> paramMap = _generateMap();



}
}

#endif
