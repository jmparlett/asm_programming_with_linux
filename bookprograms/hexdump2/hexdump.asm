;Exe name: hexdump.asm
;Description: converts a binary value to a string. Now with more procedures!

SECTION .bss; uninited data

      BUFFLEN equ 10; file buffer size
      Buff: resb BUFFLEN; buffer 10 bytes long

SECTION .data; initialized data

      DumpLin: db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 "; dont forget to append a \n if we use this on its own
      DUMPLEN equ $-DumpLin; sub beginning from end to get length
      ASCLin: db "|..................|", 10
      ASCLEN equ $-ASCLin; length of just asci line
      FULLEN equ $-DumpLin; because we are just past Dumplin and ASCLin subtracting the start of 
                          ; Dumplin here allows us to get the full length of the contigious Dumplin and ascillen

      ;this is the simple hex digits lookup table we can use go from a hex digit to its corresponding ascii char
      HexDigits: db "0123456789ABCDEF";guessing this will be a lookup table

  ;this is new and large. This ASCII translation table takes a printable char to a printable char
  ;anything else is transformed to a "." character
  DotXlat:
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db 20h,21h,22h,23h,24h,25h,26h,27h,28h,29h,2Ah,2Bh,2Ch,2Dh,2Eh,2Fh
    db 30h,31h,32h,33h,34h,35h,36h,37h,38h,39h,3Ah,3Bh,3Ch,3Dh,3Eh,3Fh
    db 40h,41h,42h,43h,44h,45h,46h,47h,48h,49h,4Ah,4Bh,4Ch,4Dh,4Eh,4Fh
    db 50h,51h,52h,53h,54h,55h,56h,57h,58h,59h,5Ah,5Bh,5Ch,5Dh,5Eh,5Fh
    db 60h,61h,62h,63h,64h,65h,66h,67h,68h,69h,6Ah,6Bh,6Ch,6Dh,6Eh,6Fh
    db 70h,71h,72h,73h,74h,75h,76h,77h,78h,79h,7Ah,7Bh,7Ch,7Dh,7Eh,2Eh
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh

SECTION .text ;code section

;-----------------------------------------------------------------------------
; ClearLine: clear a hex dump line string to 16 0 values
; updated: uhhh at some point
; IN: nothing (no args here)
; RETURNS: nothing 
; MODIFIES: nothing (it affects no registers)
; CALL: DumpChar (another procedure)
; DESCRIPTION: calls DumpChar 16 times to zero Dump line string

ClearLine:
  Pushad ;save callers GP registers to the stack

  mov edx, 15; poke count (were going to poke 16 times)
