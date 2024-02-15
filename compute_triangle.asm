extern printf

extern fgets

extern stdin

extern strlen

extern scanf

global average

name_string_size equ 48


segment .data

prompt_your_name db "Please enter your name: ", 0
prompt_your_title db "Please enter your title (Sargent, Chief, CEO, President, Teacher, etc.): ", 0
good_morning db "Good morning %s %s", 0ah, 0ah, 0

prompt_first_length db "Please enter the length of the first side", 0
prompt_second_length db "Please enter the length of the second side", 0
prompt_angle_size db "Please enter the size of the angle in degrees", 0
invalid_input db "Invalid input. Try again:", 0

thank_you db "Thank you %s. You entered %lf %lf and %lf.", 0ah, 0ah, 0ah, 0
result_third_length db "The length of the third side is %lf", 0ah, 0
send_to_driver db "This length will be sent to the driver program.", 0
result_tic_time db "The final time on the system clock is %lf tics.", 0ah, 0
good_day db "Have a good day %s", 0ah, 0

number_input db "%lf", 0


segment .bss

align 64
backup_storage_area resb 832
user_name resb name_string_size
user_title resb name_string_size


segment .text
average:
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

;Input first length
mav rax, 0
mov rdi, number_input
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm8, [rsp]
pop r9
pop r8









 ;Restore the original values to the GPRs
  popf          
  pop     r15
  pop     r14
  pop     r13
  pop     r12
  pop     r11
  pop     r10
  pop     r9 
  pop     r8 
  pop     rdi
  pop     rsi
  pop     rdx
  pop     rcx
  pop     rbx
  pop     rbp

ret