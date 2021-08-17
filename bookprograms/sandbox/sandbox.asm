section .data ;this is a comment F 
hi: db "Hello World!"

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
  mov eax, 5; run loop 5 times
  Jonathan: dec eax ;this is a label
    jnz Jonathan ; jump to label provided if result of last operation wasn't zero
  ;*****4***** Jump if zero demo


  section .bss ;this sections stored uninited data
