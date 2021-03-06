#ifndef COMMON_H
#define COMMON_H

/* compiler specific switches */
#ifdef __GNUC__
#define AXB_REG(t,r)  t __asm(#r)
#define AXB_REG_FUNC __attribute__((regparm))
#else
#ifdef __VBCC__
#define AXB_REG(t,r) __reg( #r ) t
#define AXB_REG_FUNC
#else
#ifdef __SASC
#define AXB_REG(t,r) register __ ## r t
#define AXB_REG_FUNC __asm
#else
#error unsupported compiler
#endif
#endif
#endif

/* enable deubug macro D(()) */
#ifdef AXB_DEBUG
extern void KPrintF(char *, ...);
#define D(x) KPrintF x ;
#else
#define D(x)
#endif

#endif
