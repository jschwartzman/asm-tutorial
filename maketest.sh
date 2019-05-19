#!/bin/bash
#############################################################################
# maketest.sh
# John Schwartzman, Forte Systems, Inc. 05/04/2019
#
# A makefile helper script to manage debug and release makefiles 
# using the same source, object and executable files.
# In Makefile use:  @source ../maketest.sh && test release debug (release)
#					@source ../maketest.sh && test debug release (debug)
# Invoke Makefile with make release, make debug or make clean.
#
#############################################################################
function test()
{
	if [[ ! -f $1 ]]; then
		touch $1;	
		rm -f $2;
	fi
}
#############################################################################
