#############################################################################
#
#	Makefile for history
# 	John Schwartzman, Forte Systems, Inc.
# 	06/16/2019
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := history
SHELL := /bin/bash

release: $(PROG).c $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj $(PROG).asm
	gcc -no-pie -m64 $(PROG).obj -o $(PROG)
	gcc $(PROG).c

debug: $(PROG).c $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm
	gcc -m64 -g -no-pie $(PROG).obj -o $(PROG)
	gcc -g $(PROG).c

clean:
	@rm -f $(PROG) $(PROG).obj a.out debug release
#############################################################################
