;Name: vidbuff.asm
;Description: demonstrate strings instructions by faking full screen memory-mapped text I/O.


SECTION .data; yall know what.. it... is... variable space... ha ha
  EOL equ 10; ascii newline char ('\n')
  FILLCHR equ 32; ascii space char (not printable)
  HBARCHR equ 45; ascii dash char
  STRTROW equ 2; row to start drawing at

  ;table of byte length numbers 
  Dataset db 9, 71, 17, 52, 55, 18, 29, 36, 18, 68, 77, 63, 58, 44, 0

  Message db "Who knows who cares"
  MSGLEN equ $-Message

  ;escapay seq to take cursor home 1,1
  ClrHome db 1bh,"[2j",1bh,"[01;01H"; were not using the normal 1b[H because home here is 1,1 not 0,0
  CLRLEN equ $-ClrHome ;length of clear home string

SECTION .bss; uninited data section
  COLS equ 81; line length + 1 char for EOL (line len 80 just cause. We really have no way of knowing screen size without doing some extra stuff)
  ROWS equ 25; number of lines in display (also arbitrary)
  VidBuff resb ROWS*COLS; dynamic since its calculated based on rows and cols. This effectively allocates a 2d grid in memory the size of our screen.

SECTION .text; glorious code section

global _start ;linker entry point 

;macro to clear screen and send cursor home (1,1) in this case.
%macro ClearTerminal 0
  pushad ;save all registers
  mov eax, 4; sys_write
  mov ebx, 1; stdout
  mov ecx, ClrHome; ecx=pointer to clear home
  mov edx, CLRLEN; len of escape sequence to write
  int 80h; make call
  popad; restore registers
%endmacro


;------------------------------------------------------------------
;Show: write text buff to stdout
; RETURN: Nothing
; Modifies: Nothing
; Calls: sys_write
; Description: write text buffer to standard out by make a linux sys_write call
;              bytes to write = rows*cols

Show: pushad; save registers
      mov eax, 4; sys_write
      mov ebx, 1; stdout
      mov ecx, VidBuff; ecx = VidBuff pointer
      mov edx, COLS*ROWS; size of 2d buffer
      int 80h; make call
      popad; restore registers
      ret; return control to caller


;------------------------------------------------------------------
;ClrVid: Clear text buff by writing whitespace (space chars) and replacing newlines
;IN: Nothing
;Returns: Nothing
;Modifies: VidBuff, DF
;Calls: Nothing

ClrVid: push eax ;save register of caller
        push ecx
        push edi

        cld ;clear df. Were counting up memory
        mov al, FILLCHR; put fill char in al
        mov edi, VidBuff; edi = vidbuff pointer
        mov ecx, COLS*ROWS; vidbuff size
        rep stosb; blast chars into buffer

        ;buffer cleared. Reinsert EOL
        mov edi, VidBuff; edi = vidbuff pointer again
        dec edi; start EOL position count at vidbuff char 0 (this means out offset will be correct when we add COLS to pointer)
        mov ecx, ROWS; we will repeat process for each row

  PtEOL: add edi, COLS; add col count (means we are at the last position of the currect row
         mov byte[edi], EOL; mov eol char to end of row
         loop PtEOL; loob back if more lines left
         
         ;were done restore registers and return
         pop edi
         pop ecx
         pop eax
  ret; return control to caller


;------------------------------------------------------------------
; WrtLn: writes a string of text to buffer
; IN: address of string passed in ESI
;     X position passed in EBX (row #)
;     Y position (column #) passed in EAX
;     The length of the string in chars is passed in ECX
; RETURNS: Nothing
; MODIFIES: VidBuff, EDI, DF
; CALLS: Nothing
; Description: Uses REP MOVSB to copy a string from the address of ESI to an X,Y position in VidBuff

WrtLn: push eax; save registers
       push ebx
       push ecx
       push edi

       cld; clear DF
       mov edi, VidBuff; edi=vidbuff pointer
       dec eax; move down 1 in Y for addr calculation
       dec ebx; move down 1 in X for addr calculation
       mov ah, COLS; move screen width to ah
       mul ah; multiply ah*al result in ax
       add edi, eax; Add Y offset into vidbuff to EDI
       add edi, ebx; Add X offset
       rep movsb; blast string to buffer

       ;restore registers
       pop edi
       pop ecx
       pop ebx
       pop eax
       ret; return control to caller


;------------------------------------------------------------------
;WrtHB: Generates a horizontal line bar at X,Y in text buffer
;IN: X position (row #) in EBX
;    Y position (col #) in EAX
;    length of bar in chars in ECX
;RETURN: Nothing
;MODIFIES: VidBuff, DF
;CALLS: Nothing
;Description: Writes a horizontal bar to the video buffer at the X,Y coords given. bar is made of HBARCHR

WrtHB: ;save registers
       push eax
       push ebx
       push ecx
       push edi

       cld; clear DF for up mem write

       mov edi, VidBuff; edi = VidBuff pointer

       ;move down 1 in X,Y for addr calculation
       dec eax
       dec ebx

       mov ah,COLS; move screen width to ah
       mul ah; mul ah*al store in ax
       add edi, eax; add Y offset to pointer
       add edi, ebx; add X offset to pointer
       mov al, HBARCHR; put char to use for bar in al
       rep stosb; blast chars to buffer
       
       ;restore registers
       pop edi
       pop ecx
       pop ebx
       pop eax
       ret; return control to caller



;------------------------------------------------------------------
;Ruler: Generates a "1234567890"-style ruler at X,Y in text buffer
;IN: X position (row #) in EBX
;    Y position (col #) in EAX
;    length of ruler in chars in ECX
;RETURN: Nothing
;MODIFIES: VidBuff
;CALLS: Nothing
;Description: Write a ruler to vidbuff at the given X,Y


Ruler: ;save registers
       push eax
       push ebx
       push ecx
       push edi

       mov edi, VidBuff; edi = VidBuff pointer
       ;move down 1 in X,Y for addr calculation
       dec eax
       dec ebx

       mov ah, COLS; move screen width to ah
       mul ah; multiply ah*al store result in ax
       add edi, eax; add Y offset to edi
       add edi, ebx; add X offset to edi

       ;EDI holds address of start of Ruler. Now lets display it start at '1'

       mov al,'1';store dat byte (becuase ascii we can just inc or dec to get digits 1-9
       
       DoChar: stosb; Note no REP prefix! The rep prefix "repeats" until ecx is 0 so this loop is an example of us controling the execution of stosb
               add al, '1' ;bump char in al up by 1
               aaa; adjust ax for BCD addition
               add al, '0'; make sure we have binary 3 in al's high nybble
               loop DoChar; loop to ECX=0

               ;restore registers
               pop edi
               pop ecx
               pop ebx
               pop eax

               ret; return control to caller


;------------------------------------------------------------------
;MAIN PROG

_start:
       nop ;for the debugs


      ;Clear console and init text buff
      ClearTerminal; send clear screen escape sequence to terminal (macro
      call ClrVid; clear VidBuff before use

      ;Display top ruler
      mov eax, 1; load Y to AL
      mov ebx, 1; load X to BL
      mov ecx, COLS-1; load ruler length
      Call Ruler; display ruler

      ;Loop through and graph dataset
      mov esi, Dataset; esi = Dataset pointer
      mov ebx, 1; start all bars at left margin x=1 ( so we dont overwrite ruler?)
      mov ebp, 0; dataset index starts at 0

      .blast: mov eax, ebp; add dataset num to element index
      add eax, STRTROW; offset row by row num of first bar
      mov cl, byte[esi+ebp]; put dataset val in low byte of ECX
      cmp ecx, 0; see if we pulled a 0 from the dataset
      je .rule2; if we pulled a zero were done
      call WrtHB; graph data as a horizontal bar
      inc ebp; Increment dataset element index
      jmp .blast; do another bar

      .rule2: mov eax, ebp; Use dataset counter to set ruler row
              add eax, STRTROW; Bia row#
              mov ebx,1; Load X to bl
              mov ecx, COLS-1; load ruler length
              call Ruler; write ruler to buffer

      ;Write informative message on last line
      mov esi, Message; esi = message pointer
      mov ecx, MSGLEN; ecx=length of message
      mov ebx, COLS; ebx = screen width

      sub ebx, ecx; Calc diff of message length and screen width
      shr ebx, 1; diff/=2
      mov eax, 24; set message row to line 24
      call WrtLn; display message


      ;write one more time before exit
      call Show; display graph

      Exit:; exit prog
      mov eax,1; sys_exit
      mov ebx,0; exit code = 0
      int 80h; make call
