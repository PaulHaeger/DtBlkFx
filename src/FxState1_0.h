#ifndef _DT_FX_STATE_1_0_H_
#define _DT_FX_STATE_1_0_H_
/**************************************************************************************************
Copyright (c) 2005-2006 Darrell Tam
email: darrell.barrell@gmail.com

I am trying to move away from the 1.0 style effects because they were developed prior to param
morphing, can't store effect specific params and have become clumsy to deal with

FxState1_0 : state associated with each effect position in a blkfx instance


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

#include <string.h>
#include <vector>
//#include "wxWidgetsExtras.h"

#include "MorphParam.h"

#include "BlkFxParam.h"
#include "FxRun1_0.h"
//#include "gui_stuff.h"

class MainGuiPanel;
class DtBlkFxAudioProcessor;
class MorphParamEdit;

//-------------------------------------------------------------------------------------------------
/** \brief This class contains the state of one effect, including its parameters.
 *
 * The object is intended to be stored inside a \ref DtBlkFxAudioProcessor instance.
 * The processing itself is carried out through polymorphism by an instance that is
 * derived from \ref RxRun1_0.
 *
 * \see FxRun1_0, DtBlkFxAudioProcessor
 **/
class FxState1_0
{
public:
  /**
  * Initializes the state by setting the parent to `b` and the selected `fx_set`.
  **/
  void init(DtBlkFxAudioProcessor* b, unsigned int fx_set);

  /** \brief Generates a string meant for display for parameter `p` with value `v`.
   *
   * First the method will determine if the parameter id belongs to an effect. 
   * If not `false` is returned. If the parameter is being used, then `v` will be
   * morphed to the appropiate value. If the given parameter is currently
   * unused "-" will be written into `str`.
   * If the parameter is used by the effect, then an appropiate string
   * giving the value in a human readable format will be written.
   *
   * E.g. if the the parameter is `FX_FREQ_A` then the string will be "xxxx[k]Hz".
   * For `FX_AMP` the string is `xxx%` if mix_mode is used, "xxx dB" else and "-∞ dB"
   * when the value is `0`.
   * `FX_TYPE` will simply give the  name of the Effect and `FX_VAL` the value.
   *
   * \param[in] p the fx param to extract the info from.
   * \param[in] v the value that should be transformed into human interpretable output.
   * \param[out] str the string for which the output will be appended to.
   * \return `true` if anything was written, `false` if not.
   **/
  bool getParamDisplay(BlkFxParam::SplitParamNum& p, float v, juce::String& outStr);

  /** \brief Prepares processing.
  *
  * Called before \ref FxState1_0::process is called.
  * The current effect is loaded, the parameter values are morphed
  * appropiately and data is written to the right places.
  **/
  void prepare();

  /** Performs the effect.  **/
  void process() { temp.fft_fx->process(this); }

  /** Gets the previous effect state from the parent or `nullptr` if this is the first one in the list.*/
  FxState1_0* prevFxState();

  unsigned int _fx_set; /** Tells to which effect set the state belongs. */

  // parent
  //TODO: Can this be replaced with smart pointers?
  /** \ref DtBlkFxAudioProcessor the effect state is parented to. **/
  _Ptr<DtBlkFxAudioProcessor> _b;

  DtBlkFxAudioProcessor* blkfx() { return _b; }

  operator DtBlkFxAudioProcessor*() { return _b; }

  /** Loads the currently set effect type from the parent and returns a pointer to the
   * appropiate \ref FxRun1_0 instance. If `for_display` is set false, then
   * the effect type parameter will not be interpolated beforehand.**/
  FxRun1_0* getFxRun(bool for_display = true);

public: // parameters
  MorphParam _param[BlkFxParam::NUM_FX_PARAMS]; /** Morphs for the different parameters inside the effect. */

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
public: // temporary variables used during processing

  /** \brief This struct contains temporary values that are used during processing.
   **/
  struct {
    // unprocessed freq param, 0..1
    Array<float, 2> freq_param;

    // unprocessed amp param, 0..1
    float amp_param;

    // which effect we're currently running
    FxRun1_0* fft_fx;

    Array<float, 2> fbin; // floating point version of start & stop bins
    float amp;            // current amplitude (converted to linear scaling)
    float val;            // current effect value

    Array<long, 2> bin; // start & stop bin for this effect

  } temp;

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
public: // GUI state stuff
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
public: // GUI stuff that is only valid when the GUI is open
#if 0

		bool openGui(MainGuiPanel *parent, wxSize sz);
		void closeGui();

	public: // wx widgets event handlers
		void onPaintTopPanel(wxPaintEvent&);
		void onMouseTopPanel(wxMouseEvent& ev);

		void onLeftUpTopPanelPopup(wxMouseEvent& ev);

		void onPaintAmpEdit(wxPaintEvent& ev);
		void onPaintFxValEdit(wxPaintEvent& ev);
		void onPaintFreqEdit(wxPaintEvent& ev);

	protected: // GUI internals
		//void setTextColour(wxDC& dc, int ctrl_idx);

		float getParamInput(int idx);

	public: // GUI temporaries

		// outermost window
		Ptr<wxWindow> _frame_wdw;

		// top panel window
		Ptr<wxButton> _top_panel;
		bool _top_panel_focus;

		Ptr<MorphParamEdit> _amp_param_edit;
		Ptr<MorphParamEdit> _fxval_param_edit;
		Ptr<MorphParamEdit> _freq_param_edit;

		//
	//	bool _top_panel_need_redraw;

		enum { DISP_FREQ_HZ, DISP_FREQ_NOTE } _disp_freq_mode;
#endif

};

#endif
