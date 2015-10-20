# common defs

BUILD_DIR = $(AXB_BUILD_TOP)/BUILD/$(AXB_PROJECT)

# --- variant defs ---
OPT_EXT = opt
DEBUG_EXT = dbg

# --- toolchain ---
TOOLCHAIN_BASE ?= /opt/m68k-amigaos

# where to find the system headers
ASM_SYS_INCLUDES=$(TOOLCHAIN_BASE)/os-include
C_SYS_INCLUDES=$(TOOLCHAIN_BASE)/os-include
AMIGA_LIBS_DIR=$(TOOLCHAIN_BASE)/os-lib
