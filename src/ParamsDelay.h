/******************************************************************************

Generic Parameter FIFO for VST params

History
        Date       Version    Programmer         Comments
        16/2/03    1.0        Darrell Tam		 Created
        14/2/04    1.1        DT                 Changed to template based
        9/11/05    1.2        DT                 Ported from buzz to vst

This is completely free software

Notes,
was previously a template based on number of params but this made is clumsy
when moving functions outside because they would all need to be templated
******************************************************************************/

#ifndef _DT_PARAMS_DELAY_H_
#define _DT_PARAMS_DELAY_H_

#include "misc_stuff.h"
#include <vector>
#include <cstring>
#include <type_traits>

inline unsigned int toVstParamIdx(unsigned int i);

//-------------------------------------------------------------------------------------------------
struct VstParamIdx
    : public BuiltinWrapper<unsigned int>
// wrapper for vst param indexes (int) so that MorphParam can be used as an index directly
{
  VstParamIdx() {}

  template <class T> VstParamIdx(const T& t) { val = toVstParamIdx(t); }
};

// usual thing that VstParamIdx's are constructed from
inline unsigned int toVstParamIdx(unsigned int i)
{
  return i;
}


//-------------------------------------------------------------------------------------------------
/** \brief This class Manages the time delay for the vst parameters and buffers them.
 *
 * Since there may be consideable delays bewteen audio input and the output of the processed
 * data, there needs to be a mechanism that buffers parameter inputs. If there is a set delay
 * of 100ms, then any parameter changes we recieve are 100ms in the "future". So if we don't
 * buffer and interpoliate these inputs the timing may be way off, making the life of any
 * musician harder than it should be.
 *
 * You can directly access the data for a parameter through the public get functions, however
 * a lot of the interfaces intend that you use the given \ref ParamsDelayGet struct instead.
 * The predefined functions to create a `ParmamsDelayGet` struct are:
 * - \ref GetInput(const ParamsDelay&),
 * - \ref GetInputNoForced(const ParamsDelay&),
 * - \ref GetOutputPrev(const ParamsDelay&),
 * - \ref GetOutputNext(const ParamsDelay&),
 * - \ref GetOutputLinInterp(const ParamsDelay&),
 **/
class ParamsDelay {
protected:
  /** Number of time points are used for the parameter delay. **/
  unsigned int _length;

  /** Number of params that are stored. **/
  unsigned int _n_params;

  /** Current timepoint for parameter input. */
  unsigned int _in;

  /** \brief Current timepoint for parameter output.
   *
   *  The values will be interpoliated between `_out_a` and `_out_b`*/
  unsigned int _out_a, _out_b;

  /** \brief Expected distance between `samp_abs_new` in `Params`.
   *
   * Normally this matches a fraction of the tempo, e.g. samples per quarter-note.
   * This is used to control interpolation --  params are only interpolated
   * within this distance up to a change.
   **/
  long _expected_dist;

  /** \brief Current interpolation fraction of between _out_a & _out_b.
   *
   * The current interpolation is set by `setOutPos` and clamped between 0 and 1,
   * meaning for `0.0f` the output is `_out_a` and for `1.0f` its `_out_b`.
   **/
  float _interp_frac;

  /** Helper Method. Increments `i`, wrapping to 0 if it exceeds `_length`.
   *
   * \param[in, out] i the index to increment and wrap.
   **/

  void incIndex(unsigned int& i)
  {
    if (++i >= _length)
      i = 0;
  }

  /** \brief Memory for array of param record.
   *
   * The array carries `_length' times a record.
   * Records have the following structure:
   * ```struct Record
   * {
   *     long samp_abs; // absolute sample position
   *     float vals[_n_params]; // parameter values
   *     bool any_explicit_set; //Any parameter explicitly set?
   *     bool explicit_set[_n_params]; //which parameters are set explicitly
   * };```
   *
   * \note The data itself is stored in a flat byte array instead of a struct.
   **/
  std::vector<char> _data;

  // std::vector<long> _samp_abs;
  // std::vector<float> _vals;

  // params can be overridden

  /** \brief This bool array tells if for parameter `i` the overwritten value should be forced.
   *
   **/
  std::vector<bool> _use_override_param;

