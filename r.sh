# Author Information
# Author name: Thomas Nguyen
# Author Email: thomas1003nguyen@gmail.com
# Author Section: 240-3
# Author CWID 885287615

#Delete some un-needed files
rm *.o
rm *.out

# Assembles area.asm
nasm -f elf64  -l compute_triangle.lis -o compute_triangle.o compute_triangle.asm

# Assembles isfloat.asm
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

# Compiles triangle.c
gcc  -m64  -Wall -no-pie -o main.o -std=c2x -c main.c

# Linker for the object files
gcc -m64 -no-pie -o a.out compute_triangle.o isfloat.o main.o -lm -std=c2x -Wall -z noexecstack

# Runs the program
chmod +x a.out
./a.out

