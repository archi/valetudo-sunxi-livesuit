#!/bin/bash

# This script builds and installs the bundled libpng into the LD_LIBRARY_PATH
#  used by the LiveSuite.sh; this way the libpng version won't pollute your
#  system.

set -eu

VER="1.2.54"
TOP_DIR=`pwd`

MACHINE=$(uname -m)
if [ ${MACHINE} == 'x86_64' ]; then
	BIN_DIR="x86-64"	
elif [ ${MACHINE} == 'i686' ]; then
	BIN_DIR="x86"
else
	echo "Error: unknown architecture ${MACHINE}"
	exit
fi

test -e "libpng-$VER" || tar xvf "libpng_$VER.orig.tar.xz"
cd "libpng-$VER"
./autogen.sh

test -e "build" && rm -rf build
mkdir build
cd build
PREFIX="${TOP_DIR}/${BIN_DIR}"
../configure --prefix "$PREFIX" --libdir "$PREFIX"

if test "$#" == "0"; then
    make -j2
else
    make "$*"
fi

make install

echo " "
echo "Built the libpng-$VER and installed it to '$PREFIX'"
echo "You can run ./LiveSuite.sh now!"
