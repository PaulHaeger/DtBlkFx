#ifndef _DT_MORPH_PARAM_H_
#define _DT_MORPH_PARAM_H_

#include <valarray>

#include "ParamsDelay.h"
#include "misc_stuff.h"

class MorphParam;

//-------------------------------------------------------------------------------------------------
struct MorphParamArrayAccess
// array style access to MorphParam
{
  _Ptr<MorphParam> morph;

  //
  unsigned int idx;

  // since morph params are actually 2-d arrays, this controls the direction
  bool idx_is_anchor; // false = idx is param number

  size_t size();
  float operator[](size_t i) const;
  float& operator[](size_t i);
};

//-------------------------------------------------------------------------------------------------
/**
 * each morph param has a particular number of points that are interpolated using
 * a vst-param as an index so as to produce the final param
 **/
class MorphParam

{
public:
  /** Interpolation Modes**/
  enum Mode {
    MODE_FIXED,      /** ignore vst_param_idx & always use `anchor_data[0]`.**/
    MODE_LIN_INTERP, /** linear interpolate morph data.**/
    MODE_STEP,       /** step morph data. **/
    MODE_CLOSEST_ANCHOR = MODE_STEP /** Alias of `MODE_STEP`.**/
  };

protected: // internals
  /**¸\brief Morph control point data.
   *
   * In contigous 2d array format, meaning  `anchor_data[anchor idx][param idx]`
   * is read with `anchor_data[param_n * anchor_idx + param_idx]`.
   * The size will thus always be `anchor_n * param_n`.
   **/
  std::valarray<float> anchor_data;

  /** Number of morph anchor points.**/
  unsigned int anchor_n;

  /** Number of params. **/
  unsigned int param_n;

  /** Parameter the object is attached to. **/
  unsigned int plugin_param_idx;

  /** Current Interpolation mode. For more see \ref MorphParam::Mode. **/
  Mode mode;

public:
  /** Gets the current Mode. **/
  Mode getMode() const { return mode; }

  /** Allows for casting to `Mode` enum, returning the current mode.**/
  explicit operator Mode() const { return mode; }

  /** Sets the new mode. **/
  MorphParam& operator=(Mode mode_)
  {
    mode = mode_;
    return *this;
  }

  /** Compares the current mode to the passed one.**/
  bool operator==(Mode rhs) const {return mode == rhs;}

  /** Sets the morph mode to `MODE_FIXED`. **/
  void setModeFixed() { mode = MODE_FIXED; }

  /** Sets the Morph Mode to `MODE_LIN_INTERP` and sets the attached parameter id (`plugin_param_idx`).**/
  void setModeLin(unsigned int param_idx_)
  {
    plugin_param_idx = param_idx_;
    mode = MODE_LIN_INTERP;
  }

  /** Sets the Morph Mode to `MODE_STEP` and sets the attached parameter id (`plugin_param_idx`).**/
  void setModeStep(unsigned int param_idx_)
  {
    plugin_param_idx = param_idx_;
    mode = MODE_STEP;
  }

public:
  /** Default Constructor. Sets the mode to `MODE_FIXED` and the number of anchors and parameters to 1.
   **/
  MorphParam()
  {
    setModeFixed();
    param_n = 1;
    anchor_n = 1;
    plugin_param_idx = 0;
    anchor_data.resize(/*num params*/ param_n * anchor_n, /*value*/ 0);
  }

  /** Gets the current ParamId of the parameter the object is attached to.
   *
   * \return The id or `-1` if the mode is set to `MODE_FIXED`.
   **/
  int /*-1 if in MODE_FIXED*/ getParamId() const
  {
    return mode == MODE_FIXED ? -1 : plugin_param_idx;
  }

  /** Returns the number of params. **/
  unsigned int numParams() const { return param_n; }

  /** Returns the number of anchor points. **/
  unsigned int numAnchorPoints() const { return anchor_n; }

  /** \brief Sets the number of anchor points.
   *
   *  If the number of anchor points is larger than before, the
   *  internal array will be resized to fit. If the number of anchor
   *  points is less, then the array will not be resized.
   **/
  void setNumAnchorPoints(unsigned int n)
  {
    // only grow (so data is not lost if shrunk)
    if (n > anchor_n){
      anchor_data.resize(n * param_n, 0.0f);
    }
    anchor_n = n;
  }

  /** \brief Sets the number of parameters.
   *
   * The internal array will always be resized and
   * all the data that can be preserved will be preserved.
   **/
  void setNumParams(unsigned int n)
  {
    unsigned int old_param_n = param_n;
    param_n = n;

    // resize and clear
    std::valarray<float> old_anchor_data = anchor_data;
    anchor_data.resize(anchor_n * param_n, 0.0f);

    // copy old morph params across
    size_t bytes_cpy = sizeof(float) * std::min(old_param_n, param_n);
    for (unsigned int i = 0; i < anchor_n; ++i){
      memcpy(anchorData(i), begin(old_anchor_data) + i * old_param_n, bytes_cpy);
    }
  }

