
AXB_TOP:=$(realpath $(AXB_TOP))

# set the used compilers
AXB_COMPILERS ?= VBCC GCC AROS_GCC SASC
# set the used variants
AXB_VARIANTS ?= OPT DEBUG

# targets: programs
AXB_TARGETS ?= $(AXB_PROGRAMS)

# add include
AXB_INCLUDES += . $(AXB_TOP)/include

include $(AXB_TOP)/make/common_def.mk
include $(AXB_TOP)/make/compiler_def.mk
include $(AXB_TOP)/make/assembler_def.mk
include $(AXB_TOP)/make/gen_def.mk

ifdef AXB_DEVICE
include $(AXB_TOP)/make/devices_def.mk
endif
