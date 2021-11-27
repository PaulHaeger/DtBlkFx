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

#include "MorphParam.h"
#include <fftw3.h>
#include <memory>
#include "FxState1_0.h"

#include  "rfftw_float.h"

#include <juce_audio_processors/juce_audio_processors.h>

class DtBlkFxAudioProcessor : public juce::AudioProcessor {

protected:
    void copyDataToBuffer(const juce::AudioBuffer<float>& buffer);
    void findBlockInPos();
    void prepMixOut();
    void doFFT();
    void procFFT();
	void ifftAndMixOut();
    template <typename SRC> void mixToX3(SRC src, int ch);

    inline static long reducePlan(long plan /*start*/, long avail_samps);
    cplxf* FFTdata(int ch) { return _x1.getWritePointer(ch) + 32; }
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


    float /*bin*/ getFFTBin(float /*0..1*/ param)
    {
        return limit_range(
        _freq_fft_n * BlkFxParam::getHz(param) / getSampleRate(), 0.0f, _freq_fft_n * 0.5f);
    }

private:
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DtBlkFxAudioProcessor)

    juce::AudioBuffer<float> _buffer; //Buffer for storing remaining samples

    //fftw_plan g_fft_plan[2];

    // number of samples we overlap with prev blk
    long _fadein_n;

    // normally 0, number of samples we overlap with existing data
    long _fadeout_n;

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
    //VstParamIdx _vst_param_idx_focus;
    //void* _vst_param_idx_focus_cookie;

    // access program number
    /*int currProgramNum() { return limit_range(curProgram, 0, (int)_program.size() - 1); }*/

    // access current preset
    /* BlkFxProgram& currProgram() { return _program[currProgramNum()]; }*/

public:
    //
    bool _param_morph_mode;
    bool isMorphMode() const { return _param_morph_mode; }
    //
    // initial delay passed to setInitialDelay()
    long _initial_delay;

    // maximum number of samples delay
    long _max_delay_n;

    // current absolute sample position of input/output updated with every input buf
    // i.e. absolute position of _x0[_x0_i+x0_n] / _x3[_x3_o]
    long _curr_samp_abs;

    // number of samples to move forward in input buffer to process next blk
    long _next_blk_fwd_n;

    // absolute sample position of x0[x0_i] and also x1[0]/x2[0] when processing a fft-blk
    long _blk_samp_abs;

    long _pre_buffer_size;           // wraping position of x0
    long _pre_buffer_force_out_size; // force output if x0_n exceeds this

    long _pre_buffer_index;          // first sample of current blk in _x0
    long _pre_buffer_num;          // number of samples in the pre-fft buffer
    long _pre_buffer_num_past_end; // number of samples copied past _x0_sz

    long _x3_size;       // total size of x3
    long _x3_o;        // output FIFO output index
    long _x3_i;        // output FIFO output index
    long _x3_end_abs;  // 1 + abs sample position of final sample in _x3
    bool _x3_is_clear; // true when x3 is initialized with 0's

    enum {
    PARAMS_CHK_SYNC,  // params need to be processed for the current blk
    PARAMS_NONINTERP, // params have been gathered but can't be interpolated
    PARAMS_INTERP_OK  // params can be properly interpolated for the current blk
    } _params_state;
    bool _params_need_processing;

    long _plan;    // actual plan (maybe different from desired plan if forced to output data early)
    long _delay_n; // output delay

    long _freq_fft_n;   // actual fft blk sz processed (may not correspond to _desired_plan if output
                        // forced early)

    // destination absolute sample position for current fft blk (i.e. blk_samp_abs + delay)
    long _dst_fft_abs;

    // actual amount of data in the block that we are interested in (use in conjunction
    // with _time_offset)
    long _time_fft_n;

    #define MAX_FFT_SZ 2048 //TODO: REPLACE THIS

    juce::AudioBuffer<float> _pre_fft_buffer; //Buffer for pre FFT Samples
    juce::AudioBuffer<cplxf> _x1;
    juce::AudioBuffer<float> _x2;
    juce::AudioBuffer<float> _x3;

    // block mix function generated from _blk_mix_param
    Array<float, 32> _blk_mix_fn;
    long _blk_mix_fn_n;

    // all state for DtBlkFx params are stored here
    //Array<FxState1_0, BlkFxParam::NUM_FX_SETS> _fx1_0;
    long _buf_end_abs = 0; //Absolute end position of the buffer
    long _extra_data = 0;
    // corresponds to the amount of old data that we've fft'd (data prior to _x0_i)
    long _processed_data_pre_buffer_num;


    // channel specific data
    struct ChannelData {
        ScopeFFTWfMalloc<float> x0; // pre FFT circular buffer, note: special alignment //TODO Check aligment
        ScopeFFTWfMalloc<cplxf> x1; // FFT'd data (frequency-domain), note: special alignment
        ScopeFFTWfMalloc<float> x2; // IFFT'd data (time-domain) and may be used as a temporary buffer
                                    // during effects, note: special alignment
        std::valarray<float> x3;    // output FIFO

        float total_in_pwr;  // x1 input power
        float total_out_pwr; // current x1 output power after effects

        // these 2 calculated after processing done
        float out_pwr_scale; // pwr scaling (total_in_pwr/total_out_pwr)
        float out_scale;     // sqrt(out_pwr_scale)
    };
    ChannelData _chan[2];//Mono and stereo supported, for mono channel 0 is used

    // mixback multiplier
    float _mixback;
    Array<FxState1_0, BlkFxParam::NUM_FX_SETS> _fx1_0;
public:
  // contiguous space for chunk data & presets when saving
  std::valarray<unsigned char> _chunk_data;
};

inline /*static*/ long DtBlkFxAudioProcessor::reducePlan(long plan /*start*/, long avail_samps)
// static method
// given "avail_samps", return plan that corresponds to data that is at most twice the length
//
{
  while (plan > 0 && g_fft_sz[plan] / 2 > avail_samps)
    plan--;
  return plan;
}
