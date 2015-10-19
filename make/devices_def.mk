# device_def.mk

# auto-generate device info
DEVINFO_INC = $(BUILD_DIR)/devinfo.i
DEVSIZE_C   = $(BUILD_DIR)/devsize.c

# devstub source
AXB_DEVICE_C = $(AXB_TOP)/src/axb_device.c
AXB_DEVSTUB_ASM = $(AXB_TOP)/src/axb_devstub.s

# add device sources
VPATH += $(AXB_TOP)/src $(BUILD_DIR)

# ----- template -----
# $(1) compilers
# $(2) variant
define DEVICE_DEF_TEMPLATE

# derived device name
$(1)_$(2)_DEVICE_FILE = $$($(1)_$(2)_BUILD_DIR)/$$(AXB_DEVICE)

# auto-generate device size
$(1)_$(2)_DEVSIZE_OBJ = $$($(1)_$(2)_BUILD_DIR)/devsize.o
$(1)_$(2)_DEVSIZE_INC = $$($(1)_$(2)_BUILD_DIR)/devsize.i
$(1)_$(2)_DEVSIZE_RAW = $$($(1)_$(2)_BUILD_DIR)/devsize.raw

# compiled devstub and device
$(1)_$(2)_AXB_DEVSTUB_OBJ = $$($(1)_$(2)_BUILD_DIR)/axb_devstub.o
$(1)_$(2)_AXB_DEVICE_OBJ = $$($(1)_$(2)_BUILD_DIR)/axb_device.o

# extra device files
ifneq (,($findstring AXB_DEVICE_USE_WORKER,$(AXB_DEFINES)))
$(1)_$(2)_AXB_DEVICE_OBJ += $$($(1)_$(2)_BUILD_DIR)/axb_worker.o
endif

# stubs and user device files
$(1)_$(2)_DEVICE_OBJS = $$($(1)_$(2)_AXB_DEVSTUB_OBJ) $$($(1)_$(2)_AXB_DEVICE_OBJ) \
	$$(patsubst %.c,$$($(1)_$(2)_BUILD_DIR)/%.o,$$(AXB_DEVICE_SRCS_C))

# extra libs for device
$(1)_$(2)_DEVICE_LIBS = $$(patsubst %,$$(AMIGA_LIBS_DIR)/%,$$(AXB_DEVICE_AMI_LIBS))
$(1)_$(2)_DEVICE_LIBS += $$(patsubst %,$$($(1)_LIB_PREFIX)%,$$(AXB_DEVICE_LIBS))

ALL_DEVICE_OBJS += $$($(1)_$(2)_DEVICE_OBJS)
ALL_DEVSIZE_INCS += $$($(1)_$(2)_DEVSIZE_INC)

ALL_DEVICES += $$($(1)_$(2)_BUILD_DIR)/$$(AXB_DEVICE)

endef

# generate template for all compiler + variants
$(foreach compiler,$(AXB_COMPILERS),\
  $(foreach variant,$(AXB_VARIANTS),\
    $(eval $(call DEVICE_DEF_TEMPLATE,$(compiler),$(variant)))))
