// printenv.c
// compile with: gcc printenv.c or gcc -g printenv.c (debug)
// to execute:   ./a.out

#include <stdio.h>      // declaration of printf
#include <stdlib.h>     // declaration of getenv, definition of EXIT_SUCCESS

int main(void)
{
    // get some environment variables
    const char* envHOME     = getenv("HOME");
    const char* envHOSTNAME = getenv("HOSTNAME");
    const char* envHOSTTYPE = getenv("HOSTTYPE");
    const char* envCPU      = getenv("CPU");
    const char* envPWD      = getenv("PWD");
    const char* envTERM     = getenv("TERM");
    const char* envPATH     = getenv("PATH");
    const char* envSHELL    = getenv("SHELL");
    const char* envEDITOR   = getenv("EDITOR");
    const char* envMAIL     = getenv("MAIL");

    // print the environment variables and their names
    printf("\n"
           "Environment Variables:\n"
           "\tHOME     = %s\n"
           "\tHOSTNAME = %s\n"
           "\tHOSTTYPE = %s\n"
           "\tCPU      = %s\n"
           "\tPWD      = %s\n"
           "\tTERM     = %s\n"
           "\tPATH     = %s\n"
           "\tSHELL    = %s\n"
           "\tEDITOR   = %s\n"
           "\tMAIL     = %s\n\n",
           envHOME, envHOSTNAME, envHOSTTYPE, envCPU,
           envPWD, envTERM, envPATH, envSHELL,
           envEDITOR, envMAIL);

    return EXIT_SUCCESS;
}
   