.poke mov eax, 0 ; poke a '0'
  call DumpChar ;insert '0' into hex dump string
  sub edx, 1 ;recall that dec does not affect the carry flag
  jae .poke ; jump if above or equal (if edx >= 0)
  popad ; restore all registers before call
  ret ;go home :(


;-----------------------------------------------------------------------------
; DumpChar: "poke" a value into the hexdump string (huh?)
; Update: probably never again after this
; IN: Pass 8 val (ASCII char val) to be poked in register EAX
;     Pass the values position in line (0-15) in EDX
; RETURNS: Nothing
; MODIFIES: EAX, ASCLin, DumpLin (so I guess if a procedure modifies somthing it means it affects its execution as well)
; CALLS: were a strong willed independent procedure who dont need no child calls
; DESCRIPTION: put the value in EAX into the positon pointed to by EDX in ASCLin


DumpChar:
  push ebx; save callers ebx
  push edi; save callers edi

  ;input char to ASCII portion of DumpLin
  mov bl, byte [DotXlat+eax] ;translate char with table
  mov byte [ASCLin+edx+1], bl;write to ascii portion

  ;insert hex equivalent in hex portion of DumpLIn
  mov ebx, eax ;save another copy of the input char
  lea edi, [edx*2+edx]; calc offset into line string edx*3

  ;from pretty much same conversion process as hexdump1

  ;perform lookup for low nybble and insert in hex string
  and eax,0000000fh; mask out everything except low byte
  mov al, byte [HexDigits+eax]; perform look and store result back in eax
  mov byte [DumpLin+edi+2], al; insert low nybble in string

  ;perform lookup for hight nybble and insert in hex string
  and ebx, 000000f0h; mask out all but high byte
  shr ebx, 4; discard low byte
  mov bl, byte [HexDigits+ebx]; perform lookup for second char
  mov byte [DumpLin+edi+1], bl; insert high nybble in string

  ;done lets dip
  pop edi ;restore edi
  pop ebx ;restore ebx
  ret ;go home procedure your drunk

;-----------------------------------------------------------------------------
; PrintLine: display line to stdout
; Update: probably never again after this
; IN: Nothing
; RETURNS: Nothing
; MODIFIES: Nothing 
; CALLS: sys_write
; DESCRIPTION: write the hex dump line string DumpLin to stdout

PrintLine:
  pushad ;save all caller's GP registers
  mov eax, 4; sys_write code
  mov ebx, 1; specify stdout
  mov ecx, DumpLin ;pass addr of line
  mov edx, FULLEN ;pass size of full line string
  int 80h ;make call
  popad ;restore all registers precall
  ret ;return control to caller


;-----------------------------------------------------------------------------
; LoadBuff: fill buff with data from stdin via sys_read call
; Update: probably never again after this
; IN: Nothing
; RETURNS: Number of bytes read in 
; MODIFIES: ECX, EBP, Buff 
; CALLS: sys_read
; DESCRIPTION: load a buffer lengths worth of bytes into out buffer via sys_read kernal call

LoadBuff: 
  ;save callers register states
  push edx
  push ebx
  push eax

  mov eax, 3;specify sys_read
  mov ebx, 0;file descriptor 0 (stdin)
  mov ecx, Buff;pass offset of buffer to read to
  mov edx, BUFFLEN; read BUFFLEN bytes
  int 80h ;make call
  mov ebp, eax; save num of bytes read
  xor ecx, ecx; zero ecx
  ;restore registers
  pop edx
  pop ebx
  pop eax

  ret; return control to caller









global _start ;linker entry point

;--------------------------------------
;     Main Prog Start
;--------------------------------------

_start:

  nop; for the debugs

  ;initialize some stuff

  xor esi, esi; zero total byte counter
  call LoadBuff; read first buffer of data from stdin (wow thats so much more succint)
  cmp ebp, 0; check for EOF
  jbe Exit; if reached eof or error dip

  ;move through buffer and convert bin values to hex digits
  Scan:
  xor eax, eax; zero eax
  mov al, byte[Buff+ecx]; get a byte from the buff into al
  mov edx, esi; copy char counter to edx
  and edx, 0000000fh; mask out all but last 4 bits char counter
  call DumpChar ;call char poke


  ;inc buf pointer and check if were done
  inc esi; inc chars processed count
  inc ecx; increment buffer pointer
  cmp ecx, ebp; compare to num of chars in buff
  jb .modTest ;if we've processed all chars in buff
  call LoadBuff; fill buffer
  cmp ebp, 0; check for EOF
  jbe Done; if we got EOF were done
  
  ;check if we are at end of block 16 and need to display a line to reuse our buff
  .modTest:
  test esi, 0000000fh; test low byte for zero
  jnz Scan; if counter not mod 16 loop back
  call PrintLine; else print line
  call ClearLine; clear line for reuse
  jmp Scan; continue scanning buff

  Done:
    call PrintLine ;print the leftovers

  Exit:
    mov eax, 1; specify sys_exit
    mov ebx, 0; return 0
    int 80h; make call


;functions pushing and poping parent vars to the stack makes a lot more sense now and I'm guessing ret just moves execution back to the line it was called from.
