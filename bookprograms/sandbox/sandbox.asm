section .data ;this is a comment F 
hi: db "Hello World!"
sums: dd "15,12,6,0,21,14,4,0,0,10"
sumslen equ $-sums; length
a: db "a"
b: db "b"
abc: db "abc"

section .text ;text go here?

  global _start

_start: ;this seems to be basically the main function
  ;program needs to go between the two nops
  nop ;nop 1 
  ;***1***** mov demo
  ; mov ax, 067FEh;store hex to ax
  ; mov bx, ax; copy hex to bx
  ; mov cl, bh; store first byte of bx in low byte of cx
  ; mov ch, bl; store second byte of bx to high byte of cx
  ; xchg cl, ch; swap low and high of cx
  ;****1****

  ;*****2***** move by size and mem location demo
  ; mov al, [hi]
  ; mov [hi], byte 'G';puts a g at the beginning of hi
  ; mov [hi+5], byte '!'; replaces the sixth character in hi with a !
  ;*****2*****

  ;*****3***** flags demo
  ; mov eax, 0ffffffffh
  ; mov ebx, 02dh
  ; inc eax
  ; dec ebx
  ; nop ;nop 2
  ;*****3*****


  ;*****4***** Jump if zero demo
  ; mov eax, 5; run loop 5 times
  ; Jonathan: dec eax ;this is a label
    ; jnz Jonathan ; jump to label provided if result of last operation wasn't zero
  ;*****4***** Jump if zero demo

  
  ;*****5***** infinite loop
  ; mov eax, 5
  ; j:dec eax
    ; jmp j
  ;*****5***** infinite loop


  ;*****6***** 
  ; mov eax, 42
  ; neg eax
  ; add eax, 42

  ; not worth counting
  ; mov eax, 07fffffffh
  ; inc eax,

  ; xor eax, eax
  ; mov ax, -42
  ; mov ebx, eax
  ; xor eax, eax
  
  ; mov ax, -42
  ; movsx ebx, ax


  ;******7****** mul demo
  ; mov eax, 447 ;smaller than 16^3
  ; mov ebx, 1739;smaller then 16^3
  ; mul ebx  ;product wont overflow from a single reg since it will be less then 16^6
  ; look in eax for val

  ; xor eax, eax
  ; xor ebx, ebx
  ; mov eax, 0ffffffffh ;16^8 will definetly overflow
  ; mov ebx, 03b72h ; < 16^5
  ; mul ebx; look in eax/edx


  ;******8****** div demo
  ; mov ebx, 010h
  ; mov eax, 020h
  ; div ebx  ;look in eax


  mov eax, 4; sys_write
  mov ebx, 1; stdout
  mov ecx, sums; sums addr
  mov edx, sumslen;

  section .bss ;this sections stores uninited data
