determinant: determinant.o
	ld -m elf_i386 -o determinant determinant.o
determinant.o: determinant.asm
	nasm -f elf -g -F stabs determinant.asm -l determinant.lst
