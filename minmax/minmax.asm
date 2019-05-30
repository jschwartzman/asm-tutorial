;============================================================================
; minmax.asm - demonstrates using macros for code and for local variables
; John Schwartzman, Forte Systems, Inc.
; 05/30/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o printMax.obj -l printMax.lst printMax.asm
;============================ CONSTANT DEFINITIONS ==========================
LF				equ 	 10			; ASCII linefeed character
EOL   			equ 	  0			; end of line character
VAR_SIZE		equ 	  8			; each local var is 8 bytes wide - qword
NUM_VAR			equ		  2			; number local var (round up to even num)
;========================== DEFINE LOCAL VARIABLES ==========================
%define		a 		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]		; rsp + 0
%define		b 		qword [rsp + VAR_SIZE * (NUM_VAR - 1)]		; rsp + 8
;============================== DEFINE MACRO ================================
%macro prologue	0					;=== prologue macro takes 0 arguments ===
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack now aligned
	sub		rsp, VAR_SIZE * NUM_VAR	; allocate space for local var on stack
	mov		a, rdi					; rdi contains a - 1st arg to min or max
	mov		b, rsi					; rsi contains b - 2nd arg to min or max
	mov		rsi, a					; 2nd arg to printf = a
	mov		rdx, b					; 3rd arg to printf = b
	mov		rcx, rsi				; 4th arg to printf = a; assume result=a
	cmp		rcx, b					; compare a to b - only changes flags reg
%endmacro							;========= end of prologue macro ========
;============================== DEFINE MACRO ================================
%macro epilogue	0					;=== epilogue macro takes 0 arguments ===
	xor		rax, rax				; tell printf no floating point args
	push	rcx						; save rcx in order to return it
	call	printf					; invoke the C function
	pop		rax						; rax = return ; we PUSH rcx, but POP rax
	add		rsp, VAR_SIZE * NUM_VAR	; free space used by local variables
	leave							; undo 1st 2 prologue instructions
	ret								; return to caller 
%endmacro							;========= end of epilogue macro ========
;============================== DEFINE MACRO ================================
%macro max	0						;========= max macro takes 0 args =======
	cmovb	rcx, b					; return value = rcx = b (if a < b)
	lea		rdi, [formatStrMax]		; 1st arg to printf
%endmacro							;============ end of max macro ==========
;============================== DEFINE MACRO ================================
%macro min	0						;========= min macro takes 0 args =======
	cmova	rcx, b					; return value = rcx = b if (a > b)
	lea		rdi, [formatStrMin]		; 1st arg to printf
%endmacro							;========== end of min macro ============
;============================== CODE SECTION ================================
section		.text					
global 		printMax, printMin		; tell linker about exported functions
extern 		printf					; tell assembler about external

printMax:							;=========== printMax function ==========
	prologue
	max
	epilogue						;======== end of printMax function ======

printMin:							;=========== printMin function ==========
	prologue
	min
	epilogue						;======== end of printMin function ======
;========================= READ-ONLY DATA SECTION ===========================
section		.rodata	
formatStrMax	db		"max(%ld, %ld) = %ld", LF, LF, EOL
formatStrMin	db		"min(%ld, %ld) = %ld", LF, LF, EOL
;============================================================================
