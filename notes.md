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

*If you're simply looking for a more advanced challenge in assembly language, look into writing network apps using Unix sockets. This involves way less research, and the apps you produce may well be useful for administering servers or other "in the background" software packages that do not require graphical user interfaces.* -Author


#Chapter 7 Meeting Machine Instructions

A starting point must be defined in an asm files such as the lable "\_start"
You must also have a .text and .data section

a new section is defined by section .data for example

.data: holds data items that to be given initial value when the program runs.
.text: holds program code
.bss: hold unitialized data. Space for data items given no inital value. They may receive value during program execution.

##Instructions
MOV: moves a byte, word dword, or quadword (x64) from one reg to another or from mem into a reg. It cannot move from memory to memory however.
that can be accomplished with two MOVs though.

syntax: mov <dest>, <source>
example: mov eax, 1;moves 1 into the eax register

In general when a machine instruction generates a new value, the new value is placed in the destination operand.

hex neumbers are denoted with lowercase 'h' such as '42h'

[EBP] = datastored at location specified by EBP

mov edx, [ESI]

When you supply data directly inside an instruction it is called direct addressing such as in "mov eax, 42h" here 42h is direct data.
register addressing is when you reference a register in an instruction, and register data is data stored inside a register.

You cannot mix register of different sizes. Dont try to move from a 32bit reg to a 16 or vice versa.

