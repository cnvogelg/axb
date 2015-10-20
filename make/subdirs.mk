# subdirs.mk
# support for compiling in subdirs
#
# defines:
# AXB_SUBDIRS    (req)  name of subdirectories
# AXB_SUB_RULES  (opt)  list of rules to propagate

AXP_TOP = $(realpath $(AXB_TOP))
export AXB_TOP
AXB_BUILD_TOP = $(realpath $(AXB_BUILD_TOP))
export AXB_BUILD_TOP

AXB_SUB_RULES ?= all clean

# $(1) rule
define SUB_RULE_TEMPLATE

$(1)_RULES = $$(addsuffix .$(1),$$(AXB_SUBDIRS))

ALL_PHONY += $(1) $(1)-subdirs $$($(1)_RULES)

$(1) $(1)-subdirs: $$($(1)_RULES)

$$($(1)_RULES): %.$(1):
	make -C $$* $(1)

endef

# generate template for all rules
$(foreach rule,$(AXB_SUB_RULES),$(eval $(call SUB_RULE_TEMPLATE,$(rule))))

.PHONY: $(ALL_PHONY)
