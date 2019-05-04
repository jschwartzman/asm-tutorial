#############################################################################
#
#	Makefile for cmdline
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ~/maketest.sh
#
#############################################################################
PROG := cmdline

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj $(PROG).asm
	gcc -m64 $(PROG).obj -o $(PROG)

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm
	gcc -m64 -g $(PROG).obj -o $(PROG)

clean:
	@rm -f $(PROG) $(PROG).obj a.out debug release

#############################################################################
