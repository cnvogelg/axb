#include <exec/devices.h>
#include <dos/dos.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <clib/alib_protos.h>

int main(void)
{
    struct IOStdReq *ior;
    struct MsgPort *mp;
    char buff[10];

    Printf("main\n");
    if (mp = (struct MsgPort *)CreatePort(0,0))
    {
        Printf("got port\n");
        if (ior = (struct IOStdReq *)
                       CreateExtIO(mp, sizeof(struct IOStdReq)))
        {
            Printf("got extio\n");
            if (OpenDevice("example.device",0,(struct IORequest*)ior,0) == 0)
            {
                Printf("opened device\n");

                ior->io_Data = buff;
                ior->io_Command = CMD_READ;
                ior->io_Length = 1;
                DoIO((struct IORequest *)ior);
                Printf("done read\n");

                ior->io_Data = buff;
                ior->io_Command = CMD_WRITE;
                ior->io_Length = 1;
                DoIO((struct IORequest *)ior);
                Printf("done write\n");

                CloseDevice((struct IORequest *)ior);
            }
            DeleteExtIO((struct IORequest *)ior);
        }
        DeletePort(mp);
    }
    Printf("done\n");
    return 0;
}
