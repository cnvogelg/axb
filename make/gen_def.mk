
# $(1) compiler
# $(2) variant
define DEFS_CV_TEMPLATE

dummy := $$(shell echo hallo $(1) $(2))

# build dir
$(1)_$(2)_BUILD_DIR = $$(BUILD_DIR)/$$($(1)_EXT)_$($(2)_EXT)

# targets
$(1)_$(2)_TARGETS = $$(patsubst %,$$($(1)_$(2)_BUILD_DIR)/%,$$(AXB_TARGETS))

# combinte build dirs
ALL_BUILD_DIRS += $$($(1)_$(2)_BUILD_DIR)

# combine targets
ALL_TARGETS += $$($(1)_$(2)_TARGETS)

endef

# $(1) compiler
# $(2) variant
# $(3) target
define DEFS_CVT_TEMPLATE

# c objects of target
$(1)_$(2)_$(3)_C_OBJS = $$(patsubst %.c,$$($(1)_$(2)_BUILD_DIR)/%.o,$$(AXB_SRCS_C_$(3)))

# asm objects of target
$(1)_$(2)_$(3)_ASM_OBJS = $$(patsubst %.s,$$($(1)_$(2)_BUILD_DIR)/%.o,$$(AXB_SRCS_ASM_$(3)))

# all objects
$(1)_$(2)_$(3)_OBJS = $$($(1)_$(2)_$(3)_C_OBJS) $$($(1)_$(2)_$(3)_ASM_OBJS)

endef

# generate template for all compiler + variants
$(foreach compiler,$(AXB_COMPILERS),\
	$(foreach variant,$(AXB_VARIANTS),\
		$(eval $(call DEFS_CV_TEMPLATE,$(compiler),$(variant)))))

# generate template for all compiler + variants
$(foreach target,$(AXB_TARGETS),\
	$(foreach compiler,$(AXB_COMPILERS),\
		$(foreach variant,$(AXB_VARIANTS),\
			$(eval $(call DEFS_CVT_TEMPLATE,$(compiler),$(variant),$(target))))))
