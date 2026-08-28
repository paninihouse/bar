PREFIX ?= $(HOME)/.local

.PHONY: build
build: .build/release/bar

.build/release/bar:
	swift build -c release

.PHONY: run
run:
	swift run bar -c debug

.PHONY: clean
clean:
	@rm -rf .build .docc-build .docs

.PHONY: install
install: build
	@install -d $(PREFIX)/bin/
	@install -Dm755 .build/release/bar $(PREFIX)/bin/

.PHONY: uninstall
uninstall:
	@rm -f $(PREFIX)/bin/bar

.PHONY: docs
docs: .build/release/bar
	@$(MAKE) -C Sources/bar/bar.docc build

.PHONY: docs-preview
docs-preview: .build/release/bar
	@$(MAKE) -C Sources/bar/bar.docc preview
