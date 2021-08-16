# Assembly Language Step-by-Step: Programming with Linux by Jeff-Duntemann


#### Martian Numbers ( he made a fake number system thats jsut base 4 but weird)
Xip = 0
Foo = 1, |
bar = 2, intersection symbol
bas = 3, triple bar

#### Basic Octal
Each place in a octal number represents a power of 8
starting at 8^0

11 = 8^1 * 1 + 8^0 * 1 = 9

#### Basic Hex
Only new information. Hex numbers are commonly written with a capital H
postfix such as 11H = 17

### Hex Math
Memorize your addition tables and go from there
Fact: the most you ever need to carry or borrow when doing addition
or subtraction is one. This is true in any number system.

Relay: mechanical switch operated by electricity for the purpose of controlling electricity. Flipped by feeding it a pulse of electricity. Legacy computer part not used to construct them anymore.
Transistors: switch made from silicon (it looks like a not gate)
Memory Cell: a transitor and its support components

Memory cell is just like the one described in J Clark Scotts book. Applying voltage to a select pin (same as turning on the set bit) allows you
you to apply or not apply voltage to its input pin (i bit in J Clark). Obviously no voltage on in pin and voltage on S pin sets cell to 0, while voltage on S and input pin sets a 1.


Ram chips are graded on access time. Basically how long it takes to retrieve data from it, for example DDR3 access times range from 6.57ns to 6.00ns.

### Bits and Bytes terminology
>bit: single binary digit 0 or one
>byte: 8 bits
>word: 2 bytes
>double word: 2 words
>quad word: 2 double words

When you just describe things recursively this naming scheme actually makes a lot of sense.

*Every byte of information in the computer has its own unique address, even in computers that 2, 4, or 8 bytes of information at a time.*

Not much new in terms of CPU, Memory, or registers

Binary Codes: Machine instructions. Same idea as instruction for the 8TIAC but not limited to 8 bits. I'm sure the actual instruction size doesn't change but the relavant content of it does.
Some instructions may occupy a single byte but many are much larger.

*The computer is a box that follows a plan* -Ted Nelson


## Chapter 4 Registers, and Memory Addressing

Segment Registers: Memory pointers in a cpu registers that point to a place in memory where
things begin. 

Segement: A region of memory that begins on a paragraph boundary and extends for some number
of bytes. In real mode segmented this number is <= 64K (16^4 bytes)

Some terms.
Name, Dec Val, Hex Val
>Byte 1 01H
>word 2 02H
>Double word 4 04H
>Quad word 8 08H
>Ten byte 10 0AH
>Paragraph 16 10H
>Page 256 100H
>Segment 65536 10000H

Paragraph boundary: any mem address evenly divisble by 16. 0, 10H, 20H, etc

Segment address: the number of the paragraph boundary at which a segment begins. There are 64K different paragraph boundarys in IA-32.
They range from 0 to 64K -1. It makes sense that each segment address is 16 bytes apart.

A segment can be as large as 64K but it can also be smaller. It does not have to allocate its max size.
Nothing really tells where a segment actully ends though. So even if the segment is smaller than 64K you cant know what
memory is or isnt be used in the space. Segments can over lap however. Its best the think of a segment as a place where the cpu's 64K blinders are fixed.


Real mode segmented memory (8086 simulated stuff) addresses things in 20 bits, but its registers
were only 16 bits in size. this meant memory addresses had to be stored in 2 registers.
This means that all memory locations actually have 2 addresses. Every byte resides in a segment
in this memory model. So each locations can be described by a *segment address* and an *offset* from the start of its segment.
The two addresses are written in hex with the following syntax **Segment:offset** 

All segment registers are 16 bits in size even in 32 bit cpus

### Segment Registers
CS: code segment. Machine instructions are stored at some offset into a code segment.
                  Seg address of the current executing instructions is stored in CS
DS: data segment. Variables and other data are stored in the data segment. When the CPU needs to access variables in a certain location.
                  The segment address of that location is stored in DS register.
SS: stack segment. Temp storage of data and addresses.
ES: extra segment. Spare segment, can be used for anything.
FS and GS: ES clones

General purpose registers: They do everything else and are used for everything the seg registers arent.
Just look up a x86 reg cheat sheet for the details

### Real Mode Segmented Model
In this mode your program sees the full 1MB of memory and you need to traverse it.

You can specify a location by giving a segemnt register and an offset seperate by a colon, such CS:BX for the location in the code segment at offset of the value stored in BX.


There is only one stack segement per program. The stack pointer SP points to the memory address where the next stack operation will take place.

In real mode your program has access to all of memory. This include the memory where the OS is running as well as other important tables, etc.
This means your program can corrupt portions of the OS in memory and cause it (and your program) to crash. Protected mode was introduced by intel in response
to this problem. In *protected mode* your program cannot disrupt the OS or other programs operating in memory.

### Protected Mode Flat Model

Your program sees a single block of memory addresses running from zero to a little over 4gb. Each address is 32 bits. All general purpose registers (GP) are 32bits.
So one GP can point to any location in the block.

In this mode segment registers are totally in accessible to you. They are solely controled by the OS. They are used to define where the 4gb block for your
program exists in physical or virtual memory.

In short your program upon running receives access to a 4gb sandbox to play in completely on its own.

# Chapter 5 The Process of Creating Assembly Language Programs

Its important to understand how files are structered in Hex. Its also important to understand that in computers numbers mean what we say they mean.
Just think of ascii for an example. Interesting fact. Windows denotes a newline by both an nl character and a cr while linux only denotes with a nl.
This means notepad use double the amount of space to denote a newline.

Always keep the little endian mode checked in bliss. This is because in america we read from left to right. A computer architecture that stores the least significant
byte of a multibyte value at the lowest offset is called little endian. A arch that stores the most significant byte of multibyte value at the lowest offset is called big endian.
In other words americans read in little endian.

Programs Translators: Translators that generate machine instructions that a CPU can understand by reading a source code file line by line.
it then writes a bin file of machines instructions. The binary file is called an *object code file*

Compiler: a program translator for higher level languages like C.

Assembler: program translator specifically for assembly.


Assembly Language: a translator language that allows total control over every individual machine instruction generate by the translator program (an assembler).

Usually assemblers are used to generate object files. These object files however are not the executeable. The executable is generated by "linker" program
which has the subtle job of making sure your assembly program does what its supposed to do.

#### Assembly Writing Process
1. Create your assembly language source code
2. Use your assembler to create an object module from your source code file.
3. Use your linker to convert the object module and any previously assembled object modules that are part of the project into a single executable program file.
4. Test your program file by running it using a debugger if necessary
5. Go back to step 1 and fix any mistakes / write new code
6. Repeat 1-5 till done.

You can copy a 16 bit reg into a 32 bit you must reference the same size segment.

## !!!
Because the book is written for IA-32 there are some difference in the compilation process.
Debugging standard should be "dwarf" not "stabs" and standard should be "elf64" not "elf"
so "nasm -f elf -g -F stabs eatsyscall.asm" becomes "nasm -f elf64 -g -F dwarf eatsyscall.asm"

create a 32-bit executable with "ld -m elf_i386 -o executablename objectfilename.o"

Hopefully the bacwards compatability between 64 and 32bit will mean there arent any errors in the actual code we'll be writing.

