// printUname.c
// John Schwartzman, Forte Systems, Inc.
// 05/10/2019
// x86_64
// assemble uname.asm:  yasm -f elf64 -g dwarf2 -o uname.obj uname.asm
// compile and link:    gcc -g printUname.c uname.obj -o printUname
// to execute:          ./printUname

int printUname();   // declaration of printUname

int main(void)
{
    return printUname();
}
   