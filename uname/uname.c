// uname.c
// compile with: gcc uname.c or gcc -g uname.c (debug)
// to execute:   ./a.out

#include <stdio.h>	        // declaration of printf, perror
#include <stdlib.h>         // defines EXIT_SUCCESS, EXIT_FAILURE
#include <sys/utsname.h>    // declaration of uname, utsname

int main(void)
{
    struct utsname buffer;
    
    int retValue = uname(&buffer);
 
    if (retValue != 0)
    {
        perror("uname");
        exit(EXIT_FAILURE);
    }
    
    printf("\n");
    printf("OS name:   %s\n",   buffer.sysname);
    printf("node name: %s\n",   buffer.nodename);
    printf("release:   %s\n",   buffer.release);
    printf("version:   %s\n",   buffer.version);
    printf("machine:   %s\n\n", buffer.machine);
     return EXIT_SUCCESS;
}
   