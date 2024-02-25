;****************************************************************************************************************************
;Program name: "Assignment 2 Triangles".  This program serves as a model for programmers of X86 programming language.            *
;This shows the standard layout of a function written in X86 assembly.  The program is a live example of how to compile,    *
;assembly, link, and execute a program containing source code written in X86.  Copyright (C) 2024  Floyd Holliday.          *
;                                                                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
;but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
;the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
;<https://www.gnu.org/licenses/>.                                                                                           *
;****************************************************************************************************************************




;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Thomas Nguyen
;  Author email: thomasn1003@csu.fullerton.edu
;
;Program information
;  Program name: Triangles
;  Programming languages: One module in C, two in X86, and one in bash.
;  Date program began: 2024-Feb-14
;  Date of last update: 2024-Feb-24
;  Files in this program: main.c, compute_triangle.asm, isfloat.asm, r.sh.  At a future date rg.sh may be added.
;  Testing: Alpha testing completed.  All functions are correct.
;
;Purpose
;  This program inputs the lenghts of two sides of a triangle and inputs the size of the angle between
;  those sides. The length of the third side is computed. The three input values are validated by suitable
;  checking mechanism. 
;

;This file:
;  File name: compute_triangle.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64  -l compute_triangle.lis -o compute_triangle.o compute_triangle.asm
;  Assemble (debug): nasm -g dwarf -l compute_triangle.lis -o compute_triangle.o compute_triangle.asm
;  Prototype of this function: unsigned long compute_triangle();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration
extern printf

extern fgets

extern stdin

extern strlen

extern scanf

extern atof

extern cos

extern isfloat

global compute_triangle

name_string_size equ 48
title_string_size equ 48
variable_size equ 4096

segment .data
system_clock_start db "The starting time on the system clock is %lu tics", 10, 10, 0
prompt_your_name db "Please enter your name: ", 0
prompt_your_title db 10, "Please enter your title (Sargent, Chief, CEO, President, Teacher, etc.): ", 0
good_morning db 10, "Good morning %s %s. We take care of all your triangles", 10, 10, 0

prompt_first_length db "Please enter the length of the first side: ", 0
prompt_second_length db "Please enter the length of the second side: ", 0
prompt_angle_size db "Please enter the size of the angle in degrees: ", 0
invalid_input db "Invalid input. Try again:", 0

thank_you db 10,"Thank you %s. You entered %lf %lf and %lf.", 10, 10, 0
result_third_length db "The length of the third side is %1.6lf", 10, 10, 0

send_to_driver db "This length will be sent to the driver program.", 10, 10, 0
system_clock_end db "The final time on the system clock is %lu tics.", 10, 10, 0
good_day db "Have a good day %s %s.", 10,10, 0

test_val db "testing %lf.", 0

val dq 2.0
buf_length_one dq 0.0
buf_length_two dq 0.0
angle dq 0.0
pi dq 3.14159265
one_eydi dq 180.0

segment .bss

align 64
backup_storage_area resb 832

user_name resb name_string_size
user_title resb title_string_size

user_first_length resb variable_size
user_second_length resb variable_size
user_angle resb variable_size

segment .text

compute_triangle:
; Back up GPRs
push    rbp
mov     rbp, rsp
push    rbx
push    rcx
push    rdx
push    rsi
push    rdi
push    r8 
push    r9 
push    r10
push    r11
push    r12
push    r13
push    r14
push    r15
pushf

;Backup the registers other than the GPRs
mov rax,7
mov rdx,0
xsave [backup_storage_area]

;Get the starting amount of tics
cpuid
rdtsc
shl rdx,32
add rdx,rax
mov r12,rdx

;Output starting amount of tics
mov rax, 0
mov rdi, system_clock_start
mov rsi, r12
call printf

;Output prompt for your name
mov rax, 0
mov rdi, prompt_your_name
call printf

;Input your name 
mov rax, 0
mov rdi, user_name
mov rsi, name_string_size
mov rdx, [stdin]
call fgets

;Remove newline
mov rax, 0
mov rdi, user_name
call strlen
mov [user_name+rax-1], byte 0

;Output prompt for your title
mov rax, 0
mov rdi, prompt_your_title
call printf

;Input your title
mov rax, 0 
mov rdi, user_title
mov rsi, name_string_size
mov rdx, [stdin]
call fgets

;Remove newline
mov rax, 0
mov rdi, user_title
call strlen
mov [user_title+rax-1], byte 0

;Output a personalized Good morning message 
mov rax, 0
mov rdi, good_morning
mov rsi, user_title
mov rdx, user_name
call printf

;Output prompt for first length
mov rax, 0
mov rdi, prompt_first_length
call printf
jmp first_length_input

process_first_length:
;Converts string of first length to float
mov rax, 0 
mov rdi, user_first_length
call atof
movsd xmm8, xmm0
jmp prompt_second_input

prompt_second_input:
;Output prompt for second length
mov rax, 0
mov rdi, prompt_second_length
call printf
jmp second_length_input

