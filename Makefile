PREFIX ?= /usr/local/bin

all: run

run:
	swift run -c debug

build:
	swift build -c release

install: build
	install -d $(PREFIX)
	install ".build/release/bar" "$(PREFIX)/bar"

uninstall:
	rm -f "$(PREFIX)/bar"

clean:
	rm -rf .build

.PHONY: all run build install uninstall clean
