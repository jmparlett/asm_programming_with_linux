vidbuff: vidbuff.o
	ld -m elf_i386 -o vidbuff vidbuff.o
vidbuff.o: vidbuff.asm
	nasm -f elf -g -F stabs vidbuff.asm -l vidbuff.lst
