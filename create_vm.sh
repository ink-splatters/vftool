#!/bin/bash

set -e


OS_CODENAME="$1"
OS_VER="$2"
ARCH="arm64"

VM_HOME="$HOME/.vftool"
VM_PREFIX="ubuntu-$OS_CODENAME-$OS_VER"
VM_NAME="$3"
VM_PATH="$VM_HOME/$VM_PREFIX"
IMG_NAME="ubuntu-$OS_VER-server-cloudimg-$ARCH"

fi="$OS_CODENAME-server-cloudimg-$ARCH"

if [ ! -z "$VM_NAME" ]; then
    VM_PATH="$VM_PATH-$VM_NAME"
fi

if [[ $# < 2 ]] ; then
  echo 'Script to create Ubuntu VM based on Ubuntu Cloud Images'
  echo 'Usage: ./create_vm.sh <Ubuntu codename> <Ubuntu Version> [VM folder name]'
  exit 1
fi


vecho(){
  echo "[create_vm] $@"
}

verr(){
  echo "[create_vm] ERROR: $@"
}


vecho "This vill create the vm: $VM_PATH"
echo


if [ ! -d "$VM_PATH" ] ; then
  mkdir -p "$VM_PATH"
fi

#if [ -f "$VM_PATH/.dirty" ] ; then
#  vecho "$VM_PATH path already exists. if you wish to continue, remove $VM_PATH/.dirty file and start over again" 
#  vecho "For now you also need to remove partially downloaded files (TODO: check hashes instead)"
#  exit 1
# fi


touch "$VM_PATH/.dirty"

set -x

[[ ! -f "$VM_PATH"/vmlinuz ]] && curl -o- "https://cloud-images.ubuntu.com/releases/$OS_CODENAME/release/unpacked/ubuntu-$OS_VER-server-cloudimg-$ARCH-vmlinuz-generic" | gunzip > "$VM_PATH"/vmlinuz
[[ ! -f "$VM_PATH"/initrd ]] && curl -o "$VM_PATH"/initrd "https://cloud-images.ubuntu.com/releases/$OS_CODENAME/release/unpacked/ubuntu-$OS_VER-server-cloudimg-$ARCH-initrd-generic"
[[ ! -f "$VM_PATH"/$IMG_NAME ]] && curl -s https://cloud-images.ubuntu.com/releases/impish/release/$IMG_NAME.tar.gz | tar -xvz - -C "$VM_PATH"/
set +x 


