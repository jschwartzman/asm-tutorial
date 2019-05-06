#############################################################################
#
#	Makefile for prntenv
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ~/maketest.sh
#
#############################################################################
PROG := prntenv

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj $(PROG).asm	# assemble 
	gcc $(PROG).c $(PROG).obj -o $(PROG)	# link C prog with printenv.obj

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm	# assemble
	gcc -g $(PROG).c $(PROG).obj -o $(PROG)	# link C prog with printenv.obj

clean:
	@rm -f $(PROG) $(PROG).obj $(PROG) debug release
#############################################################################
