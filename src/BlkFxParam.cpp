#include "BlkFxParam.h"

namespace BlkFxParam
{
    using namespace juce;

    AudioProcessorValueTreeState::ParameterLayout generateParameterLayout(){
        //Global params
        AudioProcessorValueTreeState::ParameterLayout params;
        auto global_group = std::make_unique<AudioProcessorParameterGroup>("GLOBAL", "Global", " | ");
        global_group->addChild(
                std::make_unique<AudioParameterFloat>("MIX_BACK", "Mix Back", NormalisableRange<float>(0.f, 1.f), 0.f),
                std::make_unique<AudioParameterFloat>("DELAY", "Delay", NormalisableRange<float>(0.f, 1.f), 0.f),
                std::make_unique<AudioParameterFloat>("FFTLEN", "FFT Length",  NormalisableRange<float>(0.f, 1.f), 0.f) //TODO: AudioParameterInt would be more fitting, but in the moment its not clear what would need to be changed.
        );
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

        for(auto& subgroup : subgroups){
            auto prefix = subgroup->getID();
            subgroup->addChild(std::make_unique<AudioParameterFloat>(prefix + "_FREQ_A", "Frequency A", NormalisableRange<float>(0.f, 1.f), 0.f),
                               std::make_unique<AudioParameterFloat>(prefix + "_FREQ_B", "Frequency B", NormalisableRange<float>(0.f, 1.f), 1.f),
                               std::make_unique<AudioParameterFloat>(prefix + "_FX_AMP", "Amplitude", NormalisableRange<float>(0.f, 1.f), 1.f),
                               std::make_unique<AudioParameterFloat>(prefix + "_FX_TYPE", "Type", NormalisableRange<float>(0.f, 1.f), 0.f), //TODO: AudioParameterInt or AudioParameterChoice would probably be better but same problem as above.
                               std::make_unique<AudioParameterFloat>(prefix + "_FX_VAL", "Value", NormalisableRange<float>(0.f, 1.f), 0.f)
                           );
        }

        params.add(subgroups.begin(), subgroups.end());

        return params;
    };

    ValueTree generateValueTree(AudioProcessorValueTreeState& apvts){
        ValueTree baseTree = apvts.copyState();
        if(baseTree.isValid()){
            ValueTree programTree = baseTree.getOrCreateChildWithName(idNodeProgram, nullptr);
            //Create the program parameters
            if(!programTree.hasProperty(idProgName)){
                programTree.setProperty(idProgName, juce::var(juce::String("")), nullptr);
            }
        }
        return baseTree;
    }

    ValueTree loadFromLegacyFormat(AudioProcessorValueTreeState& apvts, const String& stringData){
        ValueTree stateTree = generateValueTree(apvts);
        if(stateTree.isValid()){
            int nameEnd = stringData.indexOfChar(':');
            if(nameEnd < 0){
                //Not a single : found, we need to abort
                juce::Logger::outputDebugString("Error in 'loadFromLegacyFormat': Name missing!");
                return ValueTree();
            }
            stateTree.getChildWithName(idNodeProgram).setProperty(idProgName, stringData.substring(0, nameEnd), nullptr);

            String restData = stringData.substring(nameEnd+1);
            //Apply parameters
            const char* c_str = restData.toRawUTF8();
            for(size_t i = 0; i < TOTAL_NUM; ++i) {
                char* next_str = nullptr;

                // get the next param, this returns 0 if conversion was unsucessful
                float value = limit_range(
                        static_cast<float>(std::strtod(c_str, &next_str)),
                        0.0f,
                        1.0f
                        );
                c_str = next_str;

                //Find the correct property
                auto groupId = getGroupForIndex(i);
                auto subTree = stateTree.getChildWithName(groupId);
                //set the new value
                subTree.setProperty(paramsIds[i], value, nullptr);
            }


        }
        return stateTree;
    }
} // namespace BlkFxParam
