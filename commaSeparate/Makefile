#############################################################################
#
#	Makefile for commaSeparate
# 	John Schwartzman, Forte Systems, Inc.
# 	06/15/2019
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#	- OR -
#			  make release DEF=__MAIN__
#
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := commaSeparate
SHELL := /bin/bash
#DEF  := __MAIN__	

##### BUILD WITHOUT DEFINING __MAIN__ IN ORDER TO LINK WITH factorial. ######
################## BUILD THIS BEFORE BUILDING factorial. ####################

ifeq ($(DEF), __MAIN__)	############### STAND ALONE PROGRAM #################

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -D $(DEF) -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -no-pie $(PROG).obj -o $(PROG)

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -D $(DEF) -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -no-pie $(PROG).obj -o $(PROG)

else	#####################################################################

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm


endif	#####################################################################

clean:
	@rm -f $(PROG) $(PROG).obj $(PROG).lst debug release
#############################################################################
