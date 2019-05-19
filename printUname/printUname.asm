;============================================================================
; printUname.asm - retrieve uname info from glibc and print it
; printUname.asm does not have a main; it exports the function getUname
; John Schwartzman, Forte Systems, Inc.
; 05/11/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o printUname.obj printUname.asm
;============================ CONSTANT DEFINITIONS ==========================
ZERO            equ      0
LF              equ     10          ; ASCII linefeed character
EOL             equ      0          ; end of line
UTSNAME_SIZE    equ     65
;============================== DEFINE MACRO ================================
%macro printNameAndValue    1
    lea     rdi, [%1]               ; print name
    print
    lea     rdi, [%1_res]           ; print value
    print
    printLine
%endmacro
;============================== DEFINE MACRO ================================
%macro printLine    0
    lea     rdi, [newLine]          ; print new line
    print
%endmacro
;============================== DEFINE MACRO ================================
%macro print   0
    xor     rax, rax                ; tell prinf no floating point args
    call    printf                  ; invoke glibc
%endmacro
;============================== CODE SECTION ================================
section     .text
global      printUname              ; tell linker we're exporting printUname
extern 		uname, printf       	; tell assembler about externals
;============================= EXPORTED FUNCTION ============================
printUname:
    lea     rdi, [sysname_res]      ; get uname
    call    uname                   ; invoke glibc
    cmp     rax, ZERO               ; uname returned ZERO
    jne     finish                  ; jump if no

    printLine                       ; print new line
    printNameAndValue sysname
    printNameAndValue release
    printNameAndValue version
    printNameAndValue domain
    printLine                       ; print new line

    xor     rax, rax                ; RAX = EXIT_SUCCESS

finish:
    ret
;========================= READ-ONLY DATA SECTION ===========================
section     .rodata
sysname     db      "OS name:   ", EOL
nodename    db      "node name: ", EOL
release     db      "release:   ", EOL
version     db      "version:   ", EOL
domain      db      "machine:   ", EOL
newLine		db	    LF, EOL
;========================== UNINITIALIZED DATA SECTION ======================
section     .bss
sysname_res    resb    UTSNAME_SIZE
nodename_res   resb    UTSNAME_SIZE
release_res    resb    UTSNAME_SIZE
version_res    resb    UTSNAME_SIZE
domain_res     resb    UTSNAME_SIZE
;============================================================================
