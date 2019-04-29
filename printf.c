// printf.c
// compile with: gcc printf.c or gcc -g printf.c (debug)
// to execute:   ./a.out

#include <stdio.h>      // declaration of printf
#include <stdlib.h>     // declaration of getenv, definition of EXIT_SUCCESS

int main(void)
{
    const  char* env = getenv("HOME");
    printf("The contents of the HOME environment variable are %s.\n", env);
    return EXIT_SUCCESS;
}
   
