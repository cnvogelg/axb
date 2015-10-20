#include <axb/common.h>
#include <axb/devbase.h>

int user_worker_init(struct DevBase *db);
void user_worker_exit(struct DevBase *db);
void user_worker_cmd(struct DevBase *db, struct IORequest *ior);

struct MsgPort * worker_start(struct DevBase *db);
void worker_stop(struct DevBase *db, struct MsgPort *port);
