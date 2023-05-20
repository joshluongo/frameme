PREFIX?=/usr/local
INSTALL_NAME = frameme

install: build install_bin

build:
	swift package update
	swift build -c release --arch arm64 --arch x86_64

build_here:
	swift package update
	swift build -c release --arch arm64 --arch x86_64
	mv .build/apple/Products/Release/$(INSTALL_NAME) ./$(INSTALL_NAME)

install_bin:
	mkdir -p $(PREFIX)/bin
	install .build/apple/Products/Release/$(INSTALL_NAME) $(PREFIX)/bin

uninstall:
	rm -f $(PREFIX)/bin/$(INSTALL_NAME)

test:
	swift package update
	swift test
