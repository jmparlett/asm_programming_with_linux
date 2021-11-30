movsbexample: movsbexample.o
	ld -m elf_i386 -o movsbexample movsbexample.o
movsbexample.o: movsbexample.asm
	nasm -f elf -g -F stabs movsbexample.asm -l movsbexample.lst
