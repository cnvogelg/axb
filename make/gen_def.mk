
# $(1) compiler
# $(2) variant
define COMPILER_TEMPLATE

dummy := $$(shell echo hallo $(1) $(2))

# build dir
$(1)_$(2)_BUILD_DIR = $$(BUILD_DIR)/$$($(1)_EXT)_$($(2)_EXT)

# c object files
$(1)_$(2)_C_OBJS = $$(patsubst %.c,$$($(1)_$(2)_BUILD_DIR)/%.o,$$(AXB_C_SRCS))

# target
$(1)_$(2)_TARGET = $$($(1)_$(2)_BUILD_DIR)/$$(AXB_TARGET)

# combinte build dirs
ALL_BUILD_DIRS += $$($(1)_$(2)_BUILD_DIR)

# combine objs
ALL_C_OBJS += $$($(1)_$(2)_C_OBJS)

# combine targets
ALL_TARGETS += $$($(1)_$(2)_TARGET)

endef

# generate template for all compiler + variants
$(foreach compiler,$(AXB_COMPILERS),$(foreach variant,$(AXB_VARIANTS),$(eval $(call COMPILER_TEMPLATE,$(compiler),$(variant)))))
