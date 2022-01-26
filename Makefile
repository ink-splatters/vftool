# Makefile for vftool
#

FWKS = -framework Foundation \
	-framework Virtualization
CFLAGS = -O3

RELEASE = impish 
VERSION = 21.10 

# TODO
ARCH = arm64
BASE_URL = https://cloud-images.ubuntu.com

# Image
IMG_NAME = ubuntu-$(VERSION)-server-cloudimg-$(ARCH).tar.gz
IMG_URL = $(BASE_URL)/releases/$(RELEASE)/release/$(IMG_NAME)


# Kernel
VMLINUZ_NAME = $(RELEASE)-server-cloudimg-$(ARCH)-vmlinuz-generic
VMLINUZ_URL = $(BASE_URL)/$(RELEASE)/current/unpacked/$(VMLINUZ_NAME)

# initrd
INITRD_NAME = $(RELEASE)-server-cloudimg-$(ARCH)-initrd-generic 
INITRD_URL = $(BASE_URL)/$(RELEASE)/current/unpacked/$(INITRD_NAME)



$(VMLINUZ_NAME):
	@echo curl -O $(VMLINUZ_URL)
	curl -O $(VMLINUZ_URL)

$(INITRD_NAME):
	curl -O $(INITRD_URL)

$(IMG_NAME)
	curl -O $(IMG_URL)
	

#all:  prep build sign
all: $(vmlinuz_name) $(initrd_name) $(img_name)

.PHONY: prep

prep:
	mkdir -p build/

build/vftool:	vftool/main.m
	clang $(CFLAGS) $< -o $@ $(FWKS)

.PHONY: sign
sign:	build/vftool
	codesign --entitlements vftool/vftool.entitlements --force -s - $<
	
clean:
	rm -rf build/

