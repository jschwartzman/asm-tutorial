#############################################################################
#
#	Makefile for printf
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ~/maketest.sh
#
#############################################################################
release: printf.asm Makefile
	@source maketest.sh && test release debug
	yasm -f elf64 -o printf.obj printf.asm
	gcc -m64 printf.obj -o printf

debug: printf.asm Makefile
	@source maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o printf.obj printf.asm
	gcc -m64 -g printf.obj -o printf

clean:
	@rm -f printf printf.obj debug release

#############################################################################
