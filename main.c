//Author: Thomas Nguyen
//Author email: thomasn1003@csu.fullerton.edu
//Program name: main
//Programming languages: One module in C, two in X86, and one in bash.
//Date program began: 2024-Feb
//Date of last update: 2024-Feb-24
//Files in this program: main.c, compute_triangle.asm, isfloat.asm, r.sh


//Purpose of this program:
// This program calculates the 3rd length of a triangle given 2 sides and an angle

//This file
//  File name: main.c
//  Language: C language, 202x standardization where x will be a decimal digit.
//  Max page width: 124 columns
//  Compile: gcc  -m64  -Wall -no-pie -o main.o -std=c2x -c main.c
//  Link: gcc -m64 -no-pie -o a.out compute_triangle.o isfloat.o main.o -lm -std=c2x -Wall -z noexecstack


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h> 

extern double compute_triangle();

int main(int argc, const char* argv[]) 
{
    printf("Welcome to Amazing Triangles programmed by Thomas Nguyen on February 24, 2024\n");
    double result = 0.0;
    result = compute_triangle();  
    printf("The driver received this number %0.2lf and will simply keep it.\n", result);
    printf("An integer zero will now be sent to the operating system. Bye\n\n");
    return 0;
}