#include "BlkFxParam.h"
#include "FxRun1_0.h"
#include "rfftw_float.h"
#include <sstream>
#include "Legacy.h"

extern const size_t g_num_fx_1_0; //Defined in FxRun1_0.h
extern FxRun1_0* g_fft_fx_table[];

namespace BlkFxParam
{
    using namespace juce;

    AudioProcessorValueTreeState::ParameterLayout generateParameterLayout(){
        //Generate FFT Size list
        juce::StringArray fftPlanSizes;
        for(size_t i = 0; i < NUM_FFT_SZ; ++i){
            fftPlanSizes.add(juce::String(g_fft_sz[i]));
        }
        //Global params
        AudioProcessorValueTreeState::ParameterLayout params;
        auto fftLenAttributes = juce::AudioParameterChoiceAttributes().withLabel("samples");
        auto global_group = std::make_unique<AudioProcessorParameterGroup>("GLOBAL", "Global", " | ");
        global_group->addChild(
                std::make_unique<AudioParameterFloat>("MIX_BACK", "Mix Back", NormalisableRange<float>(0.f, 1.f), 0.f),
                std::make_unique<AudioParameterFloat>("DELAY", "Delay", NormalisableRange<float>(0.f, 1.f), 0.f),
                std::make_unique<AudioParameterChoice>("FFTLEN", "FFT Length",  fftPlanSizes, 0, fftLenAttributes),
                std::make_unique<AudioParameterFloat>("OVERLAP", "Overlap",  NormalisableRange<float>(0.f, 1.f), 0.f)
        );
        params.add(std::move(global_group));
        //Construct the groups
        std::vector<std::unique_ptr<AudioProcessorParameterGroup>> subgroups;
        subgroups.push_back(std::make_unique<AudioProcessorParameterGroup>("FX_1", "FX Slot 1", " | "));
        subgroups.push_back(std::make_unique<AudioProcessorParameterGroup>("FX_2", "FX Slot 2", " | "));
        subgroups.push_back(std::make_unique<AudioProcessorParameterGroup>("FX_3", "FX Slot 3", " | "));
        subgroups.push_back(std::make_unique<AudioProcessorParameterGroup>("FX_4", "FX Slot 4", " | "));
        subgroups.push_back(std::make_unique<AudioProcessorParameterGroup>("FX_5", "FX Slot 5", " | "));
        subgroups.push_back(std::make_unique<AudioProcessorParameterGroup>("FX_6", "FX Slot 6", " | "));
        subgroups.push_back(std::make_unique<AudioProcessorParameterGroup>("FX_7", "FX Slot 7", " | "));
        subgroups.push_back(std::make_unique<AudioProcessorParameterGroup>("FX_8", "FX Slot 8", " | "));

        //Calculate FX_Run name list
        juce::StringArray fxNames;
        for (size_t i = 0; i < g_num_fx_1_0; ++i) {
            fxNames.add(g_fft_fx_table[i]->name());
        }
        auto ampAttributes = juce::AudioParameterFloatAttributes().withLabel("dB");

        //Create the parameters for all the subgroups
        for(auto& subgroup : subgroups){
            auto prefix = subgroup->getID();
            subgroup->addChild(std::make_unique<AudioParameterFloat>(prefix + "_FREQ_A", "Frequency A", NormalisableRange<float>(0.f, 1.f), 0.f),
                               std::make_unique<AudioParameterFloat>(prefix + "_FREQ_B", "Frequency B", NormalisableRange<float>(0.f, 1.f), 1.f),
                               std::make_unique<AudioParameterFloat>(prefix + "_FX_AMP", "Amplitude", NormalisableRange<float>(0.0f, 1.f), 1.0f),
                               std::make_unique<AudioParameterChoice>(prefix + "_FX_TYPE", "Type", fxNames, 0),
                               std::make_unique<AudioParameterFloat>(prefix + "_FX_VAL", "Value", NormalisableRange<float>(0.f, 1.f), 0.f)
                           );
        }

        params.add(subgroups.begin(), subgroups.end());

        return params;
    };

    ValueTree generateValueTree(){
        ValueTree baseTree("Base");
        for(const juce::Identifier& paramId : paramsIds){
          baseTree.setProperty(paramId, 0.0f, nullptr);
        }
        if(baseTree.isValid()){
            ValueTree programTree = baseTree.getOrCreateChildWithName(idNodeProgram, nullptr);
            //Create the program parameters
            if(!programTree.hasProperty(idProgName)){
                programTree.setProperty(idProgName, juce::var(juce::String("")), nullptr);
            }
        }
        return baseTree;
    }

    ValueTree loadFromLegacyFormat(const String& stringData){
        ValueTree stateTree = generateValueTree();
        if(!stateTree.isValid()){
              juce::Logger::outputDebugString("Error in 'loadFromLegacyFormat': Generated Tree is invalid!");
              return ValueTree();
        }
        int nameEnd = stringData.indexOfChar(':');
        if(nameEnd < 0){
            //Not a single : found, we need to abort
            juce::Logger::outputDebugString("Error in 'loadFromLegacyFormat': Name missing!");
            return ValueTree();
        }
        // Save name to state
        stateTree.getChildWithName(idNodeProgram).setProperty(idProgName, stringData.substring(0, nameEnd), nullptr);

        String restData = stringData.substring(nameEnd+1);
        //Apply parameters
        std::istringstream ss(restData.toStdString());

        for(const juce::Identifier& paramId : paramsIds){
            float value;
            // get the next param, this returns 0 if conversion was unsucessful
            if(!(ss >> value)){
                value = 0.0f;
            }

            float normedValue = limit_range(
                    value,
                    0.0f,
                    1.0f
                    );

            juce::Logger::outputDebugString("Trying to map variable for "+ paramId.toString());
            //Save the unnormed value
            const auto& map_func = Legacy::paramMap.find(paramId)->second;
            stateTree.setProperty(paramId, map_func(normedValue), nullptr);
        }
        return stateTree;
    }

    unsigned int getEffectType(float param){
        return static_cast<unsigned int>(param * g_num_fx_1_0);
    }

    float  getEffectTypeInv(unsigned int index)
    {
      //return (float)(index * 8 + 4) / 255.0f;
      return (float)index/g_num_fx_1_0;
    }
} // namespace BlkFxParam