  /** This array stores the value that should be used if parameter `i` is overwritten.**/
  std::vector<float> _override_param;

  // offset of each field in each data record
  /* \brief Stores the offset of each field in the data record.
   *
   * At index `0` the offset of `any_explicit_set` is stored, meaning the offset is
   * long + float * n_params_`.
   * At index `1` the offset of `explicit_set[_n_params]` is stored, meaning the offset
   * is `_override_param[0] + bool`.
   **/
  unsigned int _field_byte_offs[2];

  /** Stores the total length of one record. **/
 unsigned int _record_len_bytes;

protected:
  /** Accesses the element in record at timepoint `i`.
   *
   * \param i timepoint of the record.
   * \param byte_offs the offset in bytes of the desired element to read
   * \return A (reinterpret casted) pointer to the selected position.
   *
   * \note This Method is not (pointer)-aliasing safe. If this is a problem on your specific platform (not the case on most desktop platforms)
   *    then the quick way to fix this is by first allocating an oject of type `T` and then to memcopy
   *    the data from the pointer into the allocated object.
   *
   * \note To any future developer: If pointer alignment does actually become important again on some kind of new
   *    architecture, then the proper way to solve this (and probably what runs faster as well) is to
   *    create a proper structure like a `struct` for the records where the compiler takes care of
   *    alignment for you, preventing pointer aliasing. That means however that a lot of the code here has to be adapted...
   **/
  template <class T> T* data(unsigned int i, unsigned int byte_offs) const
  {
    return reinterpret_cast<T*>(begin(_data) + i * _record_len_bytes + byte_offs);
  }

  // access various things in _data, do all this stuff our selves so that we create
  // contiguous records of any size

  /** Gets the absolute sample position for record `row`.**/
  long& getAbsSamplePos(unsigned int row) const { return *data<long>(row, 0); }
  /** Gets a pointer to the float array of length `_n_params` for record `row`.**/
  float* getValues(unsigned int row) const { return data<float>(row, sizeof(long)); }
  /** Gets the value of `any_explicit_set for record `row`.**/
  bool& getAnyExplicitSet(unsigned int row) const { return *data<bool>(row, _field_byte_offs[0]); }
  /** Gets the pointer to the bool array of length `_n_params` for record `row`.**/
  bool* getExplicitSet(unsigned int row) const { return data<bool>(row, _field_byte_offs[1]); }

  // get param "param_idx" value from "row" using override if need be
  /**\brief Gets the value of the parameter at `param_idx` for record `row`.
   *
   * If for the parameter the `_use_override_param` is used and overrides are allowed, then
   * the overwritten value will returned, else the value stored in the record.
   *
   * \param row index of the record.
   * \param param_idx index of the desired parameter.
   * \param allow_override Allow the overriden value to be returned if its set.
   * \return The value of parameter in the record or if overrides are allowed and there is one stored for the parameter, then the overwritten value will be output instead.
   **/
  float /*0..1: ok*/ getValue(unsigned int row, unsigned int param_idx, bool allow_override = true) const
  {
    return (_use_override_param[param_idx] && !allow_override) ? _override_param[param_idx]
                                                               : getValues(row)[param_idx];
  }

public:

  /** Checks if the given parameter index is inside the valid range of [0, _n_params]**/
  inline bool isParamIdxOk(unsigned int idx) { return idx >= 0 && idx < _n_params; }

  /** Initializes the internal storages.
   *
   * \warning This must be called before the class can be used!
   **/
  void init(unsigned int n_params, unsigned int length)
  {

    _length = length;
    _n_params = n_params;

    // find offsets for data in our array
    _field_byte_offs[0] =
        sizeof(long) +
        sizeof(float) * _n_params; // any_explicit_set array: skip samp_abs_new field & vals array
    _field_byte_offs[1] =
        _field_byte_offs[0] + sizeof(bool); // explicit_set array: skip any_explicit_set
    _record_len_bytes =
        _field_byte_offs[1] + sizeof(bool) * _n_params; // total length: skip explicit_set

    // allocate required memory
    // _length times above array
    _data.resize(_record_len_bytes * _length);

    // Zero out first block of data
    memset(_data.data(), 0, _record_len_bytes);

    // by default no values are forced
    _override_param.resize(n_params, 0.0f);
    _use_override_param.resize(n_params, false);

    //call the internal init
    init_();
  }

