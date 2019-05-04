; ===========================================================================
; uname.asm - retrieve uname info from the kernel and print it
; John Schwartzman, Forte Systems, Inc.
; 05/03/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o uname.obj uname.asm
; ld -g uname.obj -o uname
; ===========================================================================
STDOUT          equ     1			; define some constants
SYS_EXIT        equ     60          ; Linux service ID for SYS_EXIT
SYS_WRITE       equ     1           ; Linux service ID for SYS_WRITE
SYS_UNAME       equ     63          ; Linux service ID for SYS_UNAME
UTSNAME_SIZE    equ     65
HEADER_SIZE     equ     11
WRITELINE_SIZE  equ     1           ; num bytes to write for linefeed
ZERO            equ     0
; ===========================================================================
section .text       				; ============ CODE SECTION =============
global _start                       ; ld expects to find the label _start

_start:				    	        ; beginning of program
    call    writeNewLine            ; write a blank line to stdout

    mov	    rax, SYS_UNAME          ; prepare to call SYS_UNAME
    mov 	rdi, sysname_res        ; RDI points to address of structure
    syscall                     	; call SYS_UNAME to populate section .bss
    mov 	rdi, rax                ; if -1 is returned in rax
    cmp 	rax, ZERO               ; put it in rdi to tell OS we failed
    jnz 	exit                    ; exit if error getting SYS_UNAME
                                    ; 1st arg set in write method
    mov 	rsi, sysname            ; print sysname header - 2nd arg
    mov 	rdx, HEADER_SIZE        ; print sysname header - 3rd arg
    call 	write                   ; call local method - print w/o linefeed
                                    ; 1st arg set in writeLine method
    lea 	rsi, [sysname_res]      ; print sysname data - 2nd arg
    mov 	rdx, UTSNAME_SIZE       ; print sysname data - 3rd arg
    call 	writeLine               ; call local method - print with linefeed
    
    mov 	rsi, nodename           ; print nodename header
    mov 	rdx, HEADER_SIZE
    call	write

    lea 	rsi, [nodename_res]     ; print nodename data
    mov 	rdx, UTSNAME_SIZE
    call 	writeLine

    mov 	rsi, release            ; print release header
    mov 	rdx, HEADER_SIZE
    call 	write

    lea 	rsi, [release_res]      ; print release data
    mov 	rdx, UTSNAME_SIZE
    call 	writeLine

    mov 	rsi, version            ; print version header
    mov 	rdx, HEADER_SIZE
    call 	write
    
    lea 	rsi, [version_res]      ; print version data
    mov 	rdx, UTSNAME_SIZE
    call 	writeLine

    mov 	rsi, domain             ; print domain header
    mov 	rdx, HEADER_SIZE
    call 	write

    lea 	rsi, [domain_res]       ; print domain data
    mov 	rdx, UTSNAME_SIZE
    call 	writeLine
    call 	writeNewLine
    xor 	rdi, rdi       		    ; fall through to exit rdi = EXIT_SUCCESS

exit:						        ; =========== local function ============
    mov 	rax, SYS_EXIT		    ; exit program - 1st arg rdi = exit code
    syscall                     	; invoke kernel

write:                          	; =========== local function ============
    mov 	rax, SYS_WRITE		    ; Linux service ID
    mov 	rdi, STDOUT			    ; rdi is 1st arg, rsi is second arg
    syscall					        ; invoke kernel
    ret					            ; ======== end of write function ========

writeLine:					        ; =========== local function ============                     	
    mov 	rax, SYS_WRITE		    ; Linux service ID
    mov 	rdi, STDOUT             ; rdi is 1st arg
    syscall					        ; invoke kernel and fall into writeNewLine

writeNewLine:				        ; =========== local function ============
    mov 	rax, SYS_WRITE          ; Linux service ID
    mov 	rdi, STDOUT             ; first argument
    mov 	rsi, linefeed           ; second argument
    mov 	rdx, WRITELINE_SIZE     ; third argument
    syscall                     	; write the newline
    ret					            ; ======== end of writeNewLine ==========
; ===========================================================================
section     .rodata			        ; ======= read-only data section ========
sysname     db      "OS name:   "
nodename    db      "node name: "
release     db      "release:   "
version     db      "version:   "
domain      db      "machine:   "
linefeed    db      10              ; ASCII linefeed character
; ===========================================================================
section     .bss			        ; ===== uninitialized data section ======
sysname_res:    resb    UTSNAME_SIZE
nodename_res:   resb    UTSNAME_SIZE
release_res:    resb    UTSNAME_SIZE
version_res:    resb    UTSNAME_SIZE
domain_res:     resb    UTSNAME_SIZE
; ===========================================================================
