;============================================================================
; hhmmss.asm
; John Schwartzman, Forte Systems, Inc.
; 06/12/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o hhmmss.obj -l hhmmss.lst hhmmss.asm
;============================ CONSTANT DEFINITIONS ==========================
LF				equ 	 10			; ASCII linefeed character
EOL   			equ 	  0			; end of line character
ONE             equ       1         ; number 1
ZERO            equ       0         ; number 0
TEN             equ      10         ; number 10
SIXTY           equ      60         ; number 60
BUFF_SIZE       equ      64

%define     zero(reg)    xor reg, reg
;============================================================================

section		.text					;============= CODE SECTION =============

%ifndef __MAIN__                    ;========== BUILD WITHOUT MAIN ==========

global      toHHMMSS                ; tell linker about export

%else                               ;=========== BUILD WITH MAIN ============

global      main                    ; tell linker about exports
extern      printf, scanf           ; tell assembler/linker about externals

;============================== MAIN FUNCTION ===============================
main:
    push    rbp
    mov     rbp, rsp

    lea     rdi, [promptFormat]     ; 1st arg to printf
    zero (rax)
    call    printf                  ; prompt user

    lea     rdi, [scanfFormat]      ; 1st arg to scanf
    lea     rsi, [x]                ; 2nd arg to scanf
    zero (rax)
    call    scanf                   ; get x

    mov     rdi, [x]                ; x is the long we want in hh:mm:ss fmt
    call    toHHMMSS                ; return pointer to outputBuf in rax
    mov     rdi, rax                ; 1st and only arg to printf
    zero (rax)                      ; no floating point args
    call    printf
    lea     rdi, [outputFormat]
    zero (rax)
    call    printf                  ; write 2 line feeds

    leave
    ret

%endif  ;==================== BUILD WITHOUT MAIN ============================     

;============================= EXPORTED FUNCTION ============================
toHHMMSS:                           ; param rdi = long int
    push    rbp
    mov     rbp, rsp

    lea     rsi, [outputBuf]        ; rsi => destination buffer

    mov     rax, rdi                ; rdi = param
    zero (rdx)
    mov     rcx, SIXTY * SIXTY
    idiv    rcx                     ; get hours
    mov     rdi, rdx                ; rdi -= hours = remainder
    mov     r11, rax                ; save hours
    cmp     rax, TEN
    jge     hhmmss1
    call    writeZero               ; write tens of hours = 0
    jmp     hhmmss2

hhmmss1:
    zero (rdx)
    mov     rcx, TEN
    idiv    rcx
    call    writeDigit              ; write tens of hours != 0

hhmmss2:                            ; now need to write ones of hours
    mov     rax, r11                ; get back hours
    zero (rdx)
    mov     rcx, TEN
    idiv    rcx
    mov     rax, rdx                ; remainder is ones of hours
    call    writeDigit              ; write ones of hours
    call    writeColon

    mov     rax, rdi                ; get time - hours = min + sec
    zero (rdx)
    mov     rcx, SIXTY
    idiv    rcx                     ; get minutes
    mov     rdi, rdx                ; rdi -= (hours + minutes)
    mov     r11, rax                ; save minutes
    cmp     rax, TEN
    jge     hhmmss3
    call    writeZero               ; write tens of minutes = 0
    jmp     hhmmss4

hhmmss3:
    zero (rdx)
    mov     rcx, TEN
    idiv    rcx
    call    writeDigit              ; write tens of minutes != 0
    
hhmmss4:                            ; now need to write ones of minutes
    mov     rax, r11                ; get back minutes
    zero (rdx)
    mov     rcx, TEN
    idiv    rcx
    mov     rax, rdx                ; remainder is ones of hours
    call    writeDigit              ; write ones of hours
    call    writeColon

    mov     rax, rdi                ; get time - hours - min = sec
    mov     r11, rax                ; save seconds
    cmp     rax, TEN
    jge     hhmmss5
    call    writeZero               ; write tens of seconds = 0
    jmp     hhmmss6

hhmmss5:
    zero (rdx)
    mov     rcx, TEN
    idiv    rcx
    call    writeDigit              ; write tens of seconds != 0

hhmmss6:
    mov     rax, r11                ; get back seconds
    zero (rdx)
    mov     rcx, TEN
    idiv    rcx
    mov     rax, rdx                ; remainder is ones of seconds
    call    writeDigit              ; write ones of seconds
    call    writeEOL

    lea     rax, [outputBuf]        ; return pointer to outputBuf in rax

    leave
    ret
;============================= LOCAL FUNCTION ===============================
writeColon:
    mov     cl, ':'
    mov     [rsi], cl
    inc     rsi
    ret
;============================= LOCAL FUNCTION ===============================
writeZero:
    mov     cl, '0'
    mov     [rsi], cl
    inc     rsi
    ret
;============================= LOCAL FUNCTION ===============================
writeDigit:                         ; rax (0-9)
    mov     r8, rax                 ; save rax
    add     al, '0'                 ; convert to char
    mov     [rsi], al               ; write char
    inc     rsi                     ; increment write pointer
    mov     rax, r8                 ; restore rax
    ret
;============================= LOCAL FUNCTION ===============================
writeEOL:
    mov     cl, ZERO
    mov     [rsi], cl
    ret
;==============================  DATA SECTION ===============================
section     .data
x           dq      0
;========================== UNINITIALIZED DATA SECTION ======================
section		.bss
outputBuf	resb	BUFF_SIZE
;========================= READ-ONLY DATA SECTION ===========================
section 	.rodata	
scanfFormat	    db		"%ld", EOL
promptFormat    db      "Enter an integer: ", EOL
outputFormat    db      LF, LF, EOL
;============================================================================
