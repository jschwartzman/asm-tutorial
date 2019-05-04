; ===========================================================================
; printenv.asm - demonstrates invoking getenv and printf in /lib64/libc.so.6
; John Schwartzman, Forte Systems, Inc.
; 05/02/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o printf.obj printf.asm
; gcc -g printf.obj -o printf
; ===========================================================================
BUFF_SIZE		equ 	128			; define some constants
LF				equ 	10			; ASCII line feed character
EOL   			equ 	0			; end of line character
TAB				equ 	9			; ASCII tab character
NUM_PUSH		equ 	5			; we PUSH 5 addresses to call printf
PUSH_SIZE		equ 	8			; each PUSH subtracts 8 bytes from RSP
; ===========================================================================
%macro getSaveEnv	2				; ==== getSaveEnv macro takes 2 args ====
	lea		rdi, [%1]				; %1 is asciiz environment variable name
	call	getenv					; getenv will return with [RAX] => asciiz
	lea 	rdi, [%2]				; %2 is env var dest  - 1st arg to strncpy
	mov		rsi, rax				; [rsi] => asciiz src - 2nd arg to strncpy
	mov		rdx, BUFF_SIZE - 1		; rdx = max # to copy - 3rd arg to strncpy
	call	strncpy					; call C library function to save env var
%endmacro							; ======== end of getSaveEnv macro ======
; ===========================================================================
section		.text					; ============ CODE SECTION =============
global 		main					; gcc linker expects main, not _start
extern 		getenv, printf, strncpy	; tell assembler about externals

main:
	push	rbp						; establish stack frame
	mov		rbp, rsp				; main has no local variables

	; get and save environment variables by using macro for each variable
	getSaveEnv	envHOME, 	 bufHOME
	getSaveEnv 	envHOSTNAME, bufHOSTNAME
	getSaveEnv	envHOSTTYPE, bufHOSTTYPE
	getSaveEnv	envCPU, 	 bufCPU
	getSaveEnv	envPWD, 	 bufPWD
	getSaveEnv	envTERM,	 bufTERM
	getSaveEnv	envPATH,	 bufPATH
	getSaveEnv	envSHELL,	 bufSHELL
	getSaveEnv	envEDITOR,	 bufEDITOR
	getSaveEnv	envMAIL, 	 bufMAIL

	; call printf with many, many arguments
	; pass args in RDI, RSI, RDX, RCX, R8 and R9 with remaining args on stack
	lea		rdi, [formatString]		;  1st printf arg  - 1st read by printf
	lea		rsi, [bufHOME]			;  2nd printf arg  - 2nd read by printf
	lea		rdx, [bufHOSTNAME]		;  3rd printf arg  - 3rd read by printf
	lea		rcx, [bufHOSTTYPE]		;  4th printf arg  - 4th read by printf
	lea		r8,  [bufCPU]			;  5th printf arg  - 5th read by printf
	lea		r9,  [bufPWD]			;  6th printf arg  - 6th read by printf
	; we've used all 6 argument passing registers - PUSH remaining args
	; NOTE: PUSHes performed in reverse order because
	; 		args are read from top of stack! The stack grows downward!
	push	bufMAIL					; 11th printf arg  - 11th read by printf
	push	bufEDITOR				; 10th printf arg  - 10th read by printf
	push	bufSHELL				;  9th printf  arg -  9th read by printf
	push	bufPATH					;  8th printf  arg -  8th read by printf
	push	bufTERM					;  7th printf  arg -  7th read by printf

	xor		rax, rax				; no floating point arguments
	call	printf					; invoke the C wrapper function to print
	add		rsp, NUM_PUSH*PUSH_SIZE	; we must remove items pushed on stack

	xor		rax, rax				; we're finished!  rax = EXIT_SUCCESS = 0

finish:
	leave							; restore stack
	ret								; return from main with exit code in rax
; ===========================================================================
section		.rodata					; ======= read-only data section ========
formatString	db LF,  "Environment Variables:",	LF
				db TAB, "HOME     = %s",			LF
				db TAB, "HOSTNAME = %s", 			LF
				db TAB, "HOSTTYPE = %s",			LF
				db TAB, "CPU      = %s",			LF
				db TAB, "PWD      = %s",			LF
				db TAB, "TERM     = %s",			LF
				db TAB, "PATH     = %s",			LF
				db TAB, "SHELL    = %s",			LF
				db TAB, "EDITOR   = %s",			LF
				db TAB, "MAIL     = %s",			LF, LF, EOL

envHOME			db "HOME", 		EOL
envHOSTNAME		db "HOSTNAME", 	EOL
envHOSTTYPE		db "HOSTTYPE", 	EOL
envCPU			db "CPU", 		EOL
envPWD			db "PWD", 		EOL
envTERM			db "TERM", 		EOL
envPATH			db "PATH", 		EOL
envSHELL		db "SHELL", 	EOL
envEDITOR		db "EDITOR",	EOL
envMAIL			db "MAIL",		EOL

newLine			db	LF, EOL
; ===========================================================================
section		.bss					; === uninitialized data section ========
bufHOME			resb	BUFF_SIZE
bufHOSTNAME		resb	BUFF_SIZE
bufHOSTTYPE		resb	BUFF_SIZE
bufCPU			resb	BUFF_SIZE
bufPWD			resb	BUFF_SIZE
bufTERM			resb	BUFF_SIZE
bufPATH			resb	BUFF_SIZE
bufSHELL		resb	BUFF_SIZE
bufEDITOR		resb	BUFF_SIZE
bufMAIL			resb	BUFF_SIZE
; ===========================================================================
