
# what is the generated target file
AXB_TARGET ?= $(AXB_PROJECT)
# set the used compilers
AXB_COMPILERS ?= VBCC GCC AROS_GCC SASC
# set the used variants
AXB_VARIANTS ?= OPT DEBUG

include $(AXB_TOP)/make/compiler_def.mk
include $(AXB_TOP)/make/gen_def.mk
