;filename: uppercase.asm
;description: take in a file and output the file with all lowercase chars converted uppercase
;This is the version using a 1024 character buffer instead of reading a char at a time from stdin

;process
;read char from (stdin)
;test if we have reached EOF
;test if char is lowercase (61h <= char <= 7Ah)
;if char is lowercase convert to uppercase by subtraction 20h (char -= 20h)
;write char to (stdout).
;repeat until done (EOF is read from stdin)
;exit program by calling sys_exit

;process 2
;READ:
;set up registers for sys_read call
;call sys_read to read a buffer full of characters from stdin
;store characters read in esi
;test for EOF (eax = 0)
;if EOF jump to exit

;Scan:
;setup registers as a pointer to scan the buffer.
;put address of buffer in ebp
;put num of chars read in ecx

;test the character at buffer pointer to see if its lowercase
;compare byte at [ebp + ecx] against 'a'
;if byte is below 'a' jump to write
;if byte is above 'z' jump to write
;else sub 20h from byte at [ebp + ecx]

; Next:
;decrement ecx by one
;jmp if not zero to scan
;if chars still in buffer jump to scan

;WRITE
;set up registers for sys_write call
;call sys_write to write processed buffer on stdout

;jump to READ to get another buffer of chars

;READERROR
;setup registers for sys_write call
;write write error to stdout
;jump to EXIT

;WRITEERROR
;setup registers for sys_write call
;write write error to stdout
;jump to EXIT


;EXIT
;set up registers for sys_exit call
;call sys_exit with exit code 0


section .bss
        BUFFLEN equ 1024; buffer len basically a defines usage
        Buff: resb BUFFLEN; text buffer
section .data
        frerr: db "Error: cannot open file for reading"
        frerrlen: equ $-frerr

        fwerr: db "Error: cannot open file for writing"
        fwerrlen: equ $-frerr
section .text 
  
  global _start


_start:

  nop; for the debugs

  ;read one char from stdin and store to buffer
  Read: mov eax, 3; move service number for sys_read call to eax
        mov ebx, 0; file descriptor will be stdin (0)
        mov ecx, Buff ; store address of buffer to ecx
        mov edx, BUFFLEN; specify to read a buffers worth of chars
        int 80h ;make sys_read call to fill buff
        mov esi, eax; store sys_read return val
        cmp eax, 0; check for eof
        je Exit; if reached eof exit
  ;comparison works by setting flags based on if 
  ;operand 1 = operand 2; ZF=1, CF=0
  ;operand 1 < operand 2; ZF=0, CF=1
  ;operand 1 > operand 2; ZF=0. CF=0

  ;set regs for processing buffer
        mov ecx, esi; move num chars read to ecx
        mov ebp, Buff; store pointer to start of Buffer to ebp
        dec ebp; adjust count to offset. Basically index -1 if i am understanding which seems real risky

  Scan: ; process buffer
  ;check if current char is lowercase
  cmp byte [ebp + ecx], 61h; 61h = 'a'
  jb Next; jb = jump if below. If its below 'a' its not lowercase

  cmp byte [ebp + ecx], 7Ah; 7Ah = 'z'
  ja Next; ja = jump if above. If its above 'z' its not lowercase. Its not even an alpha char

  ;we know its a lower case char so lets convert it
  sub byte [ebp + ecx], 20h;

  Next: dec ecx; decrement index
        jnz Scan; continue loop until ecx is 0 and we have processed all chars


  ;write full buffer of text to stdout
  Write: mov eax, 4; specify sys_write service number
         mov ebx, 1; specify stdout for write
         mov ecx, Buff; pass buffer address
         mov edx, esi; move num chars in buf to edx. This is why we saved the return val of sys_read
         int 80h; make sys_write call
         jmp Read;move to start of prog to continue reading as long as theres input

  ;were done dip
  Exit: mov eax, 1; specify sys_exit service number
        mov ebx, 0; exit code 0
        int 80h; make exit call
