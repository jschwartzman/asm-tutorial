// cmdline.c
// John Schwartzman, Forte Systems, Inc.
// 05/06/2019
// x86_64
// compile with: gcc cmdline.c or gcc -g cmdline.c (debug)
// to execute:   ./a.out

#include <stdio.h>		// declares printf
#include <stdlib.h>		// defines EXIT_SUCCESS

int main(int argc, char* argv[])
{
	printf("\n");		// print blank line
	for (int i = 0; i < argc; i++)
	{
		printf("cmd #%d\t%s\n", i, argv[i]);
	}
	printf("\n");		// print blank line
	return EXIT_SUCCESS;
}