  // set all morph points from "src_data", src data must be contiguous 2d array
  // in format [anchor_idx][param_idx]
  /** \breif Sets all morph points.
   *
   * The source data passed must be a flat 2d array in the form of \ref MorphParam::anchorData.
   * That means `anchor_data[anchor idx][param idx] will be accessed in the form of
   * `anchor_data[anchor_idx * param_n + param_idx]`.
   *
   * The container `anchor_data` will always be resized to hold all datapoints.
   *
   * \param src_data source data that this method copies from.
   * \param param_n_ Number of params per anchor point. Anchor size is computed on the fly.
   **/
  void setAll(Rng<float> src_data, unsigned int param_n_ = 1)
  {
    param_n = param_n_;
    anchor_n = src_data.n / param_n;
    anchor_data.resize(param_n * anchor_n);
    src_data.copyTo(begin(anchor_data));
  }

  /** \brief Returns an accessor for the particular anchor array at `param_idx`.
   *
   * The returned accesor `MorphParamArrayAccess` has `operator[size_t]` overloaded
   * that allows direct array access to the parameters.
   **/
  MorphParamArrayAccess anchorArray(unsigned int param_idx = 0)
  {
    return {this, /*idx*/ param_idx, /*is_anchor*/ false};
  }

  /** \brief Returns an accessor for the anchors at parameter `anchor_idx`.
   *
   * The returned accesor `MorphParamArrayAccess` has `operator[size_t]` overloaded
   * that allows direct array access to the parameters.
   **/
  MorphParamArrayAccess paramArray(unsigned int anchor_idx = 0)
  {
    return {this, /*idx*/ anchor_idx, /*is_anchor*/ true};
  }

  // limit anchor index
  unsigned int limitAnchorIdx(unsigned int anchor_idx) const { return limit_range(anchor_idx, 0, anchor_n - 1); }

  unsigned int limitParamIdx(unsigned int param_idx) const { return limit_range(param_idx, 0, param_n - 1); }

  // get params morph data for a particular anchor index (data is param_n long)
  const float* anchorData(unsigned int anchor_idx) const
  {
    const float* it = std::begin(anchor_data);
    return it + limitAnchorIdx(anchor_idx) * param_n;
  }

  float* anchorData(unsigned int anchor_idx)
  {
    float* it = std::begin(anchor_data);
    return it + limitAnchorIdx(anchor_idx) * param_n;
  }

  float& anchorData(unsigned int anchor_idx, unsigned int param_idx) {
      return anchorData(anchor_idx)[param_idx];
  }

  // given a fraction, return closest anchor idx
  unsigned int closestAnchorIdx(float /*0..1*/ idx_f) const
  {
    return RndToUInt(lin_interp_limit(idx_f, 0.0f, static_cast<float>(anchor_n) - 1));
  }

  // find what fraction a particular anchor index corresponds to
  float /*0..1*/ anchorIdxToFrac(unsigned int anchor_idx) const
  {
    return anchor_n > 1 ? static_cast<float>(limitAnchorIdx(anchor_idx)) / (static_cast<float>(anchor_n) - 1) : 0.5f;
  }

  // return anchor data from rounded morph position (equivalent to MODE_STEP)
  const float* closestAnchorData(float /*0..1*/ idx_f) const
  {
    return anchorData(closestAnchorIdx(idx_f));
  }

  float* closestAnchorData(float /*0..1*/ idx_f)
  {
    return anchorData(closestAnchorIdx(idx_f));
  }

  // get a particular anchor point
  float get(unsigned int anchor_idx, unsigned int param_idx = 0) const
  {
    return anchorData(anchor_idx)[limitParamIdx(param_idx)];
  }

  // set a morph control point to "value"
  void set(float value, unsigned int anchor_idx = 0, unsigned int param_idx = 0)
  {
    anchorData(anchor_idx)[limitParamIdx(param_idx)] = value;
  }

