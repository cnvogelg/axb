include $(AXB_TOP)/make/compiler_rules.mk
include $(AXB_TOP)/make/gen_rules.mk

ifdef AXB_DEVICE
include $(AXB_TOP)/make/devices_rules.mk
endif
