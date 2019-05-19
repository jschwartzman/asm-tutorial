// history.c
// John Schwartzman, Forte Systems, Inc.
// 05/06/2019
// x86_64
// compile with: gcc history.c or gcc -g history.c (debug)
// to execute:   ./a.out

#include <stdio.h>	// declare printf
#include <stdlib.h>	// declare getenv
#include <string.h>	// declare strcat
#include <fcntl.h>	// declare open
#include <unistd.h>	// declare read

#define		BUF_SIZE	4096
#define		EOL			0

int main(void)
{
	char* env = getenv("HOME");						// get home env variable
	char* filedir = strcat(env, "/.bash_history");	// append filename to env
	const char* buffer[BUF_SIZE];					// buffer for file read
	
	printf("\n");									// print blank line
	int fd = open(filedir, O_RDONLY);				// open file
	int count;

	do
	{
		count = read(fd, &buffer, BUF_SIZE - 1);	// read file
		buffer[count] = EOL;						// write EOL at end
		printf("%s", buffer);						// print file
	} 
	while (count > 0);
		
	int returnCode = close(fd);						// close file
	
	printf("\n\n");									// print blank line
	return returnCode;
}
   