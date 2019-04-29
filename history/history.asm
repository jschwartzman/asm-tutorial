; ===========================================================================
; history.asm - determines ~/ and displays the contents of ~/.bash_history
; John Schwartzman, Forte Systems, Inc.
; 04/28/2019
; linux x86_64
; yasm -f elf64 -g DWARF2 -o history.obj history.asm
; gcc -l history.obj -o history
; ===========================================================================
LF              equ 10				; define constants
EOL             equ 0
O_RDONLY        equ 000000q
BUFF_SIZE       equ 2048
USER_DIR_SIZE   equ 255
ZERO			equ	0
; ===========================================================================
section	.text						; ============ CODE SECTION =============
global main

extern getenv, printf	 			; tell assembler about external references
extern open, read, close

main:
	push	rbp						; establish stack frame
	mov		rbp, rsp				; main has no local variables
	
	call	printNewLine			; call local function

	lea		rdi, [envVariable]		; getenv expects [rdi] => asciiz env var name
	call  	getenv					; on return [rax] => asciiz returned by getenv

	cmp		rax, ZERO          		; success?
	jl		errorOnGetEnv       	; jump if no

 	lea		rdi, [fileDir]			; [rdi] => where to move returned data
	call	copyString				; [rax] => value returned by getenv()
									; copy string leaves [rdi] => EOS
	lea		rax, [filename]     	; copy filename to end of fileDir
	call  	copyString				; invoke local function

	lea   	rdi, [fileDir]	      	; prepare to open file
	mov   	rsi, O_RDONLY
	call  	open					; invoke C wrapper function

	cmp		eax, ZERO              	; success? (this has to be eax, not rax)
	jl    	errorOnOpen           	; jump if no

	mov		[fd], eax	 			; save file descriptor (it's a 32-bit int)

readFile:							; =========== local function ============
	mov		edi, [fd]				; rdi = file descriptor
	lea   	rsi, [readBuffer]		; [rsi] => read location
	mov   	rdx, BUFF_SIZE			; rdx = num bytes to read
	call  	read	                ; invoke C wrapper function

	cmp		rax, ZERO	            ; success?
	jl		errorOnRead				; jump if no
	je		closeFile             	; we've reached EOF
				
	mov   	rdi, readBuffer			; print the buffer - rax = num bytes read
	mov   	byte [rdi + rax], EOL 	; add EOL to buffer so that we can printf
	call  	printString				; invoke local function
	jmp		readFile				; we haven't reached EOF, read some more

closeFile:							; close the open file
	mov   	rdi, [fd]				; put file descriptor in rdi
	call  	close	            	; invoke C wrapper function
	jmp   	finish					; and get out

errorOnGetEnv:                      ; rax contains error code
	push	rax						; save error code
	mov   	rdi, errMsgGetEnv		; [rdi] => ascii to print
	call  	printString				; invoke local function
	pop		rax						; recover error code
	jmp   	finish					; and get out

errorOnOpen:                        ; rax contains error code
	push	rax						; save error code
	lea   	rdi, [errMsgOpen]		; printf expects [rdi] => asciiz msg
	lea		rsi, [fileDir]			; printf expects [rsi] => asciiz arg
	call	printString
	pop		rax		 				; recover error code
	jmp		finish					; and get out

errorOnRead:						; rax contains error code
	push	rax	                  	; save error code
	lea   	rdi, [errMsgRead]		; printf expects [rdi] => asciiz msg
	lea		rsi, [fileDir]			; printf expects [rsi] => asciiz arg
	call  	printString
	pop   	rax                   	; recover error code
	jmp   	closeFile				; and get out

printString:                        ; === local function - [rdi] => asciiz ==
	xor		rax, rax				; no floating point arguments to print
	call	printf					; call C wrapper function - [rdi] => asciiz
	ret                           	; ===== end of printString function =====

copyString:                         ; ============ local function ===========
	mov     bl, [rax]             	; [rdi] => destination - [rax] => source
	mov     byte [rdi], bl
	cmp     bl, EOL					; EOL?
	je      endOfCopyString			; jump if yes
    
	inc     rdi						; increment destination
	inc     rax						; increment source
	jmp     copyString				; keep copying

endOfCopyString:                    ; [rdi] => end of string
	ret                           	; ===== end of copyString function ======
    
printNewLine:						; ============ local function ===========
	lea		rdi, [newLine]			; [rdi] => asciiz to print
	xor		rax, rax				; no floating point arguments to print
	call	printf					; call C wrapper function
	ret								; ==== end of printNewLine function =====

finish:								; ==== this is the end of the program ===
	push	rax						; save exit status (it's a 32-bit int)
	call 	printNewLine
	pop		rax						; recover exit status (EXIT_SUCCESS = 0)
	leave    
	ret                           	; return from main (exit program)
; ===========================================================================
section		.data					; ======= initialized data section ======
fd	    	dd 0					; file descriptor (doubleword = 32-bit int)
; ===========================================================================
section     .rodata					; == initialized read-only data section =
filename        db "/.bash_history", EOL
errMsgGetEnv	db "Error getting the $HOME environment variable.", LF, EOL
errMsgOpen		db "Error opening the file %s.", LF, EOL
errMsgRead		db "Error reading from the file %s.", LF, EOL
envVariable		db "HOME", EOL
newLine			db LF, EOL
; ===========================================================================
section     .bss					; ===== uninitialized data section ======
readBuffer  resb    BUFF_SIZE + 1	; buf for file read (add place for EOL)
fileDir     resb    USER_DIR_SIZE	; buf for getenv return value
; ===========================================================================
