#include <proto/exec.h>

#include <axb/common.h>
#include <axb/devbase.h>

struct Device * AXB_REG_FUNC DevInit(AXB_REG(struct DevBase *db,d0),
                                     AXB_REG(BPTR seglist,a0),
                                     AXB_REG(struct Library *_SysBase,a6))
{
  /* store sys base */
  db->db_SegList = seglist;
  db->db_SysBase = _SysBase;

#ifdef AXB_DEVICE_USE_DOS
  db->db_DosBase = OpenLibrary("dos.library", DOS_MIN_VERSION);
  if(db->db_DosBase == NULL) {
    return NULL;
  }
#endif

  /* user init */
  UserDevInit(db);

  /* return device base if all went well */
  return (struct Device *)db;
}

BPTR AXB_REG_FUNC DevExpunge(AXB_REG(struct DevBase *db,a6))
{
  BPTR seglist = 0;

  db->db_Lib.lib_Flags |= LIBF_DELEXP;

  /* really expunge */
  if (db->db_Lib.lib_OpenCnt == 0) {
    ULONG libsize;

    /* user exit */
    UserDevExpunge(db);

#ifdef AXB_DEVICE_USE_DOS
    CloseLibrary(db->db_DosBase);
#endif

    seglist = db->db_SegList;

    /* remove device node */
    Remove( (struct Node *) db);

    /* free lib memory */
    libsize = db->db_Lib.lib_NegSize + db->db_Lib.lib_PosSize;
    FreeMem( db - db->db_Lib.lib_NegSize, libsize );
  }

  return seglist;
}

LONG AXB_REG_FUNC DevOpen(AXB_REG(struct IOStdReq *ior,a1),
                          AXB_REG(ULONG unit,d0),
                          AXB_REG(ULONG flags,d1),
                          AXB_REG(struct DevBase *db,a6))
{
  /* count user */
  db->db_Lib.lib_OpenCnt++;

  /* clear delayed expunges (standard procedure) */
  db->db_Lib.lib_Flags &= ~LIBF_DELEXP;

  /* call user init */
  if(UserDevOpen(ior, unit, db)!=0) {
    db->db_Lib.lib_OpenCnt--;
    return NULL;
  }

  return (LONG)db;
}

BPTR AXB_REG_FUNC DevClose(AXB_REG(struct IOStdReq *ior,a1),
                           AXB_REG(struct DevBase *db,a6))
{
  BPTR seglist;

  /* call user cleanup */
  UserDevClose(ior, db);

  /* remove user count */
  db->db_Lib.lib_OpenCnt--;

  /* default close with expunge */
  if ((db->db_Lib.lib_OpenCnt == 0) &&
      (db->db_Lib.lib_Flags & LIBF_DELEXP)) {
    seglist = DevExpunge(db);
  } else {
    seglist = 0;
  }
  return seglist;
}

