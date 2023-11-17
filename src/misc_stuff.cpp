//#include <StdAfx.h>

#include "misc_stuff.h"

//-------------------------------------------------------------------------------------------------
CharRng RngPrintNumStruct::print(Rng<char> dst) const
{
  struct {
    const char* fmt;
    float max_val;
    float mult;
  } stuff[] = {
      {"%.2fu", 1e-5f, 1e6f},
      {"%.1fu", 1e-4f, 1e6f}, // micro
      {"%.0fu", 1e-3f, 1e6f}, // micro
      {"%.2fm", 1e-2f, 1e3f}, // milli
      {"%.1fm", 1e-1f, 1e3f}, // milli
      {"%.0fm", 1e0f,  1e3f},  // milli
      {"%.2f",  1e1f,  1.0f},   // no multiplier
      {"%.1f",  1e2f,  1.0f},   // no multiplier
      {"%.0f",  1e3f,  1.0f},   // no multiplier
      {"%.2fk", 1e4f,  1e-3f}, // kilo
      {"%.1fk", 1e5f,  1e-3f}, // kilo
      {"%.0fk", 1e6f,  1e-3f}, // kilo
      {"%.2fM", 1e7f,  1e-6f}, // mega
      {"%.1fM", 1e8f,  1e-6f}, // mega
      {"%.0fM", 1e9f,  1e-6f}  // mega
  };

  float abs_v = fabsf(v);
  size_t i = 0;
  while (i < NUM_ELEMENTS(stuff) - 1) {
    if (stuff[i].max_val >= max_unit)
      break;
    if (stuff[i].max_val > min_unit && abs_v < stuff[i].max_val)
      break;
    i++;
  }
  return dst << sprf(stuff[i].fmt, v * stuff[i].mult);
}

juce::String& RngPrintNumStruct::print(juce::String& dst) const
{
  struct {
    const char* fmt;
    float max_val;
    float mult;
  } stuff[] = {
      {"%.2fu", 1e-5f, 1e6f},
      {"%.1fu", 1e-4f, 1e6f}, // micro
      {"%.0fu", 1e-3f, 1e6f}, // micro
      {"%.2fm", 1e-2f, 1e3f}, // milli
      {"%.1fm", 1e-1f, 1e3f}, // milli
      {"%.0fm", 1e0f,  1e3f},  // milli
      {"%.2f",  1e1f,  1.0f},   // no multiplier
      {"%.1f",  1e2f,  1.0f},   // no multiplier
      {"%.0f",  1e3f,  1.0f},   // no multiplier
      {"%.2fk", 1e4f,  1e-3f}, // kilo
      {"%.1fk", 1e5f,  1e-3f}, // kilo
      {"%.0fk", 1e6f,  1e-3f}, // kilo
      {"%.2fM", 1e7f,  1e-6f}, // mega
      {"%.1fM", 1e8f,  1e-6f}, // mega
      {"%.0fM", 1e9f,  1e-6f}  // mega
  };

  float abs_v = fabsf(v);
  size_t i = 0;
  while (i < NUM_ELEMENTS(stuff) - 1) {
    if (stuff[i].max_val >= max_unit){
      break;
    }
    if (stuff[i].max_val > min_unit && abs_v < stuff[i].max_val){
      break;
    }
    ++i;
  }
  return dst << juce::String::formatted(stuff[i].fmt, v * stuff[i].mult);
}

CharRng operator<<(CharRng dst, PercentStruct s)
{
  const char* fmt[] = {"%2.0f%%",
                       "%2.1f%%",
                       "%2.2f%%",
                       "%2.3f%%",
                       "%2.4f%%",
                       "%2.5f%%",
                       "%2.6f%%",
                       "%2.7f%%",
                       "%2.8f%%",
                       "%2.9f%%"};
  return dst << sprf(GET_ELEMENT(fmt, static_cast<size_t>(s.decimal_places), "%2.9f%%"), s.frac * 100.0f);
}

juce::String& operator<<(juce::String& dst, PercentStruct s)
{
  const char* fmt[] = {"%2.0f%%",
                       "%2.1f%%",
                       "%2.2f%%",
                       "%2.3f%%",
                       "%2.4f%%",
                       "%2.5f%%",
                       "%2.6f%%",
                       "%2.7f%%",
                       "%2.8f%%",
                       "%2.9f%%"};
  return dst << juce::String::formatted(GET_ELEMENT(fmt, static_cast<size_t>(s.decimal_places), "%2.9f%%"), s.frac * 100.0f);
}
