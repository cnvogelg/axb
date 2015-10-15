
# $(1) compiler
# $(2) variant
define RULE_COMPILE

# compiler rule
$$($(1)_$(2)_BUILD_DIR)/%.o : %.c
	$$($(1)_BIN) $$($(1)_$(2)_ALL_CFLAGS) $$($(1)_COMPILE_OUT) $$@ $$<

# generate code compile rule
$$($(1)_$(2)_BUILD_DIR)/%.o : $$(BUILD_DIR)/%.c
	$$($(1)_BIN) $$($(1)_$(2)_ALL_CFLAGS) $$($(1)_COMPILE_OUT) $$@ $$<

# assembler rule
$$($(1)_$(2)_BUILD_DIR)/%.o : %.s
	$$($$(AXB_ASM)_BIN) $$($(1)_$(2)_ALL_ASMFLAGS) $$($$(AXB_ASM)_OUT_FLAG) $$@ $$<

endef

# $(1) compiler
# $(2) variant
# $(3) target
define RULE_LINK

# link rule
$$($(1)_$(2)_BUILD_DIR)/$(3): $$($(1)_$(2)_$(3)_OBJS)
	$$($(1)_BIN) $$($(1)_LDFLAGS) $$($(1)_LDFLAGS_$(2)) $$($(1)_LINK_OUT) $$@ $$< $$($(1)_LIBS) $$($(1)_LIBS_$(2))

# convenience rule
$(3)-$(1)-$(2): $$($(1)_$(2)_BUILD_DIR)/$(3)

endef

# generate template for all compiler + variants
$(foreach compiler,$(AXB_COMPILERS),\
	$(foreach variant,$(AXB_VARIANTS),\
		$(eval $(call RULE_COMPILE,$(compiler),$(variant)))))

# generate link rules
$(foreach target,$(AXB_TARGETS),\
	$(foreach compiler,$(AXB_COMPILERS),\
		$(foreach variant,$(AXB_VARIANTS),\
			$(eval $(call RULE_LINK,$(compiler),$(variant),$(target))))))
