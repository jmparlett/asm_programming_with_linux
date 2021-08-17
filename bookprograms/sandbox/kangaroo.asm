section .data
  Snippet db "TISEIGHT"


section .text 
global _start

;This program will transform the string "Snippet" from upper to lower case by adding 32 to the ascii val
_start:
  nop

  mov ebx, Snippet ;ebx is the pointer to each char in our character.

  mov eax, 8; eax is our loop counter

  loop8times: add byte [ebx], 32; add 32 to each byte therfore transforming to lowercase
    inc ebx
    dec eax
    jnz loop8times; repeat loop until eax is 0

  nop
