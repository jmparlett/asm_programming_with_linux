;filename: uppercase.asm
;description: take in a file and output the file with all lowercase chars converted uppercase

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
;if EOF jump to EXIT
;if err (eax < 0) jump to READERROR

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
;


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
        Buff resb 1
section .data
        frerr: db "Error: cannot open file for reading"
        frerrlen: equ $-frerr

        fwerr: db "Error: cannot open file for reading"
        fwerrlen: equ $-frerr
section .text 
  
  global _start


_start:

  nop; for the debugs

  ;read one char from stdin and store to buffer
  Read: mov eax, 3; move service number for sys_read call to eax
        mov ebx, 0; file descriptor will be stdin (0)
        mov ecx, Buff ; store address of buffer to ecx
        mov edx, 1 ; tell sys_read to read one char from stdin
        int 80h ;make sys_read call

        cmp eax, 0; check if sys_reads return value is zero (a zero return value indicates EOF)
  
  je Exit ;jump if comparison is positive
          ;if not equal fall through
  ;comparison works by setting flags based on if 
  ;operand 1 = operand 2; ZF=1, CF=0
  ;operand 1 < operand 2; ZF=0, CF=1
  ;operand 1 > operand 2; ZF=0. CF=0

  ;now we've read a character lets check if lower or uppercase and convert if necessary
  cmp byte [Buff], 61h; 61h = 'a'
  jb Write ; jb = jump if below. If its below 'a' its not lowercase

  cmp byte [Buff], 7Ah; 7Ah = 'z'
  ja Write ; ja = jump if above. If its above 'z' its not lowercase. Its not even an alpha char

  ;we know its a lower case char so lets convert it
  sub byte [Buff], 20h;


  Write: mov eax, 4; specify sys_write service number
         mov ebx, 1; specify stdout for write
         mov ecx, Buff; pass address of char to write
         mov edx, 1 ; edx will specify number of chars to write
         int 80h; make sys_write call
         jmp Read;move to start of prog to continue reading as long as thiers input

  Exit: mov eax, 1; specify sys_exit service number
        mov ebx, 0; exit code 0
        int 80h; make exit call
