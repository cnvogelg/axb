#include <proto/exec.h>
#include <proto/dos.h>
#include <dos/dostags.h>
#include <dos/dosextens.h>
#include <devices/serial.h>

#include "exbase.h"

#define CMD_TERM     0x7ff0
#define CMD_STARTUP  0x7ff1

struct MyStartMsg {
  struct Message msg;
  struct ExBase *eb;
};

void MyWorker(void)
{
  struct IORequest *ior;
  struct IOExtSer *ioes;
  long input, output;
  struct Process *proc;
  struct MyStartMsg *msg;
  struct DevBase *db;
  struct ExBase *eb;
  struct MsgPort *port;

  proc = (struct Process *)FindTask((char *)NULL);

  /* get the startup message */
  while((msg = (struct MyStartMsg *)GetMsg(&proc->pr_MsgPort)) == NULL) {
    WaitPort(&proc->pr_MsgPort);
  }

  /* extract DevBase db for lib base access */
  eb = msg->eb;
  db = (struct DevBase *)eb;

  /* create worker port */
  port = CreateMsgPort();
  eb->eb_WorkerPort = port;

  /* reply startup message */
  ReplyMsg((struct Message *)msg);

  /* if port failed quit process */
  if(port == NULL)
  {
    return;
  }

  /* open some windows */
  input = Open("con:0/0/400/100/Input", MODE_NEWFILE);
  output = Open("con:0/110/400/100/Output", MODE_NEWFILE);

  /* worker loop */
  while (1) {
    WaitPort(port);
    while (ior = (struct IORequest *)GetMsg(port)) {
      switch(ior->io_Command) {
        case CMD_TERM:
          goto end;
          break;

        case CMD_READ:
            ioes = (struct IOExtSer *)ior;
            ioes->IOSer.io_Actual = Read(input,
                                   ioes->IOSer.io_Data,
                                   ioes->IOSer.io_Length);
            break;

        case CMD_WRITE:
             Write(output, ioes->IOSer.io_Data,
                   ioes->IOSer.io_Length);
             break;
      }
      ReplyMsg(&ior->io_Message);
    }
  }

end:
  /* shutdown worker */
  Close(input);
  Close(output);
  Forbid();
  ReplyMsg(&ior->io_Message);
}

int UserDevInit(struct DevBase *db REG(a6))
{
  return 0;
}

void UserDevExpunge(struct DevBase *db REG(a6))
{
}

int UserDevOpen(struct IOStdReq *ior REG(a1),
                ULONG unit REG(d0),
                struct DevBase *db REG(a6))
{
#if 0

  struct Process *myProc;
  struct MyStartMsg msg;
  struct ExBase *eb = (struct ExBase *)db;

  myProc = CreateNewProcTags(NP_Entry, (LONG)MyWorker,
                             NP_StackSize, 4096,
                             NP_Name, (LONG)"ExampleWorker",
                             TAG_DONE);
  if (myProc == NULL) {
    return 1;
  }

  /* Send the startup message with the library base pointer */
  msg.msg.mn_Length = sizeof(struct MyStartMsg) -
                      sizeof (struct Message);
  msg.msg.mn_ReplyPort = CreateMsgPort();
  msg.msg.mn_Node.ln_Type = NT_MESSAGE;
  msg.eb = eb;
  PutMsg(&myProc->pr_MsgPort, (struct Message *)&msg);
  WaitPort(msg.msg.mn_ReplyPort);

  if (eb->eb_WorkerPort == NULL) /* CMD_Handler allocates this */
    return NULL;

  DeleteMsgPort(msg.msg.mn_ReplyPort);
#endif
  return 0;
}

void UserDevClose(struct IOStdReq *ior REG(a1),
                  struct DevBase *db REG(a6))
{
#if 0
  struct IORequest newior;
  struct ExBase *eb = (struct ExBase *)db;

  /* send a message to the child process to shut down. */
  newior.io_Message.mn_ReplyPort = CreateMsgPort();
  newior.io_Command = CMD_TERM;
  newior.io_Unit = ior->io_Unit;

  /* send term message and wait for reply */
  PutMsg(eb->eb_WorkerPort, &newior.io_Message);
  WaitPort(newior.io_Message.mn_ReplyPort);
  DeleteMsgPort(newior.io_Message.mn_ReplyPort);

  /* cleanup worker port */
  DeleteMsgPort(eb->eb_WorkerPort);
#endif
}

void DevBeginIO(struct IOStdReq *ior REG(a1),
                struct DevBase *db REG(a6))
{
  struct ExBase *eb = (struct ExBase *)db;
  ior->io_Error = 0;
  ior->io_Flags &= ~IOF_QUICK;
  switch(ior->io_Command)
  {
#if 0
    case CMD_READ:
    case CMD_WRITE:
      PutMsg(eb->eb_WorkerPort, &ior->io_Message);
      break;
#endif
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

LONG DevAbortIO(struct IOStdReq *ior REG(a1),
                struct DevBase *db REG(a6))
{
  return 0;
}
