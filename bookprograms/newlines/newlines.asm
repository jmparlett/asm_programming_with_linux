;This is probably syntactically incorrect, but its a nice example procedure so lets keep it anyway
;Exe Name: newlines.asm
;Description: Send between 1-15 newlines to the console
;IN: Nothing
;RETURNS: Nothing
;MODIFIES: Nothing. Registers are preserved

Newlines:
  pushad; store all registers to the stack
  cmp edx, 15; check if caller asked for more than 15
  ja .exit ;he gets no new lines if so
  mov ecx, EOLs;address of newlines table
  mov eax, 4; specify sys_write
  mov ebx, 1; stdout
  int 80h; make call
  .exit popad ;restore registers
  ret; go home
  
  EOLs db 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10; example of data internal to a procedure
