#include <proto/exec.h>
#include <proto/dos.h>
#include <dos/dostags.h>
#include <dos/dosextens.h>

#include <axb/devbase.h>
#include <axb/worker.h>

#define CMD_TERM     0x7ff0
#define CMD_STARTUP  0x7ff1

struct MyStartMsg {
  struct Message msg;
  struct DevBase *db;
  struct MsgPort *port;
};

static struct MyStartMsg * AXB_REG_FUNC worker_startup(void)
{
  struct Process *proc;
  struct MyStartMsg *msg;

  /* local sys base */
  RealSysBase;

  proc = (struct Process *)FindTask((char *)NULL);

  /* get the startup message */
  while((msg = (struct MyStartMsg *)GetMsg(&proc->pr_MsgPort)) == NULL) {
    WaitPort(&proc->pr_MsgPort);
  }

  /* extract DevBase db for lib base access */
  return msg;
}

static void AXB_REG_FUNC worker_main(void)
{
  struct IORequest *ior;
  struct DevBase *db;
  struct MsgPort *port;
  struct MyStartMsg *msg;
  int result;

  msg = worker_startup();
  db = msg->db;

  /* create worker port */
  port = CreateMsgPort();

  /* call user init */
  if(port != NULL) {
    result = user_worker_init(db);
    if(result == 0) {
      /* ok */
      msg->port = port;
    } else {
      DeleteMsgPort(port);
      port = NULL;
    }
  }

  /* reply startup message */
  ReplyMsg((struct Message *)msg);

  /* if port failed quit process */
  if(port == NULL)
  {
    return;
  }

  /* worker loop */
  D(("Worker: enter\n"));
  while (1) {
    WaitPort(port);
    while (ior = (struct IORequest *)GetMsg(port)) {
      /* terminate? */
      if(ior->io_Command == CMD_TERM) {
        goto end;
      }
      else {
        user_worker_cmd(db, ior);
      }
      ReplyMsg(&ior->io_Message);
    }
  }

end:
  D(("Worker: leave\n"));
  /* shutdown worker */
  user_worker_exit(db);

  Forbid();
  ReplyMsg(&ior->io_Message);
}

struct MsgPort * AXB_REG_FUNC worker_start(struct DevBase *db)
{
  struct Process *myProc;
  struct MyStartMsg msg;

  D(("Worker: start\n"));

  myProc = CreateNewProcTags(NP_Entry, (LONG)worker_main,
                             NP_StackSize, 4096,
                             NP_Name, (LONG)"DevWorker",
                             TAG_DONE);
  if (myProc == NULL) {
    return NULL;
  }

  /* Send the startup message with the library base pointer */
  msg.msg.mn_Length = sizeof(struct MyStartMsg) -
                      sizeof (struct Message);
  msg.msg.mn_ReplyPort = CreateMsgPort();
  msg.msg.mn_Node.ln_Type = NT_MESSAGE;
  msg.db = db;
  PutMsg(&myProc->pr_MsgPort, (struct Message *)&msg);
  WaitPort(msg.msg.mn_ReplyPort);
  DeleteMsgPort(msg.msg.mn_ReplyPort);
  return msg.port;
}

void AXB_REG_FUNC worker_stop(struct DevBase *db, struct MsgPort *port)
{
  struct IORequest newior;
  struct ExBase *eb = (struct ExBase *)db;

  D(("Worker: stop\n"));

  /* send a message to the child process to shut down. */
  newior.io_Message.mn_ReplyPort = CreateMsgPort();
  newior.io_Command = CMD_TERM;

  /* send term message and wait for reply */
  PutMsg(port, &newior.io_Message);
  WaitPort(newior.io_Message.mn_ReplyPort);
  DeleteMsgPort(newior.io_Message.mn_ReplyPort);

  /* cleanup worker port */
  DeleteMsgPort(port);
}
