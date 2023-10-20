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
/** \brief This class contains the state of one Effect, including parameters.
 *
 * The object is intended to be stored inside a \ref DtBlkFxAudioProcessor instance.
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

  bool /*true=printed*/ getParamDisplay(BlkFxParam::SplitParamNum& p, float v, Rng<char> str);

  // called prior to process
  void prepare();

  // perform the effect
  void process() { temp.fft_fx->process(this); }

  // get previous fx state from blkfx (or NULL)
  FxState1_0* prevFxState();

  // which fx set we are
  unsigned int _fx_set;

  // parent
  //TODO: Can this be replaced with smart pointers?
  _Ptr<DtBlkFxAudioProcessor> _b;

  DtBlkFxAudioProcessor* blkfx() { return _b; }

  operator DtBlkFxAudioProcessor*() { return _b; }

  FxRun1_0* getFxRun(bool for_display = true);

public: // parameters
  MorphParam _param[BlkFxParam::NUM_FX_PARAMS];

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
public: // temporary variables used during processing
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
