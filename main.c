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
    printf("The driver received this number %0.2lf and will simply keep it.\n", result)
    printf("An integer zero will now be sent to the operating system. Bye\n\n");
    return 0;
}