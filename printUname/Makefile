#############################################################################
#
#	Makefile for printUname
# 	John Schwartzman, Forte Systems, Inc.
# 	05/16/2019
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := printUname
SHELL := /bin/bash

release: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -no-pie $(PROG).c $(PROG).obj -o $(PROG)	# link C prog with $(PROG).obj

debug: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -no-pie $(PROG).c $(PROG).obj -o $(PROG)	# link C prog with $(PROG).obj

clean:
	@rm -f $(PROG) $(PROG).obj $(PROG).lst debug release
#############################################################################
