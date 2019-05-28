// minmax.c
// John Schwartzman, Forte Systems, Inc.
// 05/14/2019
// x86_64
// to execute:  ./a.out  arg1 arg2 (standalone C program)
//              ./minmax arg1 arg2 (C with assembly)

#include <stdlib.h>     // dec of atol; def of EXIT_SUCCESS, EXIT_FAILURE
#include <stdio.h>      // declaration of printf

#ifdef c_version    // if c_version is defined we implement these macros and functions

    #define max(a, b) ((a) > (b) ? (a) : (b))   // C macro
    #define min(a, b) ((a) < (b) ? (a) : (b))   // C macro
    
    long printMax(long a, long b)       // implement c function printMax
    {
        printf("\nmax(%ld, %ld) = %ld\n\n", a, b, max(a, b));
    }

    long printMin(long a, long b)       // implement c function printMin
    {
        printf("\nmin(%ld, %ld) = %ld\n\n", a, b, min(a, b));
    }

#else   // if c_version is not defined we declare these external functions

    long printMax(long a, long b);      // declare external function printMax
    long printMin(long a, long b);      // declare external function printMin

#endif    

int main(int argc, char* argv[])
{
    if (argc == 3)  // get arguments from command line and make them longs
    {
        long a = atol(argv[1]);
        long b = atol(argv[2]);
        printMax(a, b);
        printMin(a, b);
        return EXIT_SUCCESS;
    }
    else
    {
        printf("USAGE: Please enter 2 long integers on the command line"
               " following the program name.\n\n");
        return EXIT_FAILURE;
    }
}
   