process_second_length:
;Converts string of second length to float
mov rax, 0
mov rdi, user_second_length
call atof
movsd xmm9, xmm0
jmp prompt_angle_input

prompt_angle_input:
;Output prompt for angle input
mov rax, 0
mov rdi, prompt_angle_size
call printf
jmp angle_input

process_angle:
;Converts string of angle size to float
mov rax, 0
mov rdi, user_angle
call atof
movsd xmm10, xmm0
jmp calculate_triangle


calculate_triangle:
;Move first length float value to xmm12
mov rax, 0
movsd xmm12, [buf_length_one]
movsd xmm12, xmm8


;Moves xmm9 to xmm13
mov rax, 0
movsd xmm13, [buf_length_two]
movsd xmm13, xmm9

;Moves xmm10 to xmm14
mov rax, 0
movsd xmm14, [angle]
movsd xmm14, xmm10

;Personalized thank you message to user
mov rax, 3
mov rdi, thank_you
mov rsi, user_name
movsd xmm0, xmm8 ;stores first side length
movsd xmm1, xmm9 ;stores second side length
movsd xmm2, xmm10 ;stores angle degree
call printf
;movsd xmm12, xmm0 ;stores first side length
;movsd xmm13, xmm1 ;stores second side length


;Convert degree to radian
movsd xmm10, xmm2 ;stores angle degree
mulsd xmm10, qword[pi] ;Mulitiplies angle degree by pi
divsd xmm10, qword[one_eydi] ;Divides pi*angle/180

;Calculates cosine of the angle
mov rax, 1
movsd xmm0, xmm10 ;Moves angle val to xmm2 for cos
call cos
movsd xmm10, xmm0 ;Moves angle val back to xmm10 


;Multiplies 2*b*c*cos(A)
mov rax, 2
movsd xmm11, qword[val]
mulsd xmm11, xmm12
mulsd xmm11, xmm13
mulsd xmm11, xmm10

;Multiply sides by themselves one by one
mov rax, 0
mulsd xmm12, xmm12
mulsd xmm13, xmm13



;Calculate the sum of 2 squres
addsd xmm12, xmm13



;Subtract 2*B*C*cos(A) from sum of 2 squares
subsd xmm12, xmm11

;Square root of sum of square for third side
sqrtsd xmm12, xmm12

;Outputs the third length
mov rax, 1
mov rdi, result_third_length
movsd xmm0, xmm12
call printf


;Outputs length will be sent to the driver program
mov rax, 1
mov rdi, send_to_driver
call printf


;Get system clock final tic time
cpuid
rdtsc
shl rdx,32
add rdx,rax
mov r12,rdx

;Output final amount of tics
mov rax, 0
mov rdi, system_clock_end
mov rsi, r12
call printf


;Output personalized good day note
mov rax, 0
mov rdi, good_day
mov rsi, user_title
mov rdx, user_name
call printf
jmp exit

first_length_input:
;Input first length as a string
mov rax, 0
mov rdi, user_first_length
mov rsi, variable_size
mov rdx, [stdin]
call fgets

;Remove newLine after variable
mov rax, 0
mov rdi, user_first_length
call strlen
mov [user_first_length+rax-1], byte 0

;Check if first length is valid float number
mov rax, 0
mov rdi, user_first_length
call isfloat

;Check contents of rax
cmp rax, 0
je prompt_invalid_input_one
jne process_first_length

second_length_input:
;Input first length as a string
mov rax, 0
mov rdi, user_second_length
mov rsi, variable_size
mov rdx, [stdin]
call fgets

;Remove newLine after variable
mov rax, 0
mov rdi, user_second_length
call strlen
mov [user_second_length+rax-1], byte 0

;Check if first length is valid float number
mov rax, 0
mov rdi, user_second_length
call isfloat

;Check contents of rax
cmp rax, 0
je prompt_invalid_input_two
jne process_second_length

angle_input:
;Input first length as a string
mov rax, 0
mov rdi, user_angle
mov rsi, variable_size
mov rdx, [stdin]
call fgets

;Remove newLine after variable
mov rax, 0
mov rdi, user_angle
call strlen
mov [user_angle+rax-1], byte 0

;Check if first length is valid float number
mov rax, 0
mov rdi, user_angle
call isfloat

;Check contents of rax
cmp rax, 0
je prompt_invalid_input_angle
jne process_angle

prompt_invalid_input_one:
mov rax, 0
mov rdi, invalid_input
call printf
jmp first_length_input

prompt_invalid_input_two:
mov rax, 0
mov rdi, invalid_input
call printf
jmp second_length_input

prompt_invalid_input_angle:
mov rax, 0
mov rdi, invalid_input
call printf
jmp angle_input


exit:
;Gets a copy value of xmm15 and places in rsp before the original is deleted
push qword 0
movsd [rsp], xmm12

;Restore the values to non-GPRs
mov rax, 7
mov rdx, 0
xrstor [backup_storage_area]

;Moves the copy value of xmm15 safely placed in rsp to xmm0 as it returns to driverdistance.c
movsd xmm0, [rsp]
pop rax

;Restore the GPRs
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp
ret
