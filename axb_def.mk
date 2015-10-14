
# set the used compilers
AXB_COMPILERS ?= VBCC GCC AROS_GCC SASC
# set the used variants
AXB_VARIANTS ?= OPT DEBUG

# targets: programs
AXB_TARGETS ?= $(AXB_PROGRAMS)

include $(AXB_TOP)/make/compiler_def.mk
include $(AXB_TOP)/make/gen_def.mk
