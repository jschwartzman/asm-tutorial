; ===========================================================================
; cmdline.asm - retrieve cmdline info from the OS and print it
; John Schwartzman, Forte Systems, Inc.
; 04/28/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o cmdline.obj cmdline.asm
; gcc -g cmdline.obj -o cmdline
; ===========================================================================
LF              equ 10				; define constants
EOL             equ 0
TAB				equ 9
ARG_SIZE		equ 8
; ===========================================================================
section	.text						; ============ CODE SECTION =============
global	main						; gcc linker expects main, not _start

extern printf						; tell assembler about external reference

main:
	push	rbp						; establish stack frame
	mov		rbp, rsp				; main has no local variables

	mov		r12, rdi				; r12 = argc
	mov		r13, rsi				; [r13] => argv[0]
	xor		rbx, rbx				; rbx = index var = 0

	call	printBlankLine

printLoop:
	lea		rdi, [format]			; 1st arg to printf
	mov		rsi, rbx				; 2nd arg to printf
	mov		rdx, [r13+rbx*ARG_SIZE]	; 3rd arg to printf
	xor		rax, rax				; no floating point args
	call	printf

	inc		rbx						; index++
	cmp		rbx, r12				; iindex == (last arg + 1)?
	jl		printLoop				; jump if no

	call	printBlankLine

	xor		rax, rax				; indicate EXIT_SUCCESS
	jmp		finish
	
printBlankLine:						; ============ local function ===========
	lea		rdi, [newLine]			; print an empty line
	xor		rax, rax				; no floating point to print
	call	printf					; call C wrapper function
	ret								; ==== end of printBlankLine function ===

finish:
	leave							; restore stack
	ret								; return from main with retCode in rax
; ===========================================================================
section		.rodata					; ======= read-only data section ========
format		db 	"cmd #%d", TAB, "%s", LF, EOL
newLine		db	LF, EOL
; ===========================================================================
