#!/bin/bash
#############################################################################
# make
# John Schwartzman, Forte Systems, Inc. 05/05/2019
#
# A makefile helper script to invoke Makefiles in subdirectories
#
# cmd = release, debug or clean
#############################################################################
ASMPATH=~/Development/asm
DIRS="hello uname history cmdline printenv prntenv"

for dir in $DIRS
do
    echo -e "\nRunning make $@ in $ASMPATH/$dir directory..."
    cd $ASMPATH/$dir
    make "$@"
done

echo
#############################################################################