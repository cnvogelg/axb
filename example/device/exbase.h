#ifndef EXBASE_H
#define EXBASE_H

#include <axb/devbase.h>

/* my custom device base extends the device base */
struct ExBase {
  struct DevBase eb_DevBase;
  /* add your own values here */
  struct MsgPort *eb_WorkerPort;
  long            eb_Input;
  long            eb_Output;
};

#endif
