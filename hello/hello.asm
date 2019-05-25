;============================================================================
; hello.asm
; John Schwartzman, Forte Systems, Inc.
; 05/24/2019
; yasm -g dwarf2 -f elf64 hello.asm -o hello.obj
; ld -g -o hello hello.obf
;============================= CONSTANT DEFINITIONS =========================
LF        		equ		10			; ASCII linefeed character
EXIT_SUCCESS	equ  	 0			; Linux apps normally return 0 to indicate success
STDOUT			equ  	 1			; destination for SYS_WRITE
SYS_WRITE		equ  	 1			; kernel SYS_WRITE service number
SYS_EXIT		equ 	60			; kernel SYS_EXIT service number
;================================ CODE SECTION ==============================
section	.text
global 	_start

_start:
	mov		rax, SYS_WRITE			; prepare to call SYS_WRITE 
	mov		rdi, STDOUT				; 1st arg to SYS_WRITE
	lea		rsi, [msg]				; 2nd arg to SYS_WRITE - [rsi] => ASCII
	mov		rdx, msglen				; 3rd arg to SYS_WRITE - rdx = number char
	syscall							; invoke Linux kernel SYS_WRITE service
    
	mov 	rax, SYS_EXIT			; prepare to call SYS_EXIT
	xor 	rdi, rdi				; 1st arg to SYS_EXIT - rdi = EXIT_SUCCESS
	syscall							; invoke Linux kernel SYS_EXIT service
;========================== READ-ONLY DATA SECTION ==========================
section 		.rodata
    msg: 		db 		"Hello, world!", LF, LF
    msglen: 	equ 	$ - msg
;============================================================================
