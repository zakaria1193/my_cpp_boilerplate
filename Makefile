.PHONY: gdb run build-release build-debug

BUILD_DIR := ./build

# Set flags based on variables
DRY_RUN_FLAG := $(if $(filter y,$(DRY_RUN)),-- -n)
VERBOSE_FLAG := $(if $(filter y,$(VERBOSE)),--verbose)

# Display settings
$(info Dry run = $(DRY_RUN))
$(info Verbose = $(VERBOSE))

# Configure target using a single preset
configure:
	cmake --preset default

clean:
	rm build -rf

# Separate build targets for Debug and Release
build-debug:
	cmake --build --preset default-build --config Debug $(VERBOSE_FLAG) $(DRY_RUN_FLAG)

build-release:
	cmake --build --preset default-build --config Release $(VERBOSE_FLAG) $(DRY_RUN_FLAG)

%:
	cmake --build --preset default-build --config Release $(VERBOSE_FLAG) $(DRY_RUN_FLAG) -t $@

# Run target in Debug configuration by default
OUTPUT_BIN := $(BUILD_DIR)/Debug/my_template_binary

run: build-debug
	$(OUTPUT_BIN)

# Debug with GDB in Debug configuration
gdb: build-debug
	gdb-multiarch $(OUTPUT_BIN) -ex "run"
