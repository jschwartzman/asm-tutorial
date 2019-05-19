#############################################################################
#
#	Makefile for uname
# 	John Schwartzman, Forte Systems, Inc.
# 	05/16/2019
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ../asm/maketest.sh
#
#############################################################################
PROG  := uname
SHELL := /bin/bash

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj $(PROG).asm	# assemble
	ld $(PROG).obj -o $(PROG)	# link
	gcc $(PROG).c	# compile and link C version (a.out)

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm	# assemble
	ld -g $(PROG).obj -o $(PROG)	# link 
	gcc -g $(PROG).c	# compile and link C version (a.out)

clean:
	@rm -f $(PROG) $(PROG).obj a.out debug release
#############################################################################
