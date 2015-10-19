#include <axb/common.h>
#include <axb/devbase.h>

int AXB_REG_FUNC user_worker_init(struct DevBase *db);
void AXB_REG_FUNC user_worker_exit(struct DevBase *db);
void AXB_REG_FUNC user_worker_cmd(struct DevBase *db, struct IORequest *ior);

struct MsgPort * AXB_REG_FUNC worker_start(struct DevBase *db);
void AXB_REG_FUNC worker_stop(struct DevBase *db, struct MsgPort *port);
