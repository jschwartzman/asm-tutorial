#############################################################################
#
#	Makefile for factorial
# 	John Schwartzman, Forte Systems, Inc.
# 	06/11/2019
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#	- OR -
#			  make release DEF=__COMMA__
#			  make debug DEF=__COMMA__
#
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := factorial
SHELL := /bin/bash
EXT	  := ../commaSeparate/commaSeparate
#DEF  := __COMMA__

ifeq ($(DEF), __COMMA__)	############### use commaSeparate ###############

release: $(PROG).asm Makefile $(EXT).obj
	@source ../maketest.sh && test release debug
	yasm -D $(DEF) -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -no-pie $(PROG).obj $(EXT).obj -o $(PROG)

debug: $(PROG).asm Makefile $(EXT).obj
	@source ../maketest.sh && test debug release
	yasm -D $(DEF) -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -no-pie $(PROG).obj $(EXT).obj -o $(PROG)

else

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -no-pie $(PROG).obj -o $(PROG)

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -no-pie $(PROG).obj -o $(PROG)

endif	######################## use commaSeparate ##########################

clean:
	@rm -f $(PROG) $(PROG).obj $(PROG).lst debug release
#############################################################################
