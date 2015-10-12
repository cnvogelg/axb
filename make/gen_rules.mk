
# $(1) compiler
# $(2) variant
define RULE_TEMPLATE

# compiler rule
$$($(1)_$(2)_BUILD_DIR)/%.o : %.c
	$$($(1)_BIN) $$($(1)_CFLAGS) $$($(1)_CFLAGS_$(2)) $$($(1)_COMPILE_OUT) $$@ $$<

# link rule
$$($(1)_$(2)_TARGET): $$($(1)_$(2)_C_OBJS)
	$$($(1)_BIN) $$($(1)_LDFLAGS) $$($(1)_LDFLAGS_$(2)) $$($(1)_LINK_OUT) $$@ $$< $$($(1)_LIBS) $$($(1)_LIBS_$(2))

endef

# generate template for all compiler + variants
$(foreach compiler,$(AXB_COMPILERS),$(foreach variant,$(AXB_VARIANTS),$(eval $(call RULE_TEMPLATE,$(compiler),$(variant)))))
