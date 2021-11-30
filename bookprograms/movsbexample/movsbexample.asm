section .data ;this is a comment F 
EditBuff: db 'abcdefghiklm         ' 
ENDPOS equ 12
INSRTPOS equ 5


SECTION .text 
  global _start

_start: 

  nop; for the debugs

  ;movs demo shifting a string right by one position
  std; moving down in memory
  mov ebx, EditBuff+INSRTPOS; address of insert point
  mov esi, EditBuff+ENDPOS; start at end of string
  mov edi, EditBuff+ENDPOS+1; Bump text right by 1
  mov ecx, ENDPOS-INSRTPOS+1; # chars to bump
  rep movsb; bump string
  mov byte [ebx], ' '; Fs in the beginning of string

  
  nop; for the debugs
