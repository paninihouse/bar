PREFIX ?= $(HOME)/.local/bin

# Auto-detect docc binary: prefer standalone, fall back to xcrun
DOCC := $(shell which docc 2>/dev/null || echo "xcrun docc")

# Derive the build triple from the bin path (e.g., arm64-apple-macosx)
BUILD_DIR := $(shell swift build -c debug --show-bin-path 2>/dev/null)
TRIPLE := $(notdir $(patsubst %/,%,$(dir $(BUILD_DIR))))
MODULE_DIR := .build/$(TRIPLE)/debug/Modules
SYMBOL_GRAPH_DIR := .build/$(TRIPLE)/symbolgraph

.DEFAULT_GOAL := all

all: run

run:
	swift run -c debug

build:
	swift build -c debug

release:
	swift build -c release

install: release
	install -d $(PREFIX)
	install ".build/release/bar" "$(PREFIX)/bar"

uninstall:
	rm -f "$(PREFIX)/bar"

clean:
	rm -rf .build .docc-build docs

# Build the project and generate symbol graphs (prerequisite for docc targets)
# Uses -minimum-access-level internal to capture doc-commented types even when they aren't public
symbol-graphs: build
	mkdir -p $(SYMBOL_GRAPH_DIR)
	xcrun swift-symbolgraph-extract \
		-module-name bar \
		-target $(TRIPLE)26.0 \
		-sdk $(shell xcrun --show-sdk-path 2>/dev/null) \
		-minimum-access-level internal \
		-I $(MODULE_DIR) \
		-output-dir $(SYMBOL_GRAPH_DIR)

preview-docs: symbol-graphs
	$(DOCC) preview Sources/bar/bar.docc \
		--additional-symbol-graph-dir $(SYMBOL_GRAPH_DIR) \
		--output-dir .docc-build

generate-docs: symbol-graphs
	$(DOCC) convert Sources/bar/bar.docc \
		--additional-symbol-graph-dir $(SYMBOL_GRAPH_DIR) \
		--transform-for-static-hosting \
		--hosting-base-path bar \
		--output-path ./docs \
		--source-service github \
		--source-service-base-url https://github.com/paninihouse/bar/blob/master \
		--checkout-path ~/Developer/paninihouse/tools/bar/

.PHONY: all run build release install uninstall clean symbol-graphs preview-docs generate-docs
