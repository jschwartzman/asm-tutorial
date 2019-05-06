// prntenv.c
// John Schwartzman, Forte Systems, Inc.
// 05/06/2019
// assemble prntenv.asm:  yasm -f elf64 -g dwarf2 -o printf.obj printf.asm
// compile and link:      gcc -g prntenv.c prntenv.obj -o prntenv
// to execute:            ./prntenv

#include <stdlib.h>     // definition of EXIT_SUCCESS
#include <time.h>       // declaration of time; definition of time_t
#include <string.h>     // declaration of strtok

int prntenv(const char* timestr);   // declaration of asm function

int main(void)
{
    time_t  now;

    time(&now);
    char* strTime = strtok(ctime(&now), "\n");  // remove newline from ctime
    
    prntenv(strTime);   // call assembly language function with asciiz param
    return EXIT_SUCCESS;
}
   