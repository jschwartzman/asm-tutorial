#############################################################################
#
#	Makefile to invoke make in subdirectories
# 	John Schwartzman, Forte Systems, Inc.
# 	05/16/2019
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#
#############################################################################
SUBDIRS := $(wildcard */.)
SHELL   := /bin/bash

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
