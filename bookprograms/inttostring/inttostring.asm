;Exe Name: inttostring.asm
;Description: converts a hard coded integer to a string and prints it to stdout



SECTION .data
  n dw 44; number to convert
  digcount db 0;number of digits we've converted so far
SECTION .bss
  intstrbufflen equ 10; wont store more than ten chars
  intstrbuff: resb intstrbufflen; text buffer

global _start;linker entry point


SECTION .text

_start: 

  nop ;for the debugs

  ;lets see how div works
  ; mov eax, [n]; move num to convert to eax
  ; mov ecx,10; move divisor to ecx
  ; div ecx; divide val in eax by 10

  ;lets work through printing it backwards first
  ;when eax is divided by 10 eax becomes 133
  ;and the remainder is stored in edx so edx becomes 7
  ;store edx+48 at [buff+digcount]
  ;inc digcount
  ;then setup sys_write
  ;write digcount chars to stdout
  ;this should give us the digit backwards

  ;setup regs for conversion
  mov esi, 0; esi will count chars we've converted so far
  mov eax, [n]; move num to convert to eax
  mov ecx,10; move divisor to ecx

  Convert:
  div ecx; divide val in eax by 10
  add edx, 48; convert to ascii char
  mov [intstrbuff + esi], edx;
  inc esi;
  xor edx,edx;zero edx
  cmp eax,0; we're done converting once val in edx is 0
  jne Convert; 

  ;setup regs to reverse the string
  mov ecx, intstrbuff; move starting addr of intstrbuff to ecx
  lea edx, [intstrbuff-1+esi]; mov location of end of intstrbuff to edx


  ;left pointer = ecx
  ;right pointer = edx 
  ;temp = ebx
  ;ebx=[edx]
  ;[edx]=[ecx]
  ;[ecx]=ebx
  ;inc ecx
  ;dec edx
  ;xor ebx, ebx
  ;cmp ecx, edx
  ;jle Reverse

  Reverse:
  ;swap left and right
  mov bl, byte [ecx];store left char
  mov bh, byte [edx];store right char

  mov byte[edx], bl; move left char to right pointer location
  mov byte[ecx], bh; move right char to left pointer location

  inc ecx; inc left pointer
  dec edx; dec right pointer

  xor ebx,ebx; zero ebx

  cmp ecx, edx; compare left and right pointers
  jle Reverse

  Write:
  mov eax, 4; specify sys_write
  mov ebx, 1; specify stdout
  mov ecx, intstrbuff; intstrbuff pointer
  mov edx, esi; specify num of bytes to write
  int 80h; make sys_call
  jmp Exit; dip

  Exit:
  mov eax, 1;specify sys_exit
  mov ebx, 0; return code 0
  int 80h; make call
  
  nop; so we dont run off the end

