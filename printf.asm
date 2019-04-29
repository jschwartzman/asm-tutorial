; ===========================================================================
; printf.asm - tests invoking getenv() and printf() in /lib64/libc.so.6
; John Schwartzman, Forte Systems, Inc.
; 04/28/2019
; linux x86_64
; yasm -f elf64 -g DWARF2 -o printf.obj printf.asm
; gcc printf.obj -o printf
; ===========================================================================
BUFF_SIZE		equ 255				; define some constants
LF				equ 10
EOL   			equ 0
ZERO			equ 0
; ===========================================================================
section		.text					; ============ CODE SECTION =============
global 		main					; gcc linker expects main, not _start

extern getenv, printf				; tell assembler about external ref

main:
	push	rbp						; establish stack frame
	mov		rbp, rsp				; main has no local variables

	lea		rdi, [envVariable]		; getenv expects [rdi] => asciiz env var name
	call	getenv					; invoke C wrapper function, [rax] => asciiz
	cmp		rax, ZERO		    	; success?
	jl		getEnvError				; jump if no

	lea		rdi, [readBuffer]		; [rdi] => where to move returned data
	call	copyString				; [rax] => value returned by getenv()
	lea		rdi, [msg]				; printf expects [rdi] => asciiz msg to print
	lea		rsi, [readBuffer]		; printf expects [rsi] => asciiz printf arg
	xor		rax, rax				; no floating point arguments
	call	printf					; invoke the C wrapper function to print
	cmp		rax, ZERO				; success?
	jl		getPrintfError			; jump if no
	
	xor		rax, rax				; we're finished!  rax = EXIT_SUCCESS = 0
	jmp		finish

getEnvError:
	jmp		finish					; we're not processing this error; just quit

getPrintfError:
	jmp		finish					; we're not processing this error; just quit

copyString:							; ============= local function ==========
									; copy asciiz <= [rax] to memory <= [rdi]
	mov		bl, [rax]				; copy a byte into bl
	mov		[rdi], bl				; move the byte into buffer pointed to by rdi
	inc		rax						; point to the next source byte
	inc		rdi						; point to the next destination byte
	cmp		bl, EOL					; EOL?
	jne		copyString				; jump if no
	ret								; return from copyString

printNewLine:						; ============ local function ===========
	lea		rdi, [newLine]			; print an empty line
	xor		rax, rax				; no floating point to print
	call	printf					; call C wrapper function
	ret								; ===== end of printNewLine function ====

finish:
	push	rax						; save exit status
	call 	printNewLine
	pop		rax						; restore exit status
	leave							; restore stack
	ret								; return from main with return code in rax
; ===========================================================================
section		.rodata					; ======= read-only data section ========
msg			db 	"The home environment variable is equal to %s.", LF, EOL
envVariable	db	"HOME", EOL
newLine		db	LF, EOL
; ===========================================================================

section		.bss					; === uninitialized data section ========
readBuffer  resb    BUFF_SIZE

; ===========================================================================
