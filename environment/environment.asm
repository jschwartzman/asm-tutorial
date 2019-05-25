;============================================================================
; environment.asm - demonstrates invoking getenv, printf and strncpy 
; in /lib64/libc.so.6
; environment.asm does not have a main. It exports the function with the 
; declaration: int printenv(const char* dateStr);
; John Schwartzman, Forte Systems, Inc.
; 05/19/2019
; linux x86_64
; yasm -f elf64 -o environment.obj -l environment.lst environment.asm
; gcc environment.c environment.obj -o environment
;============================ CONSTANT DEFINITIONS ==========================
BUFF_SIZE		equ 	128			; number of bytes in buffer
LF				equ 	 10			; ASCII line feed character
EOL   			equ 	  0			; end of line character
TAB				equ 	  9			; ASCII tab character
NUM_PUSH		equ 	  9			; we PUSH 9 addresses to call printf
PUSH_SIZE		equ 	  8			; each PUSH subtracts 8 bytes from RSP
ZERO			equ		  0			; the number 0
;============================= MACRO DEFINITION =============================
%macro getSaveEnv	1				;===== getSaveEnv macro takes 1 arg =====
	lea		rdi, [env%1]			; env%1 = ASCIIZ env var name
	call	getenv					; getenv will return with [RAX] => ASCIIZ
	lea 	rdi, [buf%1]			; buf%1 = env var dest- 1st arg to strncpy
	mov		rsi, rax				; [rsi] => ASCIIZ src - 2nd arg to strncpy
	mov		rdx, BUFF_SIZE - 1		; rdx = max # to copy - 3rd arg to strncpy
	lea		rcx, [nullLine]			; [rcx] => "(null)"
	cmp		rax, ZERO				; did we get an invalid value (rax == 0)?
	cmovz	rsi, rcx				; if invalid, strncpy "(null)"
	call	strncpy					; call C library function to save env var
%endmacro							;======== end of getSaveEnv macro =======
;============================== CODE SECTION ================================
section		.text					;============= CODE SECTION =============
global 		printenv				; tell gcc linker we're exporting prntenv
extern 		getenv, printf, strncpy	; tell assembler about externals
									; this module doesn't have _start or main
;============================= EXPORTED FUNCTION ============================
printenv:							
	push	rdi						; save parameter on the stack (dateStr)

	; get and save environment variables by using macro for each env var
	getSaveEnv HOME
	getSaveEnv HOSTNAME
	getSaveEnv HOSTTYPE
	getSaveEnv CPU
	getSaveEnv PWD
	getSaveEnv TERM
	getSaveEnv PATH
	getSaveEnv SHELL
	getSaveEnv EDITOR
	getSaveEnv MAIL
	getSaveEnv LANG
	getSaveEnv PS1
	getSaveEnv HISTFILE

	; call printf with many, many arguments
	; pass args in RDI, RSI, RDX, RCX, R8 and R9 with remaining args on stack
	lea		rdi, [formatString]		;  1st printf arg -  1st read by printf
	pop		rsi						;  2nd printf arg -  2nd read by printf
	lea		rdx, [bufHOME]			;  3rd printf arg -  3rd read by printf
	lea		rcx, [bufHOSTNAME]		;  4th printf arg -  4th read by printf
	lea		r8,  [bufHOSTTYPE]		;  5th printf arg -  5th read by printf
	lea		r9,  [bufCPU]			;  6th printf arg -  6th read by printf
	; we've used all 6 argument passing registers - PUSH remaining args
	; NOTE: PUSHes performed in reverse order because
	; 		args are read from top of stack! The stack grows downward!
	push	bufHISTFILE				; 15th printf arg - 15th read by printf
	push	bufPS1					; 14th printf arg - 14th read by printf
	push	bufLANG					; 13th printf arg - 13th read by printf
	push	bufMAIL					; 12th printf arg - 12th read by printf
	push	bufEDITOR				; 11th printf arg - 11th read by printf
	push	bufSHELL				; 10th printf arg - 10th read by printf
	push	bufPATH					;  9th printf arg -  9th read by printf
	push	bufTERM					;  8th printf arg -  8th read by printf
	push	bufPWD					;  7th printf arg -  7th read by printf

	xor		rax, rax				; no floating point arguments
	call	printf					; invoke the C wrapper function to print
	add		rsp, NUM_PUSH*PUSH_SIZE	; we must remove items pushed on stack

	xor		rax, rax				; return EXIT_SUCCESS = 0	
	ret								; return to caller
;========================= READ-ONLY DATA SECTION ===========================
section		.rodata
formatString	db LF,  "Environment Variables on %s:",	LF
				db TAB, "HOME     = %s",				LF
				db TAB, "HOSTNAME = %s", 				LF
				db TAB, "HOSTTYPE = %s",				LF
				db TAB, "CPU      = %s",				LF
				db TAB, "PWD      = %s",				LF
				db TAB, "TERM     = %s",				LF
				db TAB, "PATH     = %s",				LF
				db TAB, "SHELL    = %s",				LF
				db TAB, "EDITOR   = %s",				LF
				db TAB, "MAIL     = %s",				LF, 
				db TAB, "LANG     = %s",				LF,
				db TAB, "PS1      = %s",				LF,
				db TAB, "HISTFILE = %s",				LF, LF, EOL

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
envLANG			db "LANG",		EOL
envPS1			db "PS1",		EOL
envHISTFILE		db "HISTFILE",	EOL

nullLine		db "(null)",	EOL
newLine			db	LF, EOL
;========================== UNINITIALIZED DATA SECTION ======================
section		.bss
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
bufLANG			resb	BUFF_SIZE
bufPS1			resb	BUFF_SIZE
bufHISTFILE		resb	BUFF_SIZE
;============================================================================
