#ifndef DEVBASE_H
#define DEVBASE_H

#include <exec/exec.h>
#include <dos/dos.h>
#include <axb/common.h>

#ifndef DOS_MIN_VERSION
#define DOS_MIN_VERSION 37
#endif

struct DevBase {
  struct Library  db_Lib;
  struct Library *db_SysBase;
  BPTR            db_SegList;
#ifdef AXB_DEVICE_USE_DOS
  struct Library *db_DosBase;
#endif
};

/* for Exec inline macros: access base via DevBase */
#define SysBase db->db_SysBase
#ifdef AXB_DEVICE_USE_DOS
#define DOSBase db->db_DosBase
#endif

/* fake db->db_SysBase for new tasks */
#define RealSysBase struct { struct Library *db_SysBase; } *db = (void*)0x4

/* easy access to device */
int UserDevInit(AXB_REG(struct DevBase *db,a6));
void UserDevExpunge(AXB_REG(struct DevBase *db,a6));
int UserDevOpen(AXB_REG(struct IOStdReq *ior,a1),
                AXB_REG(ULONG unit,d0),
                AXB_REG(struct DevBase *db,a6));
void UserDevClose(AXB_REG(struct IOStdReq *ior,a1),
                  AXB_REG(struct DevBase *db,a6));

#endif