  ParamsDelay() // don't forget to call init before use
  {
    _expected_dist = 0x7fffffff; // large initial setting (disable)
  }

  /** Sets the expected distance to `n`. **/
  void setExpectedDist(int n) { _expected_dist = n; }

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
public: // parameter override (use for param preview)

  /** Sets the override flag for the parameter `idx` to `state`.**/
  void setOverrideState(unsigned int idx, bool state) { _use_override_param[idx] = state; }

  /** Sets the override flag for the parameter `idx` to true and set the value to `v`.
   *
   * \note Value must be between 0 and 1.
   **/
  void setOverride(unsigned int idx, float v)
  {
    setOverrideState(idx, true);
    _override_param[idx] = v;
  }

  /** Gets the value of the override for parameter `idx`. **/
  float /*0..1*/ getOverrideValue(unsigned int idx) const { return _override_param[idx]; }

  /** Checks if the override flag is set for the parameter `idx`.**/
  bool isOverridden(unsigned int idx) const { return _use_override_param[idx]; }

  /** Gets the value of the parameter `idx` at the current time point. Overrides allowed. **/
  float getInput(unsigned int idx) const { return getValue(_in, idx); }

  /** Gets the value of the parameter `idx` at the current time point. No overrides allowed. **/
  float getInputNoForced(unsigned int idx) const { return getValue(_in, idx, /*use forced*/ false); }


  /** Gets the value of the parameter `idx` at the beginning of the interpolation range (with overrides). **/
  float getOutputPrev(unsigned int idx) const { return getValue(_out_a, idx); }
  /** Gets the value of the parameter `idx` at the end of the interpolation range (with overrides). **/
  float getOutputNext(unsigned int idx) const { return getValue(_out_b, idx); }

  /** Get the value at the current position linearly interpolated (overrides allowed).**/
  float getOutputLinInterp(unsigned int idx) const
  {
    return lin_interp(_interp_frac, getOutputPrev(idx), getOutputNext(idx));
  }

  /** \brief Gets the output sample position of either the previous or the next posiiton.
   *
   * If given no arguments or `next_param` set `false`, then the the absolute
   * sample position of the previous point will be returned.
   * Else the position of the next point will be returned.
   *
   * \param next_param flag indicating if previous or next position should be used.
   * \return The absolute sample position.
   **/
  long getOutputAbsSamplePos(bool next_param = false) const
  {
    return getAbsSamplePos(next_param ? _out_b : _out_a);
  }

  /** Gets the absolute sample position of current input. **/
  long getInputAbsSamplePos() const { return getAbsSamplePos(_in); }

  /** \brief Checks if `getNonInterp()` corresponds to an explicitly set parameter.
   *
   *  \param idx the parameter to be be checked.
   *  \param next_param should be the previous (default) or the next output be used?
   *  \return true if explicitly set, false if not.
   **/
  bool isExplicitlySet(unsigned int idx, bool next_param = false) const
  {
    return getExplicitSet(next_param ? _out_b : _out_a)[idx];
  }

