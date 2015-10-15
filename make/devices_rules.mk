# device_rules.mk

device-devinfo: $(DEVINFO_INC)
	@cat $(DEVINFO_INC)

device-devsize: $(ALL_DEVSIZE_INCS)
	@cat $(ALL_DEVSIZE_INCS)

device-objs: $(ALL_DEVICE_OBJS)

# ----- devinfo -----
# generate device info asm include header
$(DEVINFO_INC): Makefile $(BUILD_DIR)
	@echo "generating devinfo include $@"
	@echo "DEVICE_NAME  MACRO" > $@
	@echo "  dc.b '$(AXB_DEVICE)'" >> $@
	@echo "  ENDM" >> $@
	@echo "DEVICE_DATE  MACRO" >> $@
	@echo "  dc.b '$(AXB_DEVICE_DATE)'" >> $@
	@echo "  ENDM" >> $@
	@echo "DEVICE_VER  MACRO" >> $@
	@echo "  dc.b '$(AXB_DEVICE_VERSION).$(AXB_DEVICE_REVISION)'" >> $@
	@echo "  ENDM" >> $@
	@echo "DEVICE_VERSION equ $(AXB_DEVICE_VERSION)" >> $@
	@echo "DEVICE_REVISION equ $(AXB_DEVICE_REVISION)" >> $@


# ----- devsize -----
# generate devsize
$(DEVSIZE_C): $(AXB_DEVICE_LIBSIZE_HEADER) $(BUILD_DIR)
	@echo "generating devsize file $@"
	@echo "#include \"$(AXB_DEVICE_LIBSIZE_HEADER)\"" > $@
	@echo "ULONG LibSize = sizeof(struct $(AXB_DEVICE_LIBSIZE_NAME));" >> $@


# ----- template -----
# $(1) compiler
# $(2) variant
define DEVICE_RULE_TEMPLATE

# generate devsize
$$($(1)_$(2)_DEVSIZE_OBJ): $$($(1)_$(2)_BUILD_DIR)

$$($(1)_$(2)_DEVSIZE_RAW): $$($(1)_$(2)_DEVSIZE_OBJ)
	$(GCC_OBJCOPY) -O binary $$< $$@

$$($(1)_$(2)_DEVSIZE_INC): $$($(1)_$(2)_DEVSIZE_RAW)
	@python -c 'import struct;import sys; print "LibSize equ",struct.unpack(">I",sys.stdin.read())[0]' <$$< >$$@

# dependency for stub
$$($(1)_$(2)_AXB_DEVSTUB_OBJ): $$(DEVINFO_INC) $$($(1)_$(2)_DEVSIZE_INC)

endef

# generate template for all compiler + variants
$(foreach compiler,$(AXB_COMPILERS),\
  $(foreach variant,$(AXB_VARIANTS),\
    $(eval $(call DEVICE_RULE_TEMPLATE,$(compiler),$(variant)))))
