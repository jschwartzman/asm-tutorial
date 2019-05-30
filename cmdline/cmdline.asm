;============================================================================
; cmdline.asm - retrieve cmdline info from the OS and print it
; John Schwartzman, Forte Systems, Inc.
; 05/29/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o cmdline.obj cmdline.asm
; gcc -g cmdline.obj -o cmdline
;============================ CONSTANT DEFINITIONS ==========================
LF              equ		10			; ASCII linefeed char
EOL             equ		 0			; end of line
TAB				equ		 9			; ASCII tab char
ARG_SIZE		equ		 8			; size of argv vector
;============================== CODE SECTION ================================
section	.text
global	main						; gcc linker expects main, not _start
extern printf						; tell assembler about external reference

main:								; program starts here
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame
	sub		rsp, 8					; want rsp 16-bit aligned after 3 pushes

	push	r12						; main is just like any other callee
	push	r13						; we have to save
	push	rbx						; callee-saved registers

	mov		r12, rdi				; r12 = argc 	   - save argc
	mov		r13, rsi				; [r13] => argv[0] - save argv addr vector
									
	call	printNewLine

	lea		rdi, [formatc]			; 1st arg to printf - formatc string
	mov		rsi, r12				; 2nd arg to printf - argc
	call	print					; printf argc

	xor		rbx, rbx				; rbx = index var i = 0
	
getArgvLoop:
	lea		rdi, [formatv]			; 1st arg to printf - formatv string
	mov		rsi, rbx				; 2nd arg to printf - index i
	mov		rdx, [r13+rbx*ARG_SIZE]	; 3rd arg to printf - rdx => argv[i]
	call	print					; print argv[i]

	inc		rbx						; i++
	cmp		rbx, r12				; i == argc?
	jl		getArgvLoop				; jump if no - print more argv[]

	call	printNewLine
	xor		rax, rax				; EXIT_SUCCESS - fall through to finish

finish:								; ==== this is the end of the program ===
	pop		rbx						; restore callee-saved registers
	pop		r13
	pop		r12
	
	leave							; undo 1st 2 instructions
	ret								; return from main with retCode in rax
;============================== LOCAL METHODS ===============================
printNewLine:						; local method (alt entry to print)
	lea		rdi, [newLine]			; fall through to print

print:								; rdi, rsi and rdx are args to printf
	xor		rax, rax				; no floating point args to printf
	call	printf
	ret
;=========================== READ-ONLY DATA SECTION =========================
section		.rodata
formatc		db  "argc    = %d",  LF, EOL
formatv		db 	"argv[%d] = %s", LF, EOL
newLine		db	LF, EOL
;============================================================================
