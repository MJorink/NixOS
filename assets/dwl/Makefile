.POSIX:
.SUFFIXES:

PREFIX = /usr/local
PKG_CONFIG = pkg-config
WAYLAND_SCANNER = `$(PKG_CONFIG) --variable=wayland_scanner wayland-scanner`
WAYLAND_PROTOCOLS = `$(PKG_CONFIG) --variable=pkgdatadir wayland-protocols`
XWAYLAND = -DXWAYLAND
XLIBS = xcb xcb-icccm
CC = cc

PKGS    = wayland-server xkbcommon libinput wlroots-0.20 $(XLIBS)
DWLCFLAGS = `$(PKG_CONFIG) --cflags $(PKGS)` -I. -DWLR_USE_UNSTABLE \
	-D_POSIX_C_SOURCE=200809L -DVERSION=\"0.10-dev\" $(XWAYLAND) \
	-Wall -Wextra -Wno-unused-parameter $(CPPFLAGS) $(CFLAGS)
LDLIBS  = `$(PKG_CONFIG) --libs $(PKGS)` -lm $(LIBS)

dwl: dwl.c client.h config.h util.h cursor-shape-v1-protocol.h \
	ext-image-copy-capture-v1-protocol.h \
	pointer-constraints-unstable-v1-protocol.h wlr-layer-shell-unstable-v1-protocol.h \
	wlr-output-power-management-unstable-v1-protocol.h xdg-shell-protocol.h \
	dwl-ipc-unstable-v2-protocol.h dwl-ipc-unstable-v2-protocol.c
	$(CC) dwl.c dwl-ipc-unstable-v2-protocol.c $(DWLCFLAGS) $(LDFLAGS) $(LDLIBS) -o $@

cursor-shape-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		$(WAYLAND_PROTOCOLS)/staging/cursor-shape/cursor-shape-v1.xml $@
ext-image-copy-capture-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		$(WAYLAND_PROTOCOLS)/staging/ext-image-copy-capture/ext-image-copy-capture-v1.xml $@
pointer-constraints-unstable-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		$(WAYLAND_PROTOCOLS)/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml $@
wlr-layer-shell-unstable-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		protocols/wlr-layer-shell-unstable-v1.xml $@
wlr-output-power-management-unstable-v1-protocol.h:
	$(WAYLAND_SCANNER) server-header \
		protocols/wlr-output-power-management-unstable-v1.xml $@
xdg-shell-protocol.h:
	$(WAYLAND_SCANNER) server-header \
		$(WAYLAND_PROTOCOLS)/stable/xdg-shell/xdg-shell.xml $@
dwl-ipc-unstable-v2-protocol.h:
	$(WAYLAND_SCANNER) server-header \
		protocols/dwl-ipc-unstable-v2.xml $@
dwl-ipc-unstable-v2-protocol.c:
	$(WAYLAND_SCANNER) private-code \
		protocols/dwl-ipc-unstable-v2.xml $@

install: dwl
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dwl $(DESTDIR)$(PREFIX)/bin
