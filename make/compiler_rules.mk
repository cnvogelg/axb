
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

# ----- link rules -----

build-targets: build-dirs $(ALL_TARGETS)
