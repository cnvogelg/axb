# device_rules.mk

build-targets: device

device: build-dirs $(ALL_DEVICES)

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

# link rule for device
$$($(1)_$(2)_BUILD_DIR)/$$(AXB_DEVICE): $$($(1)_$(2)_DEVICE_OBJS)
	$$($(1)_BIN) $$($(1)_LDFLAGS) $$($(1)_DEVICE_LDFLAGS) $$($(1)_LDFLAGS_$(2)) \
		$$($(1)_LINK_OUT) $$@ $$+ \
		$$($(1)_$(2)_DEVICE_LIBS) \
		$$($(1)_LIBS) $$($(1)_LIBS_$(2))

endef

# generate template for all compiler + variants
$(foreach compiler,$(AXB_COMPILERS),\
  $(foreach variant,$(AXB_VARIANTS),\
    $(eval $(call DEVICE_RULE_TEMPLATE,$(compiler),$(variant)))))
