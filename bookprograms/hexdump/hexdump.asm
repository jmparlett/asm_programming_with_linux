;Exe name: hexdump.asm
;Description: converts a binary value to a string

SECTION .bss; uninited data

      BUFFLEN equ 16; file buffer size
      Buff: resb BUFFLEN; buffer 16 bytes long

SECTION .data; initialized data

      HexStr: db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 10
      HEXLEN equ $-HexStr; sub beginning from end to get length

      Digits: db "0123456789ABCDEF";guessing this will be a lookup table

SECTION .text; code and stuff

global _start; linker needs to find entry point

  _start:

  nop; for the debugs
  
  ;read a buffer of text from stdin
  Read:
  ;setup registers
  mov eax, 3; 3 = sys_read
  mov ebx, 0; 0 = stdin
  mov ecx, Buff; ecx=buff pointer
  mov edx, BUFFLEN; chars to read
  int 80h; call sys_read

  mov ebp, eax; same num of bytes read
  cmp eax, 0

  je Done; jmp if eax=0 indicating reached EOF on read

  ;set regs to process buffer
  mov esi, Buff; place address of file buff into esi
  mov edi, HexStr; place addr of line string to edi
  xor ecx, ecx; zero line string pointer

Scan:; process buffer
 
  xor eax, eax; Clear eax to 0

  ;calculate offset into hexstring
  mov edx, ecx; copy the char counter to edx 
  shl edx, 1; multiply pointer by 2
  add edx, ecx

  ;get char from buf and place it in eax and ebx 
  mov al, byte [esi + ecx]; put byte from buff to al
  mov ebx, eax ; Duplicate byte in bl for second nybble

  ;look up low nybble in char array and insert in string
  and al, 0fh ; 0fh mask for low bits
  mov al, byte [Digits+eax]; look up char 
  mov byte [HexStr+edx+2], al 


  ;look up high nybble char and insert it into the string
  shr bl, 4; shift high 4 to low 4
  mov bl, byte [Digits+ebx]; look up char equivalent of nybble
  mov byte [HexStr + edx + 1], bl; WRite MSB char digit to line string

  ;bump the buffer pointer to the next char and see if were done
  inc ecx; inc line pointer
  cmp ecx, ebp; compare num of chars in buff
  jna Scan ;loop back if ecx <= number of chars in buffer

  ;write lines of hex to stdout
  mov eax, 4; sys write call
  mov ebx, 1; stdout fp
  mov ecx, HexStr; buff pointer
  mov edx, HEXLEN; number of chars to write
  int 80h; interuppt to make sys call
  jmp Read; loop back and load buffer


  Done: ;were done dip
  mov eax, 1; exit syscall
  mov ebx, 0; return code 0
  int 80h; make syscall
