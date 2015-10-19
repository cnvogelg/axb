#include <proto/exec.h>
#include <proto/dos.h>
#include <dos/dostags.h>
#include <dos/dosextens.h>

#include <axb/worker.h>

#include "exbase.h"

int AXB_REG_FUNC user_worker_init(struct DevBase *db)
{
  struct ExBase *eb = (struct ExBase *)db;

  /* open some windows */
  eb->eb_Input = Open("con:0/0/400/100/Input", MODE_NEWFILE);
  eb->eb_Output = Open("con:0/110/400/100/Output", MODE_NEWFILE);

  return 0;
}

void AXB_REG_FUNC user_worker_exit(struct DevBase *db)
{
  struct ExBase *eb = (struct ExBase *)db;

  Close(eb->eb_Input);
  Close(eb->eb_Output);
}

void AXB_REG_FUNC user_worker_cmd(struct DevBase *db, struct IORequest *ior)
{
  struct ExBase *eb = (struct ExBase *)db;
  struct IOStdReq *isr = (struct IOStdReq *)ior;

  switch(ior->io_Command) {
    case CMD_READ:
      D(("CMD_READ\n"));
      isr->io_Actual = Read(eb->eb_Input,
                            isr->io_Data,
                            isr->io_Length);
      break;
    case CMD_WRITE:
      D(("CMD_WRITE\n"));
      Write(eb->eb_Output,
            isr->io_Data,
            isr->io_Length);
      break;
  }
}

int UserDevInit(AXB_REG(struct DevBase *db,a6))
{
  D(("UserDevInit\n"));
  return 0;
}

void UserDevExpunge(AXB_REG(struct DevBase *db,a6))
{
  D(("UserDevExpunge\n"));
}

int UserDevOpen(AXB_REG(struct IOStdReq *ior,a1),
                AXB_REG(ULONG unit,d0),
                AXB_REG(struct DevBase *db,a6))
{
  struct ExBase *eb = (struct ExBase *)db;

  D(("UserDevOpen\n"));
  eb->eb_WorkerPort = worker_start(db);
  return (eb->eb_WorkerPort == NULL);
}

void UserDevClose(AXB_REG(struct IOStdReq *ior,a1),
                  AXB_REG(struct DevBase *db,a6))
{
  struct ExBase *eb = (struct ExBase *)db;

  D(("UserDevClose\n"));
  worker_stop(db, eb->eb_WorkerPort);
}

void DevBeginIO(AXB_REG(struct IOStdReq *ior,a1),
                AXB_REG(struct DevBase *db,a6))
{
  struct ExBase *eb = (struct ExBase *)db;

  D(("DevBeginIO\n"));

  ior->io_Error = 0;
  ior->io_Flags &= ~IOF_QUICK;
  switch(ior->io_Command)
  {
    case CMD_READ:
    case CMD_WRITE:
      /* forward message to worker process */
      PutMsg(eb->eb_WorkerPort, &ior->io_Message);
      break;
    case CMD_RESET:
    case CMD_UPDATE:
    case CMD_CLEAR:
    case CMD_STOP:
    case CMD_START:
    case CMD_FLUSH:
    case CMD_INVALID:
    default:
      ior->io_Error = IOERR_NOCMD;
      ReplyMsg(&ior->io_Message);
      break;
  }
}

LONG DevAbortIO(AXB_REG(struct IOStdReq *ior,a1),
                AXB_REG(struct DevBase *db,a6))
{
  D(("DevAbortIO\n"));
  return 0;
}
