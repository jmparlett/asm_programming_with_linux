;name determinant.asm
;description: calculates a 2x2 determinant given comma seperated arguments in a file.
; the arguments must all be <= 7 since calculations will be done using a lookup table.



;process

;Read
;read in arguments to buffer in format a,b,c,d where a,b,c,d <= 7
;set up registers for sys_read

;Calculate
;calculate a*d - (c*b)
;lookup row a/c column d/b
;store lookup results in register a, b
;calc (a-b)

;Write
;write result of calculation to stdout
;set up registers for sys_write

;Exit
;set up registers for sys_exit
;make sys_exit call

SECTION .data
  ; Buff: dd "8,4,7,9"; hard coded for testing
  ; Bufflen equ $-Buff; 7 bytes to hold a,b,c,d
SECTION .bss
  Bufflen equ 7; 7 bytes to hold a,b,c,d
  Buff: resb Bufflen; create buffer of length 8
  intstrbufflen equ 10; wont store more than ten chars
  intstrbuff: resb intstrbufflen; text buffer
  digcount: resd 0;number of digits we've converted so far

SECTION .text

global _start ;linker entry point

;--------------------------------------------------------------------
;Name: inttostring
;IN: the number to convert in eax
;RETURNS: converted number in intstrbuff, and length in intstrbufflen
;MODIFIES:
;CALLS:
;DESCRIPTION: converts given int to string and stores in the buffer intstrbuff

inttostring:
  pushad; save registers

  ;setup regs for conversion
  mov esi, 0; esi will count chars we've converted so far
  mov ecx,10; move divisor to ecx
  xor edx,edx;zero edx

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

  mov [digcount], esi; store count of converted chars
  popad; restore register vals
  ret; go home
;--------------------------------------------------------------------


_start: 
  
  nop; for the debugs

  Read:
    mov eax,3; specify sys_read
    mov ebx,0; stdin
    mov edx,Bufflen; read buffers size of chars from stdin
    mov ecx,Buff; store add of buff to ecx
    int 80h; make sys_call
    mov ebp,eax;store sys_read return val (num of chars read)
    cmp eax,0; check for EOF
    je Exit; if sys_read indicates EOF jump to exit
;
  ;setup registers for calculation step

  Calculate:
    ;buff scale = 2
    ;move a to eax
    ;move d to edx
    ;sub 48 from a and d
    ;imul eax, edx
    ;edx=a*d
    ;zero eax
    ;mov b to eax
    ;mov d to ebx
    ;sub 48 from eax and ebx
    ;imul eax and ebx
    ;sub edx,ebx
    
    mov al, byte [Buff + 2*0]; mov a to eax
    mov dl, byte [Buff + 2*3]; mov d to edx
    sub eax, 48; convert a to int
    sub edx, 48; convert d to int
    imul eax, edx; calc a*d store result in eax

    xor edx,edx; zero edx so we can resuse 

    mov dl, [Buff + 2*1]; mov b to eax
    mov bl, [Buff + 2*2]; mov c to edx
    sub edx, 48; convert b to int
    sub ebx, 48; convert c to int
    imul ebx, edx; calc a*d store result in ebx

    sub eax,ebx; calc (a*d) -(b*c)

    call inttostring; convert calculated val to string

  Write:
  mov eax, 4; specify sys_write
  mov ebx, 1; specify stdout
  mov ecx, intstrbuff; intstrbuff pointer
  mov edx, [digcount]; specify num of bytes to write
  int 80h; make sys_call
  jmp Exit; dip

  Exit:
  mov eax, 1;specify sys_exit
  mov ebx, 0; return code 0
  int 80h; make call

  nop; for the debugs
