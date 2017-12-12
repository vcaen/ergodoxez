#include qmk_firmware/Makefile

LAYOUT_NAME := vadim
KEYMAP_DIR := fork_qmk_firmware/keyboards/ergodox_ez/keymaps/$(LAYOUT_NAME)
DOWNLOAD_DIR := downloaded_keymaps
DOWNLOAD_URL := "http://configure.ergodox-ez.com/keyboard_layouts/{ID}/download_source"

ifndef id
	id := qmxlzb
endif

download:
	curl -v -f -o $(DOWNLOAD_DIR)/keymap_$(id).c $(subst {ID},$(id),$(DOWNLOAD_URL))
	exit 0;

gen:
	mkdir -p gen
	cp $(DOWNLOAD_DIR)/keymap_$(id).c gen/keymap.c
	sed -i $(subst {LAYOUT},$(LAYOUT_NAME), '1i #include "{LAYOUT}.h"') gen/keymap.c

build:
	cp gen/keymap.c $(KEYMAP_DIR)/keymap.c
	$(MAKE) -C fork_qmk_firmware ergodox_ez:$(LAYOUT_NAME):teensy

link:
	ln -s KEYMAP_DIR/keymaps.c;
	ln -s KEYMAP_DIR/keymaps.c;
	ln -s KEYMAP_DIR/keymaps.c;

all: download gen build

.PHONY: all gen download
