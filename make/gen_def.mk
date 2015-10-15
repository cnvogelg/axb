
# $(1) compiler
# $(2) variant
define DEFS_CV_TEMPLATE

dummy := $$(shell echo hallo $(1) $(2))

# includes
$(1)_$(2)_INCDIRS = $$(patsubst %,$$($(1)_INC_PREFIX)%,$$(AXB_INCLUDES))

# all c flags
$(1)_$(2)_ALL_CFLAGS = $$($(1)_CFLAGS) $$($(1)_CFLAGS_$(2)) $$($(1)_$(2)_INCDIRS)

# all asm flags
$(1)_$(2)_ALL_ASMFLAGS = $$($$(AXB_ASM)_C_$(1)_OUT) $$($$(AXB_ASM)_FLAGS) \
	$$($$(AXB_ASM)_INC_PREFIX) $$(BUILD_DIR) \
	$$($$(AXB_ASM)_INC_PREFIX) $$($(1)_$(2)_BUILD_DIR)

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

# combine objects
ALL_C_OBJS += $$($(1)_$(2)_$(3)_C_OBJS)
ALL_ASM_OBJS += $$($(1)_$(2)_$(3)_ASM_OBJS)

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
