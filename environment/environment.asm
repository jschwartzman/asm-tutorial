;============================================================================
; environment.asm - demonstrates invoking getenv, printf and strncpy 
; environment.asm is called by environment.c (environment.c has main())
; environment.asm does not have a main. It exports the function with the 
; declaration: int printenv(const char* dateStr);
; John Schwartzman, Forte Systems, Inc.
; 06/02/2019
; linux x86_64
; yasm -f elf64 -o environment.obj -l environment.lst environment.asm
; gcc -g environment.c environment.obj -o environment
;============================ CONSTANT DEFINITIONS ==========================
BUFF_SIZE		equ 	128			; number of bytes in buffer
LF				equ 	 10			; ASCII line feed character
EOL   			equ 	  0			; end of line character
TAB				equ 	  9			; ASCII tab character
NUM_PUSH		equ 	  9			; we PUSH 9 addresses for call to printf
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
extern 		getenv, printf, strncpy	; tell assembler/linker about externals
									; this module doesn't have _start or main
;============================= EXPORTED FUNCTION ============================
printenv:							
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack now aligned
	sub		rsp, PUSH_SIZE			; want rsp 16-bit aligned after 1 push
	push	rdi						; save arg on the stack (dateStr)

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
	lea		rdi, [formatString]		;  1st printf arg
	pop		rsi						;  2nd printf arg - pushed rdi, popped rsi
    add     rsp, PUSH_SIZE          ;  correct stack alignment
	lea		rdx, [bufHOME]			;  3rd printf arg
	lea		rcx, [bufHOSTNAME]		;  4th printf arg
	lea		r8,  [bufHOSTTYPE]		;  5th printf arg
	lea		r9,  [bufCPU]			;  6th printf arg
	; we've used all 6 argument passing registers - PUSH remaining args
	; NOTE: PUSHes performed in reverse order because
	; 		args are read from top of stack! The stack grows downward!
	push	bufHISTFILE				; 15th printf arg
	push	bufPS1					; 14th printf arg
	push	bufLANG					; 13th printf arg
	push	bufMAIL					; 12th printf arg
	push	bufEDITOR				; 11th printf arg
	push	bufSHELL				; 10th printf arg
	push	bufPATH					;  9th printf arg
	push	bufTERM					;  8th printf arg
	push	bufPWD					;  7th printf arg

	xor		rax, rax				; no floating point arguments
	call	printf					; invoke the C wrapper function to print
	add		rsp, NUM_PUSH*PUSH_SIZE	; caller must remove items pushed
	xor		rax, rax				; return EXIT_SUCCESS = 0

	leave							; undo 1st 2 instructions
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
