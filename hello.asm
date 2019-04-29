; ===========================================================================
; hello.asm
; John Schwartzman, Forte Systems, Inc.
; 04/28/2019
; yasm -g dwarf2 -f elf64 hello.asm -o hello.obj
; ld -g -o hello hello.obf
; ===========================================================================
LF        		equ 10				; define constants
EXIT_SUCCESS	equ 0
STDOUT			equ 1
SYS_EXIT		equ 60
SYS_WRITE		equ 1
; ===========================================================================
section	.text						; ============ CODE SECTION =============
global 	_start

_start:
	mov		rax, SYS_WRITE			; prepare to call SYS_WRITE 
	mov		rdi, STDOUT				; we'll be writing to the console
	mov		rsi, msg				; [rsi] => ascii to write
	mov		rdx, msglen				; rdx = number of char to write
	syscall							; call the Linux kernel to wrte
    
	mov 	rax, SYS_EXIT			; prepare to call SYS_EXIT
	xor 	rdi, rdi				; rdi = EXIT_SUCCESS =  0 (-1 = failure)
	syscall							; call the Linux kernel to exit
; ===========================================================================
section .rodata					; == READ-ONLY DATA SECTION =======
    msg: 	db "Hello, world!", LF, LF
    msglen: equ $ - msg
; ===========================================================================
