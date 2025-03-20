CC := $(CURDIR)/dev/rebble.sh
CFLAGS :=
LDFLAGS :=

PEBBLE_DEVICE_TARGET := basalt

SRC_DIR := src
OBJ_DIR := build

TARGET := pebble-nerv2.pbw
MOUNTED_OBJ_DIR_PATH :=

.PHONY: all clean install run _set_out_dir

DEBUG :=
SUPERVERBOSE := #-vvv

all: build

build: $(TARGET)

build_debug:
	DEBUG := --debug
	$(MAKE) build

# Default target
$(TARGET):
	# project waf script runs before the default one(s?) that generated assets stubs
	# I've spent an entire evening trying to solve it
	# this crutch is what I should done in the first place

	cp wscript.default wscript
	PROJECT=$(CURDIR) $(CC) build $(SUPERVERBOSE) $(DEBUG)
	cp wscript.custom wscript
	PROJECT=$(CURDIR) $(CC) build $(SUPERVERBOSE) $(DEBUG)
	mv $(OBJ_DIR)/work.pbw $(OBJ_DIR)/$(TARGET)
	rm -rf wscript

clean:
	PROJECT=$(CURDIR) $(CC) clean;
	rm -rf $(OBJ_DIR) .lock_waf* # node_modules

# hangs
_set_out_dir:
	LOCK_WAF_FILE := $(shell find . -name ".lock-waf" -print -quit)
	ifneq ($(LOCK_WAF_FILE),)
		OUT_DIR := $(shell grep -o "out_dir = '.*'" $(LOCK_WAF_FILE) | cut -d"'" -f2)
		ifneq ($(OUT_DIR),)
			MOUNTED_OBJ_DIR_PATH := $(OUT_DIR)
		endif
	endif

	ifeq ($(MOUNTED_OBJ_DIR_PATH),)
		MOUNTED_OBJ_DIR_PATH := /work/$(OBJ_DIR)
	endif 

install: #_set_out_dir
	## TODO get /work from run_dir or out_dir from .lock
	# PROJECT=$(CURDIR) $(CC) install $(MOUNTED_OBJ_DIR_PATH)/$(TARGET) --emulator $(PEBBLE_DEVICE_TARGET) --logs
	PROJECT=$(CURDIR) $(CC) install /work/build/$(TARGET) --emulator $(PEBBLE_DEVICE_TARGET) --logs

run:
	$(MAKE) install
