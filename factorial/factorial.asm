;============================================================================
; factorial.asm
; John Schwartzman, Forte Systems, Inc.
; 06/06/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o factorial.obj -l factorial.lst factorial.asm
;============================ CONSTANT DEFINITIONS ==========================
LF				equ 	 10			; ASCII linefeed character
EOL   			equ 	  0			; end of line character
ONE             equ       1         ; number 1
ZERO            equ       0         ; number 0
VAR_SIZE		equ 	  8			; each local var is 8 bytes
NUM_VAR			equ		  2			; number local var (round up to even num)
MAX_INPUT       equ      20         ; max size input
EXIT_SUCCESS	equ  	  0			; return 0 to indicate success
EXIT_FAILURE    equ      -1         ; return -1 to indicate failure

%define zero(reg) xor reg, reg      ; clear a register
;========================== DEFINE LOCAL VARIABLES ==========================
%define		n 		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]		; rsp + 0
;============================== CODE SECTION ================================
section		.text					;============= CODE SECTION =============
global 		main                    ; tell linker about export
extern 		scanf, printf        	; tell assembler/linker about externals

%ifdef __COMMA__                    ;========== use commaSeparate ==========
    extern      commaSeparate
%endif                              ;=======================================

;============================== CODE SECTION ================================
main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, NUM_VAR*VAR_SIZE   ; make space for n

    lea     rdi, [promptFormat]     ; 1st arg to printf
    zero (rax)
    call    printf                  ; prompt user

    lea     rdi, [scanfFormat]      ; 1st arg to scanf
    lea     rsi, [x]                ; 2nd arg to scanf
    zero (rax)
    call    scanf                   ; get x
    mov     rax, [x]
    cmp     rax, MAX_INPUT
    jg      badInput
    cmp     rax, ZERO
    jg      continue

badInput:
    lea     rdi, [wrongInputStr]
    zero (rax)
    call    printf
    mov     rax, EXIT_FAILURE
    jmp     fin

continue:
    mov     rdi, [x]                ; save x
    call    factorial

%ifndef __COMMA__                   ;========== BUILD STANDALONE ============

    lea     rdi, [outputFormat]     ; 1st arg to printf
    mov     rsi, [x]                ; 2nd arg to printf
    mov     rdx, rax                ; 3rd arg to printf
    zero (rax)
    call    printf                  ; print result

%else                               ; == DISPLAY RESULT with commaSeparate ==

    mov     rdi, rax                ; 1st and only arg to commaSeparate
    call    commaSeparate
    mov     rdi, rax                ; get commaSeparate output buffer
    zero (rax)
    call    printf                  ; print commaSeparate output buffer
    lea     rdi, [outputLF]
    zero (rax)
    call    printf                  ; print 2 linefeeds

%endif                              ; == DISPLAY RESULT with commaSeparate ==

    zero (rax)                      ; return EXIT_SUCCESS

fin:
    add     rsp, NUM_VAR*VAR_SIZE   ; make space for n
    leave
    ret

;============================= EXPORTED FUNCTION ============================
factorial:
    push    rbp
    mov     rbp, rsp
    sub     rsp, NUM_VAR*VAR_SIZE   ; make space for n

    cmp     rdi, ONE
    jg      greater
    mov     rax, ONE

    add     rsp, NUM_VAR*VAR_SIZE   ; remove local variable n
    leave
    ret

greater:
    mov     n, rdi                  ; save n
    dec     rdi                     ; call factorial with n - 1
    call    factorial

    mov     rdi, n                  ; restore original n
    imul    rax, rdi                ; multiply factorial(n - 1) * n

    leave
    ret
;==============================  DATA SECTION ===============================
section     .data
x               dq      0
;========================= READ-ONLY DATA SECTION ===========================
section 	.rodata	
scanfFormat	    db		"%ld", EOL
promptFormat    db      "Enter an integer from 1 to 20: ", EOL
outputFormat	db		"%ld! = %ld", LF, LF, EOL
outputFormatStr db      "%s", LF, LF, EOL
wrongInputStr   db      "You have entered an invalid number.", LF, LF, EOL
outputLF        db      LF, LF, EOL
;============================================================================
