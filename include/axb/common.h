#ifndef COMMON_H
#define COMMON_H

#ifdef __GNUC__
#define AXB_REG(t,r)  t __asm(#r)
#define AXB_ASM_REG(x) __attribute__((regparm(x)))
#else
#ifdef __VBCC__
#define AXB_REG(t,r) __reg( #r ) t
#define AXB_ASM_REG(x)
#else
#error unsupported compiler
#endif
#endif

#ifdef DEBUG
#define D(x) KPrintF x ;
#endif

#endif
