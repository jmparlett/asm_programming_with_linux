printalpha: printalpha.o
	ld -m elf_i386 -o printalpha printalpha.o
printalpha.o: printalpha.asm
	nasm -f elf -g -F stabs printalpha.asm -l printalpha.lst
