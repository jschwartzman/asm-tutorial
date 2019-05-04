#!/bin/bash
#############################################################################
# maketest.sh
# John Schwartzman, Forte Systems, Inc. 4/26/2019
#
# A makefile helper script to manage debug and release makefiles 
# using the same source, object and executable files.
# In Makefile use:  @source ../maketest.sh && test release debug (for release)
#						-OR-
#		    @source ../maketest.sh && test debug release (for debug)
# Invoke Makefiles with make release, make debug or make clean.
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
