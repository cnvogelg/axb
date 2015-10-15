# compile.mk

# --- VBCC ---
VBCC_BIN = vc
VBCC_CFLAGS_DEBUG = -g
VBCC_CFLAGS_OPT = -O2
VBCC_LDFLAGS_DEBUG = -g
VBCC_LIBS = -lamiga
VBCC_EXT = vbcc
VBCC_COMPILE_OUT = -c -o
VBCC_LINK_OUT = -o
VBCC_INC_PREFIX = -I

# --- GCC ---
GCC_BIN = m68k-amigaos-gcc
GCC_OBJCOPY = m68k-amigaos-objcopy
GCC_CFLAGS = -noixemul
GCC_CFLAGS_DEBUG = -g
GCC_CFLAGS_OPT = -O2
GCC_LDFLAGS = -noixemul
GCC_LDFLAGS_DEBUG = -g
GCC_EXT = gcc
GCC_COMPILE_OUT = -c -o
GCC_LINK_OUT = -o
GCC_INC_PREFIX = -I

# --- AROS_GCC ---
AROS_GCC_BIN = m68k-aros-gcc
AROS_GCC_CFLAGS_DEBUG = -g
AROS_GCC_CFLAGS_OPT = -O2
AROS_GCC_LDFLAGS_DEBUG = -g
AROS_GCC_EXT = agcc
AROS_GCC_COMPILE_OUT = -c -o
AROS_GCC_LINK_OUT = -o
AROS_GCC_INC_PREFIX = -I

# --- SASC ---
SASC_INSTALL_DIR ?= $(HOME)/amiga/shared/sc
SASC_VAMOSRC = $(AXB_TOP)/sasc.vamosrc
SASC_BIN = vamos -c $(SASC_VAMOSRC) sc
SASC_CFLAGS = SMALLDATA SMALLCODE NOSTKCHK NOCHKABORT NOICONS STRICT ANSI
SASC_CFLAGS_OPT = PARAMETERS=REGISTERS OPT OPTTIME OPTINLINE\
            OPTSCHEDULE STRINGMERGE STRUCTUREEQUIVALENCE NODEBUG
SASC_CFLAGS_DEBUG = DEBUG=F
SASC_EXT = sasc
SASC_COMPILE_OUT = OBJECTNAME
SASC_LINK_OUT = LINK TO
SASC_INCDIR = INCDIR=