  /** Get morph data given the control param with forced mode.
   *
   *  \return num values written.
   *  \param[in] float control position of morph (ignored if MODE_FIXED), 0..1.
   *  \param[out] result destination.
   *  \param[in] param_idx first index of param to return.
   *  \param[in] mode_  Mode to be forced.
   **/
  int get(float morph_pos, Rng<float> result, unsigned int param_idx, int mode_) const
  {
    unsigned int max_n = param_n - param_idx;
    if (result.n > max_n)
      result.n = max_n;
    if (result.n <= 0)
      return 0;

    // otherwise normal interpolation
    switch (mode_) {
      case MODE_LIN_INTERP: {
        // linear interpolation
        float t = morph_pos * static_cast<float>(anchor_n - 1);
        float floor_t = floorf(t);
        unsigned int i = static_cast<unsigned int>(floor_t);
        const float* src0 = anchorData(i) + param_idx;
        const float* src1 = anchorData(i + 1) + param_idx;
        float mix1 = t - floor_t;
        float mix0 = 1 - mix1;

        for (; result.n; result.adjStart(1))
          *result = *src0++ * mix0 + *src1++ * mix1;
        break;
      }

      case MODE_STEP:
        // copy closest anchor data
        result.copyFrom(closestAnchorData(morph_pos) + param_idx);
        break;

      default:
        // always copy from anchor data morph position 0
        result.copyFrom(anchorData(/*anchor idx*/ 0) + param_idx);
    }
    return result.n;
  }

  /** Get morph data given the control param. Uses the currently set mode.
   *
   *  \return num values written.
   *  \param[in] float control position of morph (ignored if MODE_FIXED), 0..1.
   *  \param[out] result destination.
   *  \param[in] param_idx first index of param to return.
   **/
  int get(float morph_pos, Rng<float> result, unsigned int param_idx = 0) const
  {
    return get(morph_pos, result, param_idx, mode);
  }

  // get results using morph param out of "vst_param_array"
  // e.g
  //     MorphParam my_param;
  //     my_param.setNumParams(4);
  //
  //     float result[4];
  //
  //     // get control param out of an array of float
  //     float my_float_array[10];
  //     my_param.update(my_float_array, /*out*/result);
  //
  //     // get control param out of a params delay
  //     ParamsDelay<10> my_paramsdelay;
  //     my_param.update(my_paramsdelay.getInterpFn(), /*out*/result);
  //
  template <class T>
  int /*elements copied*/ get(const T& param_array, Rng<float> result, unsigned int param_idx = 0) const
  {
    return get(mode != MODE_FIXED ? param_array[plugin_param_idx] : 0.0f, result, param_idx);
  }

  // get a single param
  template <class T> float getSingle(T& t /*float 0..1 or array of float*/, unsigned int param_idx = 0) const
  {
    Array<float, 1> r;
    get(t, /*out*/ r, param_idx);
    return r[0];
  }

  // operator() calls "getSingle"
  template <class T> float operator()(const T& t, unsigned int param_idx = 0) const
  {
    return getSingle(t, param_idx);
  }

  //
  bool /*got point*/ nextLineDrawPoint(unsigned int& state, float& /*0..1*/ x, float& /*0..1*/ y,
                                       unsigned int param = 0)
  // note y is "upside down" so that anchor point 0 can be drawn at the bottom of the window
  {
    if (mode != MODE_STEP) {
      // assume linear
      // state is directly anchor index
      if (state >= anchor_n)
        return false; // no more points
      x = get(state, param);
      y = 1.0f - anchorIdxToFrac(state);
      state++;
      return true;
    }

    // MODE STEP
    if (state >= anchor_n * 2)
      return false;
    x = get(state / 2, param);
    float y_stp = 1.0f / static_cast<float>(anchor_n - 1);
    float y_mult = (static_cast<float>(state) + 1) / 2 - 0.5f;
    y = limit_range(y_stp * y_mult, 1.0f, 0.0f);
    state++;
    return true;
  }

  // auto cast to pointer
  operator MorphParam*() { return this; }
};

inline bool operator==(MorphParam::Mode lhs, const MorphParam& rhs){
    return rhs == lhs;
}

//-------------------------------------------------------------------------------------------------
// allow MorphParam to be used as a vstparam index
// make sure that you check that vstParamIdx() is != -1 before passing
inline int toVstParamIdx(const MorphParam& morph)
{
  return morph.getParamId();
}
inline int toVstParamIdx(const MorphParam* morph)
{
  return toVstParamIdx(*morph);
}

//-------------------------------------------------------------------------------------------------
inline size_t MorphParamArrayAccess::size()
{
  if (idx_is_anchor){
    return morph->numParams();
  }
  return morph->numAnchorPoints();
}

inline float MorphParamArrayAccess::operator[](size_t i) const
{
  if (idx_is_anchor){
    return morph->get(idx, i);
  }
  return morph->get(static_cast<unsigned int>(i), idx);
}

inline float& MorphParamArrayAccess::operator[](size_t i)
{
  if (idx_is_anchor){
    return morph->anchorData(idx, i);
  }
  return morph->anchorData(i, idx);
}

#endif
