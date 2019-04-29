#############################################################################
#
#	Makefile for cmdline
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ~/maketest.sh
#
#############################################################################
release: cmdline.asm Makefile
	@source maketest.sh && test release debug
	yasm -f elf64 -o cmdline.obj cmdline.asm
	gcc -m64 cmdline.obj -o cmdline

debug: cmdline.asm Makefile
	@source maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o cmdline.obj cmdline.asm
	gcc -m64 -g cmdline.obj -o cmdline

clean:
	@rm -f cmdline cmdline.obj debug release

#############################################################################
