#ifndef _DEBUG_H_
#define _DEBUG_H_

#define LOG(style, str)                                                                            \
  {                                                                                                \
  }
#define DBG_CODE(a)
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

#endif

#endif
