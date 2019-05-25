;============================================================================
; uname.asm - retrieve uname info from the kernel and print it
; John Schwartzman, Forte Systems, Inc.
; 05/20/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o uname.obj uname.asm
; ld -g uname.obj -o uname
;============================ CONSTANT DEFINITIONS ==========================
STDOUT          equ      1          ; file descriptor for terminal
SYS_EXIT        equ     60          ; Linux service ID for SYS_EXIT
SYS_WRITE       equ      1          ; Linux service ID for SYS_WRITE
SYS_UNAME       equ     63          ; Linux service ID for SYS_UNAME
UTSNAME_SIZE    equ     65          ; number of bytes in each *_res entry
HEADER_SIZE     equ     11          ; size of each header
WRITELINE_SIZE  equ      1          ; num bytes to write for linefeed
LF              equ     10          ; ASCII linefeed character
ZERO            equ      0          ; the number 0
;============================== CODE SECTION ================================
section     .text
global      _start                  ; ld expects to find the label _start

_start:				    	        ; beginning of program
    mov	    rax, SYS_UNAME          ; prepare to call SYS_UNAME
    lea 	rdi, [sysname_res]      ; RDI points to address of structure
    syscall                     	; call SYS_UNAME to populate .bss section
    mov 	rdi, rax                ; if -1 is returned in rax
    cmp 	rax, ZERO               ; put it in rdi to tell OS we failed
    jnz 	exit                    ; exit if error getting SYS_UNAME

    call    writeNewLine            ; write a blank line to stdout
    
    lea 	rsi, [sysname]          ; SYS_WRITE 2nd arg
    call 	writeHeader             ; call local method - print w/o linefeed
    lea 	rsi, [sysname_res]      ; SYS_WRITE 2nd arg
    call 	writeData               ; call local method - print with linefeed
    
    lea 	rsi, [nodename]         ; print nodename header
    call	writeHeader
    lea 	rsi, [nodename_res]     ; print nodename data
    call 	writeData

    lea 	rsi, [release]          ; print release header
    call 	writeHeader
    lea 	rsi, [release_res]      ; print release data
    call 	writeData

    lea 	rsi, [version]          ; print version header
    call 	writeHeader
    lea 	rsi, [version_res]      ; print version data
    call 	writeData

    lea 	rsi, [domain]           ; print domain header
    call 	writeHeader
    lea 	rsi, [domain_res]       ; print domain data
    call 	writeData

    call    writeNewLine            ; write a blank line to stdout
    xor 	rdi, rdi       		    ; rdi = EXIT_SUCCESS - fall into exit

exit:						       
    mov 	rax, SYS_EXIT		    ; exit program - 1st arg rdi = exit code
    syscall                     	; invoke kernel and we're gone

writeHeader:    ;===== local method - caller sets SYS_WRITE 2nd param =====
    mov 	rax, SYS_WRITE		    ; Linux service ID
    mov 	rdi, STDOUT			    ; SYS_WRITE 1st arg
    mov 	rdx, HEADER_SIZE        ; SYS_WRITE 3rd arg
    syscall					        ; invoke kernel
    ret					            ;====== end of writeHeader method =====

writeData:      ;===== local method - caller sets SYS_WRITE 2nd param =====
    mov 	rax, SYS_WRITE		    ; Linux service ID
    mov 	rdi, STDOUT             ; SYS_WRITE 1st arg
    mov 	rdx, UTSNAME_SIZE       ; SYS_WRITE 3rd arg 
    syscall					        ; invoke kernel & fall into writeNewLine

writeNewLine:				        ;============ local method ============
    mov 	rax, SYS_WRITE		    ; Linux service ID
    mov 	rdi, STDOUT             ; SYS_WRITE 1st arg
    lea 	rsi, [linefeed]         ; SYS_WRITE 2nd arg
    mov 	rdx, WRITELINE_SIZE     ; SYS_WRITE 3rd arg
    syscall                         ; invoke kernel
    ret
;========================= READ-ONLY DATA SECTION ===========================
section     .rodata
sysname     db      "OS name:   "
nodename    db      "node name: "
release     db      "release:   "
version     db      "version:   "
domain      db      "machine:   "
linefeed    db      LF              ; ASCII linefeed character
;========================== UNINITIALIZED DATA SECTION ======================
section     .bss
sysname_res     resb    UTSNAME_SIZE
nodename_res    resb    UTSNAME_SIZE
release_res     resb    UTSNAME_SIZE
version_res     resb    UTSNAME_SIZE
domain_res      resb    UTSNAME_SIZE
;============================================================================
