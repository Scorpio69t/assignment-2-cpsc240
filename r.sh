nasm -f elf64  -l compute_triangle.lis -o compute_triangle.o compute_triangle.asm

gcc  -m64  -Wall -no-pie -o main.o -std=c2x -c main.c

gcc -m64 -no-pie -o learn.out compute_triangle.o main.o -std=c2x -Wall -z noexecstack

chmod +x learn.out
./learn.out