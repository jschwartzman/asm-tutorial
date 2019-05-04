; ===========================================================================
; history.asm - determines ~/ and displays the contents of ~/.bash_history
; John Schwartzman, Forte Systems, Inc.
; 05/02/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o history.obj history.asm
; gcc -g history.obj -o history
; ===========================================================================
ZERO			equ	0				; define constants
EOL             equ 0				; end of line char
LF              equ 10				; ASCII linefeed char
O_RDONLY        equ 000000q			; read flags
BUFF_SIZE       equ	1024			; size of file read
USER_DIR_SIZE   equ 256				; size of file directory + filename
; ===========================================================================
section	.text						; ============ CODE SECTION =============
global main

extern getenv, printf, strncpy		; tell assembler about external references
extern strncat, open, read, close

main:								; start of program
	push	rbp						; establish stack frame
	mov		rbp, rsp				; main has no local variables
	
	call	printNewLine			; call local method

	; get env var "HOME"
	lea		rdi, [envVarHOME]		; getenv expects [rdi] => asciiz env var name
	call  	getenv					; on return [rax] => asciiz returned by getenv
	cmp		rax, ZERO          		; success?
	jz		errorOnGetEnv       	; jump if no

	; save env var "HOME"
 	lea		rdi, [fileDir]			; [rdi] => where to move returned data
	mov		rsi, rax				; [rsi] = return value from getenv
	mov		rdx, USER_DIR_SIZE/2	; rdx = max num char to copy
	call	strncpy					; copy HOME env var to fileDir

	; concatenate file directory and filename
	lea		rdi, [fileDir]			; [rdi] => destination for strncat
	lea		rsi, [filename]			; [rsi] => source for strncat
	mov		rdx, USER_DIR_SIZE/2	; rdx = max num char to copy
	call	strncat					; concatenate the $HOME dir and filename

	; open the .bash_history file
	lea   	rdi, [fileDir]	      	; prepare to open file - 1st arg to open
	mov		esi, O_RDONLY			; 2nd arg to open
	call  	open					; open the file
	cmp		eax, ZERO              	; success? (this has to be eax, not rax)
	jle    	errorOnOpen           	; jump if return value is negative or zero
	mov		[fd], eax	 			; save file descriptor (it's a 32-bit int)

readFile:							; =========== local method ============
	mov		edi, [fd]				; edi = file descriptor	 - 1st arg to read
	lea   	rsi, [readBuffer]		; [rsi] => read location - 2nd arg to read
	mov   	rdx, BUFF_SIZE - 1		; rdx = num bytes to read- 3rd arg to read
	call  	read	                ; invoke C 
	cmp		rax, ZERO	            ; rax = value returned from read
	jl		errorOnRead				; jump if negative
	je		closeFile             	; or we've reached EOF
									; else print the file contents so far
	mov   	rdi, readBuffer			; print the buffer - rax = num bytes read
	mov   	byte [rdi + rax], EOL 	; add EOL to buffer so we can call printf
	call  	print					; invoke print
	jmp		readFile				; we haven't reached EOF, read some more

closeFile:							; close the open file
	mov   	edi, [fd]				; put file descriptor in rdi - only arg
	call  	close	            	; invoke C
	call	printNewLine
	jmp   	finish					; get out - eax = 0 (success), -1 (failure)

errorOnGetEnv:                      ; rax contains error code
	mov   	rdi, errMsgGetEnv		; [rdi] => ascii to print
	mov		rax, 127				; error code for no env var HOME
	call  	print					; invoke local method
	jmp   	finish					; and get out

errorOnOpen:                        ; rax contains error code
	push	rax						; save error code
	lea   	rdi, [errMsgOpen]		; printf expects [rdi] => asciiz msg
	call	print					; invoke local method
	jmp		finish					; and get out

errorOnRead:						; rax contains error code
	lea   	rdi, [errMsgRead]		; printf expects [rdi] => asciiz msg
	call  	print					; invoke local method
	jmp   	closeFile				; and get out

finish:								; ==== this is the end of the program ===
	leave    
	ret                           	; return from main (exit program)
; ============================== LOCAL METHODS ==============================
printNewLine:						; local method (alt entry to print)
	lea		rdi, [newLine]			; fall through to print

print:								; local method - expects [rdi] => asciiz
	mov		r12, rax				; save possible error code
	xor		rax, rax				; no floating point args to printf
	call	printf
	mov		rax, r12				; retrieve possible error code
	ret
; ===========================================================================
section		.data					; ======= initialized data section ======
fd	    		dd	0				; file descriptor (doubleword = 32-bit int)
; ===========================================================================
section     .rodata					; == initialized read-only data section =
filename        db "/.bash_history", EOL
errMsgGetEnv	db "Error getting the $HOME environment variable.", LF, EOL
errMsgOpen		db "Error opening the file %s.", LF, EOL
errMsgRead		db "Error reading from the file %s.", LF, EOL
envVarHOME		db "HOME", EOL
newLine			db LF, EOL
; ===========================================================================
section     .bss					; ===== uninitialized data section ======
readBuffer  resb    BUFF_SIZE + 1	; buf for file read (add place for EOL)
fileDir     resb    USER_DIR_SIZE	; buf for getenv return value
; ===========================================================================
