#ifndef _DEBUG_H_
#define _DEBUG_H_

#define LOG(style, str)                                                                            \
  {                                                                                                \
  }
#define DBG_CODE(a)
#define DBG(a)                                                                                     \
  {                                                                                                \
  }
#define LOGG(style, str)                                                                           \
  {                                                                                                \
  }

#ifdef _DEBUG
    #undef DBG_CODE
    #define DBG_CODE(a) a

    // print to debug file
    #ifdef LOG_FILE_NAME
        #undef LOG
        #define LOG(style, str) static_assert(false, "Replace old LOG call here!");
    #endif

    #undef LOGG
    #define LOGG(style, str) static_assert(false, "Replace old LOG call here!");

    //
    #include <sstream>
    #undef DBG
    #ifdef _WIN32
        //TODO: Find out if this macro can be replaced with a function!!!
        #define DBG(stream)                                                                                \
            {                                                                                              \
              std::ostringstream dbg_ostrstream;                                                           \
              dbg_ostrstream << stream << std::endl;                                                       \
              _CrtDbgReport(_CRT_WARN, __FILE__, __LINE__, "DtBlkFx", "%s", dbg_ostrstream.str().c_str()); \
            }
    #else
        #include <iostream>
        #define DBG(stream)                                                                              \
            {                                                                                            \
                std::cout <<  __FILE__ << ' ' << __LINE__ << " DtBlkFx: "  << stream << std::endl;       \
            }
    #endif
#endif

#endif
