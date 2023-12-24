#!/bin/bash

# Build and install awusb.ko (if it doesn't exist)
# Then load the module

set -eu

function LOAD {
    /sbin/depmod -a
    /sbin/modprobe awusb
    echo "Module loaded :)"
}

if test "$(whoami)" != "root"; then
    echo "Run this script as root!"
    exit 1
fi

DST="/lib/modules/$(uname -r)/kernel/awusb.ko"
if test -e "$DST"; then
    echo "Warning: Kernel module already exists at '$DST', not rebuilding/reinstalling! (Loading it instead)"
    LOAD
    exit
fi

# no need for parallel build: it's just one file anyway
cd awusb
make

cp awusb.ko "$DST"
rm awusb.ko
echo "Installed module to '$DST', loading it now..."
LOAD