The following are valid ways to access data at a memory location specified by a register.
mov eax,[ebx+16
mov eax,[ebx+ecx]
mov eax,[ebx+ecx+11]
The result of any of these operations is an effective address. You cannot however add 3 or more registers to get an effective address.

In assembly variables represent addresses not the actual data itself.
EatMsg: db "hello world"
mov ecx, EatMsg
here the string itself is not stored in ecx just the address of the string.
You can access the data in a variable with square brackets [EatMsg]

mov edx, [EatMsg]
moves the first four bytes (in this case the ascii chars "hell") into ecx
to move only one byte of EatMsg you would have to store it to a one byte location.
mov al, [EatMsg]
would move the first ascii char "h" into the low order bits of eax
similar tricks work by referencing the 16bit and 64bit names of the register.

you can move a certain amount of bytes to memory by using a size specifier.
mov [EatMsg], byte 'G'

Inc: this instruction takes a single operand and increases it by one
Dec: flipside of inc


#### Flags register
OF: the overflow flag is set(1) when the result of an arithmetic operation on a signed integer quantity becomes too large to fit in the operand it originally occupied.
    Generally used as the carry flag in signed arithmetic.


DF: the direction flag tell the CPU the direction that activity moves (what?) either up-memory or down memory during the exevution of string instructions.
    set(1) means string in structions proceed from high memory to low memory. Recall that moving a string to a register stores it backwards in the register 
    so it sounds like set should be the default. When DF is cleared(0) strings instructions proceed from low to high memory.

IF: Interrupt flag. Can be set by using the STI and CLI instructions, also set by the CPU under certain conditions. When set Interrupts are enabled and may
    occur when requested. when clear interrupts are ignored by the CPU. IF was accessed by all programs back in real mode, however under protected you cannot
    use STI and CLI. If a program attempts to it will be terminated.

TF: the trap flag allows debuggers to single step the CPU when set. You'll never use it unless you find yourself trouble a malfunctioning CPU someday.

SF: sign flag is set when the result of an op forces the operand to become negative (the MSB sign bit becomes 1). Any op that makes the sign positive will clear SF.

ZF: the zero flag is set when the result of an operation is zero. This is used a lot for conditional jumps.

AF: the auxiliary carry flag is used for BCD arithmetic. 

PF: the parity flag indicates whether the number of set bits in the low-order byte of a result is even or odd. It is on if it is even and off if it is not.
    This is relavant to hamming codes, but this flag is obsolete and was primarily used for serial port communication. I guess thats why it only checks low order bits.
    
CF: the carry flag is used in unsigned arithmetic ops already familar with this from the 8TIAC.

Everything just summerized about flags is super general and should not be taken as gospel. I guess these have been used in a lot of weird ways over the years and a lot of 
instructions will affect them differently.


### Conditonal Jumps
This is how flow control is handled at the lowest level.

JNZ: Jump if not zero test the ZF flag. If ZF is set(1) nothing happens if ZF is unset(0) then execution moves to the label specified in the JNZ instruction.
Labels: descriptive names given to locations in your program. In NASM a label is a character string followed by a colon.

MOVSX: exchange a signed value between registers of different size. So it can move a 16 bit negative val to a 32 bit reg and retain the sign.
r32, r12, r8, are shorthand for xbit register r32 = any 32 bit register. The notation r/m means register or memory. Combining them r/m16 means any 16 bit register or memory location.

Certain instructions have implicit and explicit operands than can be misleading.

MUL: multiply unsigned vals. This is one of the instructions with implicit operands. The syntax is simply mul r8 but the implicit idea is that you will be multipling by the 
value in the lower 8bits of AX name AL and the product will be stored in AX. This is why AX is called the accumulator in x86. This is all based off the fact that the largest
product of two binary numbers will by twice the bits of the factors (just think about 2^8 * 2^8). Similarly for mul r16 implicit args would be ax and DX and AX for the product (EAX).
Not so similary mul r32 implicits are EAX and EDX and EAX for the product.

DIV: divide unsigned vals. DIV is similar to mul with all the implicit arguments. Basically you specify a value in a register to divide the value in EDX( or AL or AX, etc based on size). You can also hold a 64bit value in EAX and EDX and DIV r32 will divide the value in
the two registers. Zero division errors are a thing in assembly. Attemping to divide by zero OR divide zero by anything will get your program whacked by linux. You must test your values before attemping a division.

IMUL: multiply signed vals

IDIV: divide signed vals

NEG: negates the value of the operand. Can also be used on a memory location but you must specify a byte size such as NEG word [BX] 

There are sometimes different legal cases for instructions. POP AX vs POP SI for example. Be aware that each legal case is actually a different opcode 058h vs 05Eh for the previous example.
Legal forms are described in the x86 manuals.


# Chapter 8 Creating Programs That Work

#### Header Comments contain
-Name of the file
-Name of the exe file
-Date created
-Date last modified
-Author
-Name of assembler version used to create it
-Overview of what the program does
-Commands used to build the file

## Sections

Sections should be laid out in the order of .data, .bss, then .text
### .data
definitions of initialized data items. These are basically variables. Their definition in the data section means they will be loaded to memory with the program.
This effectivly means no instructions or will be used to create them so no cycles are wasted to load them. Since these are stored with the executable the more you have
the larger the exe.

### .bss
Data buffers are defined in the .bss section. You set aside a number of bytes for buffers and give the buffers names but you don't say what will be stored there yet.

A key difference between this and the data section is that this section takes no extra space in your executable.

### .text
This is where are your actual written machine instructions should be placed in the file.

## Labels
Bookmarks for program code. Identifies locations for jumps and calls. Must begin with a letter, underscore, period, or question mark (random but okay).
Labels must be followed by a colon when they are defined. The colon is only used in the definition not when you are specifing a label for a jump. They are case sensitive.

Every linux assembly program must be marked with a "\_start" label. It is case sensitive. It must be marked global at the top of the text section.

## Variables
A variable is defined by associating an identifier with a *data definition directive*.

Examples
mibite db 07h ;8 bits
myword db 077ffh ;16 bits
mydouble dd 0ff0077ffh ;32 bits

d\<x> can be thought of as define\<byte|word|dword|etc>

Strings are a sequence of characters in a row in memory. Their definition is a bit irregular since normally definition sets aside a specific amount of memory.
Instead when a string is defined db simply sets a aside one byte that points to its starting location.

Example: mystring = db "this is a strings contain it's",10

Notice the single quote means the string must be delimited with double quotes. The 10 at the end is simply the value of EOL in linux or more familiarly '\n' char in ASCII.
Its definition as the linux EOL is little confusing when thinking about what C defines as the EOL char.

Example TwoLines: db "This is one line ...", 10, "... and this is another!", 10

You may define strings with other data types, but the treatment is a little different.

WS: dw 'CQ' ;defines a two byte string. In this case WS is not simply a pointer to the start
DDS: dd 'Stop' ; similar to WS but using the double type allows for 4 chars of storage.

This allows you to load the actual string into a register instead of just a pointer to it. Actully using this is rare apparently.


EQU: equate associates a value with a label. Anytime an equate is encountered during assembly the equ's name is swapped for its value. So basically a C macro.

example: EatLen: equ $-EatMsg ; equates the EatLen var with the length of eat msg
         FieldWidth equ 10; anywhere the FieldWidth label is used it will be swapped with 10

The dollar sign $ is the "here" token. 

Here token $: This is interesting. $ marks the spot where NASM is in the intermediate file (not the source file). The label EatMsg marks the beginning of the string.
When NASM reaches the EatLen label the val of $ is the location immediately after the last character of EatMsg. This is an example of an assembly time calclulation.
So $-EatMsg is not some magical syntax it is just a subtraction. Namely you are subtracting the pointer at the start of the string from the pointer at the end of the string.

### The Stack
The x86 stack is a LIFO data structure. Chunks of data are pushed onto the top of the stack and they remain on the stack until we pull them off in reverse order.
The Stack exists in memory and is in fact a way of managing memory. Normal stack ops push, pop work as expected.

ESP Register: This is the stack pointer. It holds the memory address of the last item pushed onto the stack.

The stack can visualized as growing downward. It starts at the ceiling and as data is pushed to it, it grows downward.

Linux organizes the memory allocated to your program more or less like this.
1. The Stack
2. Free Memory
3. .bss
4. .data
5. .text

ESP always points to the last item in the stack and moves up and down as items are pushed and popped from the stack.

#### Push Instrutions
PUSH: push a 16 or 32 bit reg or mem value that is specified in your source code.
PUSHF: push the 16 bit flags register to the stack
PUSHFD: pushed the 32 bit flags reg to the stack
PUSHA: push all eight of the general purpose registers onto the stack.
PUSHAD: push all eight of the 32 bit general purpose register to the stack.

You cannot push a 8 bit register onto the stack.
### Pop commands
popf      ; Pop the top 2 bytes from the stack into Flags
popa      ; Pop the top 16 bytes from the stack into AX, CX, DX, BX,
; BP, SI, and DI...but NOT SP!
popad     ; Pop the top 32 bytes from the stack into EAX, ECX, EDX, EBX,
; EBP, ESI and EDI...but NOT ESP!!!
pop cx    ; Pop the top 2 bytes from the stack into CX
pop esi   ; Pop the top 4 bytes from the stack into ESI
pop [ebx] ; Pop the top 4 bytes from the stack into memory at EBX

how much you pop from the stack depends on your arguments. If you pop to a 16 bit register you will take the top two bytes.

POP Process:
1. the data at [ESP] is copied from the stack and placed in pops operand
2. ESP is incremented by the size of the operand. This means ESP moves either two or four bytes up the stack.

ESP is decremented **Before** placing a word on the stack at push time, but incremented **after** removing a word at pop time.
**Unless the stack is completely empty SP points to real data.** 

### Software Interrupts
Kernal Service Call Gate: A gateway between user and kernal space. This allows you to call service routines in linux.
It is implemented via software interrupts.

At the start of memory (segment 0 offset 0), there is a special lookup table with 256 entries. Each entry is a complete memory address to include segment and offset for a total of 4 bytes (so probably 64 in x86).
The first 1024 bytes in any x86 machine are reserved for this table. Each address in the table is an interrupt vector numbered from 0 to 255. Vector 0 is bytes 0-3 in the table.
The number of the interrupt holds a particular address. 80h points to the **service dispatcher**.

When INT 80h is called linux will jump program to the execution of the interrupt vector located at 80h, but the service dispatcher controls a ton of services and you have to specify which one you want.
The service dispatcher knows what service want by checking the EAX register for the service number. Beyond that different services will expect different things in different registers
in order to do what is asked of them.

```
imov eax,4        ; Specify sys_write syscall
mov ebx,1        ; Specify File Descriptor 1: Standard Output
mov ecx,EatMsg   ; Pass offset of the message
mov edx,EatLen   ; Pass the length of the message
int 80H          ; Make syscall to output the text to stdout
```

The INT command also stores the location of the next machine instruction on the stack before handing execution to the kernal. The kernal hands control back to the userspace
program by poping that address from the stack and jumping to it.

**Exiting a program**
```
mov eax,1         ; Specify Exit syscall
mov ebx,0         ; Return a code of zero
int 80H           ; Make the syscall to terminate the program
```



We'll be working under Linux.

The data exists in disk files.

We do not know ahead of time how large any of the files will be.

There is no maximum or minimum size for the files.

We will use I/O redirection to pass filenames to the program.

All the input files are in the same encoding scheme. The program can assume that an "a" character in one file is encoded the same way as an "a" in another file. (In our case, this is ASCII.)

We must preserve the original file in its original form, rather than read data from the original file and then write it back to the original file. (That's because if the process crashes, we've destroyed the original file without completely generating an output file.)



## Chapter 9 Bits, Flags, Branches, and Tables
Shift vs Rotate: Shift instructions dump any overflow to the carry bit. If you want to do something with said bit you must do it before executing an instruction that affects the carry flag.
Rorates do not push overflow to the void the over flowbits are put at the beggining of the string.

Rotate Instructions: RCL, RCR, ROL

Conditional jump instructions usually have a counterpart that jumps in the absence of the condition. For example the counterpart of JZ (jump if zero) is JNZ (jump if not zero)
JZ jumps when the zero flag is set and JNZ jumps if the zero flag is not set.

More jumps: JLE(jump if less than or equal to) == JNG(jump if not greater)

Signed and unsigned values have different comparison operators. 
Signed = *greater than or less then* JG after a compare.
Unsigned = *above or below* JA after a compare

BT(bit test) moves the value of the specified bit in its first operand to the carry flag. This can be useful for testing single bits. BT eax, 4 tests bit 4 in eax.

LEA: Load effective address. This instruction calculates and effective address given between the brackets of its source operand and loads that address into any 32bit gp reg given as its second operand.
     lea has a less than intended second usage. It can do some math for us without like multiplication without shifts adds or muls.

     a process like
     ```
     mov edx, ecx ; copy char counter to edx
     shl edx, 1 ;mult by two
     add edx, ecx ;add ecx to finish mult by 3
     ```
     can be simplified to
     ```
     mov edx, ecx ;copy char counter to edx
     lea edx, [edx*2+edx] ;mult edx by 3
     ```

Using the 16 or 8bit registers (probably the 32 bit ones now that 64bit is the norm) is actually slower then using the 32bit registers. the opcode generated by nasm to access it will
take longer to process. This is only when you explicitly reference it in your code however. Using 32bit (now 64bit) registers is preferable but its not gonna kill your code so dont 
stress about it to much.

XLAT: this is instruction is hard coded to use registers in certain ways and can be used conviently with a translation table. 
      To use xlat: The address of the table must be in ebx, the char to be translated must be in al, the translated char will be returned to al.


# Chapter 10 Divide and Conquer
Procedure: Procedures are similar to functions in higher level languages. They are a block of instructions containing a label and RET instruction.
           The label like other labels denotes the beginning of the block but instead jumping to it the block is accesed via a CALL instruction.

Call: call simply moves execution to the procedures block. Its only operand is the label of the procedure.

RET: ret is the mandatory part of a procedure that makes it a procedure. When ret is reached in a procedure execution moves to the instruction
     immediately after the initial call instruction. 

The process of call and ret works like this. CALL firwst pushes the address of the instruction proceding it onto the stack, then CALL moves execution
to the address of the procedure label. After the procedure executes the RET instruction pops the address from the stack and moves execution to it.
Anything you can do in the main program you can do in a procedure this includes calling other procedures and making system calls.

It is always a good idea to save the value of the registers that a procedure modifies before executing the procedure. A good way to do this is
push the registers to stack before you execute and then pop them back before you return. **Remember you must pop registers from the stack in the reverse order that you pushed them**.


#### Global vs Local Data
Local is data that is accessible only to a particular procedure or in some cases a library. It is almost always data that is placed on the stack
when a procedure is called. When your program calls a procedure it can pass data down to that by procedureby using push one or more times before
the call instruction. The procedure can access these items how you can imagine, *but you must be aware the return address is in front of these items.*

#Chapter 11 Strings and Things

Strings in assembly are not just a collection of printable characters. They are still most similar to cstrings, but not really. In assembly *a string is any contiguous group of bytes in memory* 
of any arbitratry size that the OS allows.

### String Instruction Assumptions
A source string is pointed to by ESI
A destination string is pointed to by EDI
The length of both kinds of strings is the value you place in ECX. How this length is acted upon by the CPU depends on the specific instruction and how its being used.
Data coming from a source string or going to a destination string must begin the trip from, end the trip at, or pass through register EAX.

The names of ESI and EDI can lend some context to these rules. ESI = "extened source index", EDI = "extended destination index"
