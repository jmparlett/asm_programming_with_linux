; printalpha.asm
; description: prints the alphabet

SECTION .data; variables section

 char: db "A", 10; 10='\n'
 len:  equ $-char; this should always be two but lets do an assembly time calc so we can see how it works

SECTION .BSS; uninited data section


SECTION .text; code section


global _start


_start: ;main function? routine?
  nop ;for gdb
  ;range for alpha in hex is 41h to 5A

  mov edi, 19h; move 26 to edi so we can loop 26 times
  mov ecx, char  ;move addr to start of char to ecx
  mov edx, len;because I want to see len being 1
  
  mov eax, 4; specify syswrite call service number=4
  mov ebx, 1; specify file descriptor for syswrite 1=stdout

  int 80H; make call to print current character

  aloop: inc byte [ecx] ; increment character so we get next capital letter in alphabet
    mov eax, 4; specify syswrite call service number=4
    mov ebx, 1; specify file descriptor for syswrite 1=stdout
    int 80H; make call to print current character
    dec edi; decrease out loop counter. This must be the first operation before jump because jnz test if the result of last op was zero
    jnz aloop; repeat loop while edi greater than zero

  nop;for gdb so we dont step off the edge and crash the program

  ;should've printed our stuff so lets exit
  mov eax, 1; load exit service number to eax
  mov ebx, 0; load return code to ebx
  int 80h; make the call to exit the program

