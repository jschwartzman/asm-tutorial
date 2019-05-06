#############################################################################
#
#	Makefile to invoke make in asm subdirectories
# 	John Schwartzman, Forte Systems, Inc.
# 	05/06/2019
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#
#############################################################################
ASMPATH := $(shell pwd)
SUBDIRS := $(wildcard */.)

.PHONEY: clean debug release

define submake
	@for dir in $(SUBDIRS);					\
	do										\
		echo;								\
		$(MAKE) $(1) --directory=$$dir;		\
	done
endef

release:
	$(call submake, release)
	@echo

debug:
	$(call submake, debug)
	@echo

clean:
	$(call submake, clean)

#############################################################################
