include qmk_firmware/Makefile

download:
	curl -o fork_qmk_firmware/keyboards/ergodox_ez/keymaps/vadim/keymap_download.c http://configure.ergodox-ez.com/keyboard_layouts/$(id)/download_source;
	exit 0;

custom:
	$(MAKE) -C fork_qmk_firmware ergodox_ez:vadim:teensy
