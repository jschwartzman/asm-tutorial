; ===========================================================================
; uname.asm - retrieve uname info from the kernel and print it
; John Schwartzman, Forte Systems, Inc.
; 04/28/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o uname.obj uname.asm
; ld -g uname.obj -o uname
; ===========================================================================
STDOUT          equ     1			; define some constants
SYS_EXIT        equ     60
SYS_WRITE       equ     1
SYS_UNAME       equ     63
UTSNAME_SIZE    equ     64
HEADER_SIZE     equ     11
WRITELINE_SIZE  equ     1
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

    mov 	rsi, sysname            ; print sysname header
    mov 	rdx, HEADER_SIZE
    call 	write                   ; call local method - print w/o linefeed
    
    lea 	rsi, [sysname_res]      ; print sysname data
    mov 	rdx, UTSNAME_SIZE
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
    mov 	rax, SYS_EXIT		    ; exit program - rdi contains exit code
    syscall                     	; invoke kernel

write:                          	; =========== local function ============
    mov 	rax, SYS_WRITE		    ; uses rax, rdx, rsi, rdi
    mov 	rdi, STDOUT			    ; rdi is 1st arg, rsi is second arg
    syscall					        ; invoke kernel
    ret					            ; ======== end of write function ========

writeLine:					        ; =========== local function ============                     	
    mov 	rax, SYS_WRITE		    ; uses rax, rdx, rsi, rdi
    mov 	rdi, STDOUT
    syscall					        ; invoke kernel and fall into writeNewLine

writeNewLine:				        ; =========== local function ============
    mov 	rax, SYS_WRITE
    mov 	rdi, STDOUT
    mov 	rsi, linefeed
    mov 	rdx, WRITELINE_SIZE
    syscall                     	; write the newline
    ret					            ; ======== end of writeNewLine ==========
; ===========================================================================
section .rodata				        ; ======= read-only data section ========
sysname     db      "OS name:   "
nodename    db      "node name: "
release     db      "release:   "
version     db      "version:   "
domain      db      "machine:   "
linefeed    db      10
; ===========================================================================
section .bss				        ; ===== uninitialized data section ======
sysname_res:    resb    UTSNAME_SIZE + 1
nodename_res:   resb    UTSNAME_SIZE + 1
release_res:    resb    UTSNAME_SIZE + 1
version_res:    resb    UTSNAME_SIZE + 1
domain_res:     resb    UTSNAME_SIZE + 1
; ===========================================================================
