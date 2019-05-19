#############################################################################
#
#	Makefile for cmdline
#	John Schwartzman, Forte Systems, Inc.
#	05/16/2019
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := cmdline
SHELL := /bin/bash

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj $(PROG).asm
	gcc -m64 -no-pie $(PROG).obj -o $(PROG)
	gcc $(PROG).c

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm
	gcc -m64 -no-pie -g $(PROG).obj -o $(PROG)
	gcc -g $(PROG).c

clean:
	@rm -f $(PROG) $(PROG).obj a.out debug release

#############################################################################
