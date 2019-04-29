#############################################################################
#
#	Makefile for history
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ~/maketest.sh
#
#############################################################################
release: history.asm Makefile
	@source maketest.sh && test release debug
	yasm -f elf64 -o history.obj history.asm
	gcc -m64 history.obj -o history

debug: history.asm Makefile
	@source maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o history.obj history.asm
	gcc -m64 -g history.obj -o history

clean:
	@rm -f history history.obj debug release

#############################################################################
