MODULE := bar

# Auto-detect docc binary: prefer standalone, fall back to xcrun
DOCC := $(shell which docc 2>/dev/null || echo "xcrun docc")

# Resolve paths relative to the package root, regardless of where make is invoked.
PKG_ROOT := $(abspath $(dir $(firstword $(MAKEFILE_LIST)))/../../..)

# SwiftPM emits symbol graphs for every module in the dependency graph. docc
# would then process dependency symbols too (e.g. FuzzyMatch), producing
# unrelated warnings. We emit into a staging dir and copy only our module's
# graphs into the directory docc actually reads.
SYMBOL_GRAPH_DIR := $(PKG_ROOT)/.build/symbolgraph
SYMBOL_GRAPH_STAGE := $(PKG_ROOT)/.build/symbolgraph-stage
DOCC_SOURCE := $(PKG_ROOT)/Sources/$(MODULE)/$(MODULE).docc

.DEFAULT_GOAL := build

# Build the project and emit symbol graphs via SwiftPM itself.
# This works for executable targets (which don't always emit a standalone
# .swiftmodule into the Modules dir), unlike invoking swift-symbolgraph-extract
# directly with -I <Modules>.
.PHONY: symbol-graphs
symbol-graphs:
	swift package --package-path $(PKG_ROOT) clean
	rm -rf $(SYMBOL_GRAPH_DIR) $(SYMBOL_GRAPH_STAGE)
	mkdir -p $(SYMBOL_GRAPH_STAGE)
	swift build \
		--package-path $(PKG_ROOT) \
		-Xswiftc -emit-symbol-graph \
		-Xswiftc -emit-symbol-graph-dir \
		-Xswiftc $(SYMBOL_GRAPH_STAGE) \
		-Xswiftc -symbol-graph-minimum-access-level \
		-Xswiftc internal
	mkdir -p $(SYMBOL_GRAPH_DIR)
	cp $(SYMBOL_GRAPH_STAGE)/$(MODULE).symbols.json $(SYMBOL_GRAPH_STAGE)/$(MODULE)@*.symbols.json $(SYMBOL_GRAPH_DIR)/

.PHONY: preview
preview: symbol-graphs
	$(DOCC) preview $(DOCC_SOURCE) \
		--additional-symbol-graph-dir $(SYMBOL_GRAPH_DIR) \
		--fallback-default-module-kind Tool \
		--output-dir $(PKG_ROOT)/.docc-build

.PHONY: build
build: symbol-graphs
	$(DOCC) convert $(DOCC_SOURCE) \
		--additional-symbol-graph-dir $(SYMBOL_GRAPH_DIR) \
		--fallback-default-module-kind Tool \
		--transform-for-static-hosting \
		--hosting-base-path $(MODULE) \
		--output-path $(PKG_ROOT)/.docs \
		--source-service github \
		--source-service-base-url https://github.com/paninihouse/$(MODULE)/blob/master \
		--checkout-path ~/Developer/paninihouse/tools/$(MODULE)/
