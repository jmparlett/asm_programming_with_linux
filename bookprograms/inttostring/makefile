inttostring: inttostring.o
	ld -m elf_i386 -o inttostring inttostring.o
inttostring.o: inttostring.asm
	nasm -f elf -g -F stabs inttostring.asm -l inttostring.lst
