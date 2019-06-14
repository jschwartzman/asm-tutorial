;============================================================================
; commaSeparate.asm
; John Schwartzman, Forte Systems, Inc.
; 06/07/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o commaSeparate.obj 
;      -l commaSeparate.lst commaSeparate.asm
;============================ CONSTANT DEFINITIONS ==========================
LF				equ 	 10			; ASCII linefeed character
EOL   			equ 	  0			; end of line character
ONE             equ       1         ; number 1
ZERO            equ       0         ; number 0
VAR_SIZE		equ 	  8			; each local var is 8 bytes
NUM_VAR			equ		  2			; number local var (round up to even num)
BUFF_SIZE       equ      64
TEN             equ      10
HUNDRED         equ     100
THOUSAND        equ    1000
MILLION         equ    THOUSAND * THOUSAND
BILLION         equ    THOUSAND * MILLION
TRILLION        equ    THOUSAND * BILLION
QUADRILLION     equ    THOUSAND * TRILLION
QUINTILLION     equ    THOUSAND * QUADRILLION

; NOTE: SEXTILLION equ THOUSAND * QUINTILLION doesn't fit in a 64 bit field

%define     zero(reg)    xor reg, reg
;=============================== DEFINE MACRO ===============================
%macro  writePowerOfThree     1
    mov     rax, n
    zero (rdx)
    mov     rcx, %1                 ; %1 = divisor
    idiv    rcx
    mov     rdi, rax
    push    rdi                     ; save number of PowerOfThree
    call    writeThreeDigits
    pop     rcx
    mov     rax, %1                 ; %1 = divisor
    mul     rcx
    mov     rcx, rax 
    mov     rax, n
    sub     rax, rcx
    mov     n, rax                  ; save what's left of n
%endmacro
;=============================== DEFINE MACRO ===============================
%macro writeUnits   0
    mov     rax, n
    zero (rdx)
    mov     rcx, HUNDRED
    idiv    rcx
    mov     nTmp, rax               ; initialize nTmp = n / 100
    cmp     rax, ZERO
    jz      %%writeUnits1
    mov     rax, nTmp
    mov     rcx, HUNDRED
    mul     rcx                     ; rax = nTmp * 100
    mov     rcx, rax
    mov     rax, n
    sub     rax, rcx                ; n -= nTmp * 100 -- remove HUNDREDS
    mov     n, rax

%%writeUnits1:
    mov     rax, nTmp
    call    writeNTmp

    mov     rax, n
    zero  (rdx)
    mov     rcx, TEN
    idiv    rcx
    mov     nTmp, rax               ; nTmp = n / 10
    call    writeNTmp

    mov     rax, nTmp
    mov     rcx, TEN
    mul     rcx                     ; rax = nTmp * 10
    mov     rcx, rax
    mov     rax, n
    sub     rax, rcx
    mov     n, rax
    call    writeN
%endmacro
;========================== DEFINE LOCAL VARIABLES ==========================
%define		n 		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]		; rsp + 0
%define		nTmp	qword [rsp + VAR_SIZE * (NUM_VAR - 1)]		; rsp + 8
;============================== CODE SECTION ================================
section		.text					;============= CODE SECTION =============

%ifndef __MAIN__                    ;========== BUILD WITHOUT MAIN ==========

global      commaSeparate           ; tell linker about exports

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

    mov     rdi, [x]                ; x is the long we want to separate
    call    commaSeparate           ; return pointer to outputBuf in rax
    mov     rdi, rax                ; 1st and only arg to printf
    zero (rax)                      ; no floating point args
    call    printf
    lea     rdi, [outputFormat]
    zero (rax)
    call    printf                  ; write 2 line feeds

    leave
    ret

%endif  ;====================== BUILD WITH MAIN =============================     

;============================= EXPORTED FUNCTION ============================
commaSeparate:                      ; param rdi = long int
    push    rbp
    mov     rbp, rsp
    sub     rsp, NUM_VAR*VAR_SIZE   ; make space for n, nTmp

    lea     rsi, [outputBuf]        ; rsi => destination buffer
    zero (r11)                      ; bFoundFactor = false
    mov     rax, rdi                ; get n
    mov     n, rax                  ; initialize n

    writePowerOfThree QUINTILLION
    writePowerOfThree QUADRILLION
    writePowerOfThree TRILLION
    writePowerOfThree BILLION
    writePowerOfThree MILLION
    writePowerOfThree THOUSAND
    writeUnits

    lea     rax, [outputBuf]        ; return pointer to outputBuf in rax

    add     rsp, NUM_VAR*VAR_SIZE   ; remove space for n & nTmp
    leave
    ret
;============================= LOCAL FUNCTION ===============================
writeThreeDigits:                   ; parameter: rdi = any int from 0 to 999
    mov     rax, rdi
    zero (rdx)                
    mov     rcx, HUNDRED
    idiv    rcx                     ; rax = number of hundreds
    mov     r8, rax                 ; save number of hundreds
    call    writeNTmp               ; write hundreds

    mov     rax, r8
    zero (rdx)
    mul     rcx                         
    mov     rcx, rax
    mov     rax, rdi
    sub     rax, rcx                ; rax = rdi - (x * 100)
    mov     rdi, rax

    zero (rdx)
    mov     rcx, TEN
    idiv    rcx                     ; rax = number of tens
    mov     r8, rax                 ; save number of tens
    call    writeNTmp               ; write tens

    mov     rax, r8
    zero (rdx)
    mul     rcx
    mov     rcx, rax                ; rcx = 10 * number of tens
    mov     rax, rdi
    sub     rax, rcx                ; rax = rdi - (x * 100) - (y * 10)
    call    writeNTmp
    call    writeComma
    ret
;============================= LOCAL FUNCTION ===============================
writeComma:
    cmp     r11, ZERO
    jz      noWriteComma
    mov     al, ','
    mov     [rsi], al
    inc     rsi

noWriteComma:
    ret
;============================= LOCAL FUNCTION ===============================
writeNTmp:                          ; rax = nTmp (0-9)
    cmp     al, ZERO                ; al == 0 ?
    jnz     writeNTmp1              ; jump if no
    cmp     r11, ONE                ; bFoundFactor ?
    jne     writeFin                ; don't write a '0' if ! bFoundFactor   
    
writeNTmp1:
    mov     r11, ONE                ; bFoundFactor = true
    add     al, '0'                 ; convert to char
    mov     [rsi], al               ; write char
    inc     rsi                     ; increment write pointer

writeFin:
    ret
;============================= LOCAL FUNCTION ===============================
writeN:                             ; rax = n (0-9)
    add     al, '0'                 ; convert to char
    mov     [rsi], al               ; write char
    inc     rsi
    mov     al, EOL                 ; add EOL
    mov     [rsi], al               ; write EOL
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
