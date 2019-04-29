#############################################################################
#
#	Makefile for uname
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ~/maketest.sh
#
#############################################################################
release: uname.asm Makefile
	@source maketest.sh && test release debug
	yasm -f elf64 -o uname.obj uname.asm
	ld uname.obj -o uname

debug: uname.asm Makefile
	@source maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o uname.obj uname.asm
	ld -g uname.obj -o uname

clean:
	@rm -f uname uname.obj debug release

#############################################################################
