; ===========================================================================
; cmdline.asm - retrieve cmdline info from the OS and print it
; John Schwartzman, Forte Systems, Inc.
; 05/02/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o cmdline.obj cmdline.asm
; gcc -g cmdline.obj -o cmdline
; ===========================================================================
LF              equ 10				; define constants - ASCII linefeed char
EOL             equ 0				; end of line
TAB				equ 9				; ASCII tab char
ARG_SIZE		equ 8				; size of argv vector
; ===========================================================================
section	.text						; ============ CODE SECTION =============
global	main						; gcc linker expects main, not _start
extern printf						; tell assembler about external reference

main:								; program starts here
	push	rbp						; establish stack frame
	mov		rbp, rsp				; main has no local variables

	mov		r12, rdi				; r12 = argc 		- save argc
	mov		r13, rsi				; [r13] => argv[0]	- save argv table addr
	xor		rbx, rbx				; rbx = index var = 0
									; NOTE: r12, r13, rbx are callee saved
	call	printNewLine
	
getArgvLoop:
	lea		rdi, [format]			; 1st arg to printf - format string
	mov		rsi, rbx				; 2nd arg to printf - index number
	mov		rdx, [r13+rbx*ARG_SIZE]	; 3rd arg to printf - rdx => argv[index]
	call	print

	inc		rbx						; index++
	cmp		rbx, r12				; index == argc?
	jl		getArgvLoop				; jump if no - print more argv[]

	call	printNewLine
	xor		rax, rax				; EXIT_SUCCESS - fall through to finish

finish:								; ==== this is the end of the program ===
	leave							; restore stack
	ret								; return from main with retCode in rax
; ============================= LOCAL METHODS ===============================
printNewLine:						; local method (alt entry to print)
	lea		rdi, [newLine]			; fall through to printf

print:								; rdi, rsi and rdx are args to printf
	xor		rax, rax				; no floating point args to printf
	call	printf
	ret
; ===========================================================================
section		.rodata					; ======= read-only data section ========
format		db 	"cmd #%d", TAB, "%s", LF, EOL
newLine		db	LF, EOL
; ===========================================================================