  /** \brief Checks if any parameter is explicitly set
   *
   * \param next_param should be the previous or the next output be used?
   * \return true if any parameter is explicitly set, false if not.
   **/
  long isAnyExplicitSet(bool next_param = false) const
  {
    return getAnyExplicitSet(next_param ? _out_b : _out_a);
  }

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /** Resets the parameter vector for record 0 and copies the most recent parameters into
   * record 0 and also reset * abs time to 0 in there. Then the output positions are
   * reset.
   **/
  void resetAndCopyIn()
  {
    // copy current input params to time 0
    memcpy(data<char>(/*idx*/ 0, /*byte offs*/ 0),
           data<char>(/*idx*/ _in, /*byte offs*/ 0),
           _record_len_bytes);

    // reset sample abs time
    getAbsSamplePos(0) = 0;

    init_();
  }

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /** Tests if the outpot position can be inremented, and if it can, does so.
   *
   * \return `true` if sucessfully incremented, `false` if no next output is available.
   **/
  bool /*can go to next?*/ nextOutParam()
  {
    // set the position to what was the next param
    _out_a = _out_b;
    _interp_frac = 0.0f;

    // Test if there is a new record available
    // if we can't increment then we can't get to the next param
    if (_out_b == _in)
      return false;

    incIndex(_out_b);
    return true;
  }

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  /**
  * Put a parameter with index `idx` and value `value` into a param node at absolute
  * sample position `samp_abs_new`.
  *
  * \param samp_abs_new new absolute sample position.
  * \param idx index of the parameter to set.
  * \param value value that should be set for the parameter.
  * \return `true` if the param already exists, `false` if not.
  **/
  bool /*already exists*/ putValueAt(long samp_abs_new, VstParamIdx idx, float value)
  {
    bool already_exists = false;
    // does this param have the same time as the most recent one?
    long samp_diff = samp_abs_new - getAbsSamplePos(_in);
    if (samp_diff <= 0)
      already_exists = true;
    else {
      // make a new Params entry if the time is different

      // make an extra entry point if the time gap is bigger than the expected
      // parameter distance
      if (samp_diff > _expected_dist) {
        cpInNode();
        getAnyExplicitSet(_in) = false;
        getAbsSamplePos(_in) = samp_abs_new - _expected_dist;
      }
      cpInNode();
      getAnyExplicitSet(_in) = true;
      getAbsSamplePos(_in) = samp_abs_new;
    }
    getValues(_in)[idx] = value;
    getExplicitSet(_in)[idx] = true;
    return already_exists;
  }

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /** \brief Sets the new output position.
   *
   * First its checked whether `_out_b` (the last output position for interpolation) is larger than the
   * new desired position. If the new time position is behind `_out_a`, then there will be no update, since we can't
   * go back in time. The interpolation fraction will be reset to `0` in that case.
   *
   * If `_out_b > samp_abs_new` fails, then `_out_b == samp_abs_new` is checked.
   * Here the begining of the interpolation frame (`_out_a`) is set to `_out_b`,
   * then `_out_b` is incremented and wrapped if necessary. The fractional part is set to `0`.
   *
   * If none of the above cases apply, the beginning of the interpolation frame `_out_a` is set
   * to `_out_b` and `_out_b` is incremented and wrapped if necessary. Then the above cases are
   * checked again. This is repeat until either the above cases apply or the end of the interpolation frame (`_out_b`)
   * has hit the end (`_in`).
   * If that happens then we can't set the output to the desired time. `_out_a` and `_out_b` are set to the end
   * instead and the fractional part is set to `0`.
   *
   * If `find_fraction` is set to true, the fractional part for the interpolation will
   * be recalculated for the first case.
   *
   * \param[in] samp_abs_new new time position of the output.
   * \param[in] find_fraction if the fractional part should be recalculated if necessary.
   * \return `true` if the time was sucessfully set and `false` if not.
   **/
  bool /*can interpolate*/ setOutputPos(long samp_abs_new, bool find_fraction = true)
  {
    // look for params
    while (1) {

      if (getAbsSamplePos(_out_b) > samp_abs_new) {
        // find distance from requested sample to _out_a position
        long numer = samp_abs_new - getAbsSamplePos(_out_a);

        // can't go in reverse, samp_abs_new lies before "_out_a"
        if (numer < 0) {
          _interp_frac = 0.0f;
          return false;
        }
        // can interpolate ok

        // don't do fraction calculation unless needed
        if (!find_fraction)
          return true;

        // distance between params
        float denom = (float)(getAbsSamplePos(_out_b) - getAbsSamplePos(_out_a));

        // denominator should never be <=0, but just in case
        if (denom <= 0.0f) {
          _interp_frac = 0.0f;
          return true;
        }

        _interp_frac = (float)numer / denom;
        return true;
      }

      // is it an exact match?
      if (getAbsSamplePos(_out_b) == samp_abs_new) {
        _out_a = _out_b;
        if (_out_b != _in)
          incIndex(_out_b);
        _interp_frac = 0.0f;
        return true;
      }

      // have we hit the end? Put both out ptrs at the end
      if (_out_b == _in) {
        _out_a = _out_b;
        _interp_frac = 0.0f;
        return false;
      }

      _out_a = _out_b;
      incIndex(_out_b);
    }
  }

protected:
  /** Creates a new node past the current `_in` position and copies the data at the current position to
   * the new node, where all `explicit_set` are set to false as well.
   **/
  void cpInNode() {
    unsigned int next = _in;
    incIndex(next);

    // copy previous _in to new _in
    memcpy(getValues(next), getValues(_in), sizeof(float) * _n_params);

    // clear explicit sets
    memset(getExplicitSet(next), 0, sizeof(bool) * _n_params);

    // check whether we've filled the buffer & need to bump the pointers
    if (next == _out_a) {
      _interp_frac = 0.0f;
      incIndex(_out_a);
    }
    if (next == _out_b)
      incIndex(_out_b);

    // done
    _in = next;
  }

