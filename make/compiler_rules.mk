
# ----- build dir -----

all: build-targets

.PHONY: build-dirs

build-dirs: $(BUILD_DIR) $(ALL_BUILD_DIRS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# compiler dirs
$(ALL_BUILD_DIRS): $(BUILD_DIR)/%:
	mkdir $@

# clean up
clean:
	rm -rf $(BUILD_DIR)

# ----- compile rules -----

build-c-objs: build-dirs $(ALL_C_OBJS)

# --- VBCC ---
# opt
$(VBCC_BUILD_DIR_OPT)/%.o : %.c
	$(VBCC_BIN) $(VBCC_CFLAGS) $(VBCC_CFLAGS_OPT) -o $@ -c $<
# debug
$(VBCC_BUILD_DIR_DEBUG)/%.o : %.c
	$(VBCC_BIN) $(VBCC_CFLAGS) $(VBCC_CFLAGS_DEBUG) -o $@ -c $<

# --- GCC ---
# opt
$(GCC_BUILD_DIR_OPT)/%.o : %.c
	$(GCC_BIN) $(GCC_CFLAGS) $(GCC_CFLAGS_OPT) -o $@ -c $<
# debug
$(GCC_BUILD_DIR_DEBUG)/%.o : %.c
	$(GCC_BIN) $(GCC_CFLAGS) $(GCC_CFLAGS_DEBUG) -o $@ -c $<

# --- AROS_GCC ---
# opt
$(AROS_GCC_BUILD_DIR_OPT)/%.o : %.c
	$(AROS_GCC_BIN) $(AROS_GCC_CFLAGS) $(AROS_GCC_CFLAGS_OPT) -o $@ -c $<
# debug
$(AROS_GCC_BUILD_DIR_DEBUG)/%.o : %.c
	$(AROS_GCC_BIN) $(AROS_GCC_CFLAGS) $(AROS_GCC_CFLAGS_DEBUG) -o $@ -c $<

# --- SASC ---
# opt
$(SASC_BUILD_DIR_OPT)/%.o : %.c
	$(SASC_BIN) $(SASC_CFLAGS) $(SASC_CFLAGS_OPT) OBJECTNAME $@ $<
# dbg
$(SASC_BUILD_DIR_DEBUG)/%.o : %.c
	$(SASC_BIN) $(SASC_CFLAGS) $(SASC_CFLAGS_DEBUG) OBJECTNAME $@ $<

# ----- link rules -----

build-targets: build-dirs $(ALL_TARGETS)

# --- VBCC ---
# opt
$(VBCC_TARGET_OPT): $(VBCC_C_OBJS_OPT)
	$(VBCC_BIN) $(VBCC_LDFLAGS) $(VBCC_LDFLAGS_OPT) -o $@ $< $(VBCC_LIBS) $(VBCC_LIBS_OPT)
# debug
$(VBCC_TARGET_DEBUG): $(VBCC_C_OBJS_DEBUG)
	$(VBCC_BIN) $(VBCC_LDFLAGS) $(VBCC_LDFLAGS_DEBUG) -o $@ $< $(VBCC_LIBS) $(VBCC_LIBS_DEBUG)

# --- GCC ---
# opt
$(GCC_TARGET_OPT): $(GCC_C_OBJS_OPT)
	$(GCC_BIN) $(GCC_LDFLAGS) $(GCC_LDFLAGS_OPT) -o $@ $< $(GCC_LIBS) $(GCC_LIBS_OPT)
# debug
$(GCC_TARGET_DEBUG): $(GCC_C_OBJS_DEBUG)
	$(GCC_BIN) $(GCC_LDFLAGS) $(GCC_LDFLAGS_DEBUG) -o $@ $< $(GCC_LIBS) $(GCC_LIBS_DEBUG)

# --- AROS_GCC ---
# opt
$(AROS_GCC_TARGET_OPT): $(AROS_GCC_C_OBJS_OPT)
	$(AROS_GCC_BIN) $(AROS_GCC_LDFLAGS) $(AROS_GCC_LDFLAGS_OPT) -o $@ $< $(AROS_GCC_LIBS) $(AROS_GCC_LIBS_OPT)
# debug
$(AROS_GCC_TARGET_DEBUG): $(AROS_GCC_C_OBJS_DEBUG)
	$(AROS_GCC_BIN) $(AROS_GCC_LDFLAGS) $(AROS_GCC_LDFLAGS_DEBUG) -o $@ $< $(AROS_GCC_LIBS) $(AROS_GCC_LIBS_DEBUG)

# --- SASC ---
# opt
$(SASC_TARGET_OPT): $(SASC_C_OBJS_OPT)
	$(SASC_BIN) $(SASC_LDFLAGS) $(SASC_LDFLAGS_OPT) LINK TO $@ $< $(SASC_LIBS) $(SASC_LIBS_OPT)
# debug
$(SASC_TARGET_DEBUG): $(SASC_C_OBJS_DEBUG)
	$(SASC_BIN) $(SASC_LDFLAGS) $(SASC_LDFLAGS_DEBUG) LINK TO $@ $< $(SASC_LIBS) $(SASC_LIBS_DEBUG)
