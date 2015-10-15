#ifndef EXBASE_H
#define EXBASE_H

#include <axb/devbase.h>

/* my custom device base extends the device base */
struct ExBase {
  struct DevBase eb_DevBase;
  struct MsgPort *eb_WorkerPort;
};

#endif
