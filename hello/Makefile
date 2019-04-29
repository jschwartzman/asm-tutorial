#############################################################################
#
#	Makefile for hello
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ~/maketest.sh
#
#############################################################################
release: hello.asm Makefile
	@source maketest.sh && test release debug
	yasm -f elf64 -o hello.obj hello.asm
	ld hello.obj -o hello

debug: hello.asm Makefile
	@source maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o hello.obj hello.asm
	ld -g hello.obj -o hello

clean:
	@rm -f hello hello.obj debug release

#############################################################################