  /** Internal init. Sets the time position and interpolation fraction to 0. **/
  void init_()
  {
    _in = 0;
    _out_a = _in;
    _out_b = _in;
    _interp_frac = 0.0f;
  }
};

//-------------------------------------------------------------------------------------------------
/**
 * \brief Struct that enables array access through the `[]` operator for a particular part of `ParamsDelay`.
 *
 * This struct wraps a particular method pointer from `ParamsDelay` and a const pointer `ptr` to a `ParamsDelay` instance.
 * By doing this extraction of data from the instance is neatly wrapped and allows for nice syntactic sugar,
 * since the set property can be accessed for the specific frame using the `[]` operator.
 *
 * The accepted methods must have the signatur of `float ParamsDelay::foo(unsigned int) const`. This
 * is intended for \ref ParamsDelay::getOverridenValue(unsigned int),
 * \ref ParamsDelay::getInput(unsigned int), \ref ParamsDelay::getInputNoForced(unsigned int),
 * \ref ParamsDelay::getOutputPrev(unsigned int), \ref ParamsDelay::getOutputNext(unsigned int) and
 * ref ParamsDelay::getOutputLinInterp(unsigned int).
 *
 * \see ParamsDelay
 **/
struct ParamsDelayGet
    : public _PtrBase<const ParamsDelay>

{
  typedef float (ParamsDelay::*Fn)(unsigned int) const;

  /** `ParamsDelay` Method that should  be called.**/
  Fn fn;

  ParamsDelayGet(const ParamsDelay& p, Fn f)
  {
    ptr = &p;
    fn = f;
  }

  float operator[](unsigned int i) const { return (ptr->*fn)(i); }
  float operator[](int i) const { return (ptr->*fn)(i); }
};

//-------------------------------------------------------------------------------------------------
// access ParamsDelay as an array using these functions
//


/** Creates accessor for \ref ParamsDelay::getInput(unsigned int). **/
inline ParamsDelayGet GetInput(const ParamsDelay& p)
{
  return ParamsDelayGet(p, &ParamsDelay::getInput);
}

/** Creates accessor for \ref ParamsDelay::getInputNoForced(unsigned int). **/
inline ParamsDelayGet GetInputNoForced(const ParamsDelay& p)
{
  return ParamsDelayGet(p, &ParamsDelay::getInputNoForced);
}

/** Creates accessor for \ref ParamsDelay::getOutputPrev(unsigned int). **/
inline ParamsDelayGet GetOutputPrev(const ParamsDelay& p)
{
  return ParamsDelayGet(p, &ParamsDelay::getOutputPrev);
}

/** Creates accessor for \ref ParamsDelay::getOutputNext(unsigned int). **/
inline ParamsDelayGet GetOutputNext(const ParamsDelay& p)
{
  return ParamsDelayGet(p, &ParamsDelay::getOutputNext);
}

/** Creates accessor for \ref ParamsDelay::getOutputLinInterp(unsigned int). **/
inline ParamsDelayGet GetOutputLinInterp(const ParamsDelay& p)
{
  return ParamsDelayGet(p, &ParamsDelay::getOutputLinInterp);
}

// above functions match this type
typedef ParamsDelayGet (*ParamsDelayGetFn)(const ParamsDelay&);

#endif
