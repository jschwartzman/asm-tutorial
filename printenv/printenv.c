// printenv.c
// John Schwartzman, Forte Systems, Inc.
// 05/17/2019
// x86_64
// compile with: gcc printenv.c or gcc -g printenv.c (debug)
// to execute:   ./a.out

#include <stdio.h>      // declaration of printf
#include <stdlib.h>     // declaration of getenv, definition of EXIT_SUCCESS

int main(void)
{
    // get some bufironment variables
    const char* bufHOME     = getenv("HOME");
    const char* bufHOSTNAME = getenv("HOSTNAME");
    const char* bufHOSTTYPE = getenv("HOSTTYPE");
    const char* bufCPU      = getenv("CPU");
    const char* bufPWD      = getenv("PWD");
    const char* bufTERM     = getenv("TERM");
    const char* bufPATH     = getenv("PATH");
    const char* bufSHELL    = getenv("SHELL");
    const char* bufEDITOR   = getenv("EDITOR");
    const char* bufMAIL     = getenv("MAIL");
    const char* bufLANG     = getenv("LANG");
    const char* bufPS1      = getenv("PS1");
    const char* bufHISTFILE = getenv("HISTFILE");

    // print the bufironment variables and their names
    printf("\nEnvironment Variables:\n"
           "\tHOME     = %s\n"
           "\tHOSTNAME = %s\n"
           "\tHOSTTYPE = %s\n"
           "\tCPU      = %s\n"
           "\tPWD      = %s\n"
           "\tTERM     = %s\n"
           "\tPATH     = %s\n"
           "\tSHELL    = %s\n"
           "\tEDITOR   = %s\n"
           "\tMAIL     = %s\n"
           "\tLANG     = %s\n"
           "\tPS1      = %s\n"
           "\tHISTFILE = %s\n\n",
           bufHOME, bufHOSTNAME, bufHOSTTYPE, bufCPU, bufPWD,
           bufTERM, bufPATH, bufSHELL, bufEDITOR, bufMAIL, 
           bufLANG, bufPS1, bufHISTFILE);

    return EXIT_SUCCESS;
}
   