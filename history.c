// history.c
// compile with: gcc history.c or gcc -g history.c (debug)
// to execute:   ./a.out

#include <stdio.h>	// declare printf
#include <stdlib.h>	// declare getenv
#include <string.h>	// declare strcat
#include <fcntl.h>	// declare open
#include <unistd.h>	// declare read

#define		BUF_SIZE	16384

int main(void)
{
	char* env = getenv("HOME");						// get home env variable
	char* filedir = strcat(env, "/.bash_history");	// append filename to env
	const char* buffer[BUF_SIZE];					// buffer for file read
	
	printf("\n");									// print blank line
	
	int fd = open(filedir, O_RDONLY);				// open file
	int count = read(fd, &buffer, 16384);			// read file
	printf("%s", buffer);							// print file
	int returnCode = close(fd);						// close file
	
	printf("\n");									// print blank line
	return returnCode;
}
   
