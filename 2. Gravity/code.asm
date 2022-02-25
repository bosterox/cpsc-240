extern fgets
extern printf
extern scanf
extern stdin
extern strlen

;; constants
INPUT_LEN equ 100

;; symbol to expose to C
global my_asm_program

;; declare initialized data blocks
segment .data
gravity: dq 0x402399999999999A ; Earth's grav. acceleration constant: 9.8 m/s^2
str_intro: db `--- Drop Time Calculator ---\n`, 0
str_prompt_name: db `Greetings. Please enter your first and last name: `, 0
str_prompt_occupation: db `Hello %s! Please enter your occupation: `, 0
str_prompt_height: db `Thank you %s. Now, please enter the height (in meters) from which you are dropping something: `, 0
str_result: db `From %lf meters up, it will take %lf seconds to hit the ground.\n`, 0

str_input_double: db `%lf`, 0
str_input_string: db `%s`, 0

str_error_negative: db `Height value must be positive.\n`, 0
str_error_generic: db `Invalid input. Please try again.\n`, 0

;; declare uninitialized data blocks
segment .bss
inp_name: resb INPUT_LEN
inp_occupation: resb INPUT_LEN

segment .text
my_asm_program:
    push rbp
    mov rbp, rsp
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push rbx
    pushf
    ;; end register-saving boilerplate

    ;; --- INTRO TEXT ---
    mov rdi, str_intro
    call printf

    ;; -- NAME --
    mov rdi, str_prompt_name
    call printf

    mov rdi, inp_name
    mov rsi, INPUT_LEN
    mov rdx, [stdin]
    call fgets

    ; replace trailing \n with \0 in inp_name
    mov rax, 0
    mov rdi, inp_name
    call strlen ; rax = length of string in rdi
    sub rax, 1 ; index of final character (\n)
    mov byte [inp_name + rax], 0

    ;; -- OCCUPATION --
    mov rdi, str_prompt_occupation
    mov rsi, inp_name
    call printf

    mov rdi, inp_occupation
    mov rsi, INPUT_LEN
    mov rdx, [stdin]
    call fgets

    ; replace trailing \n with \0 in inp_occupation
    mov rax, 0
    mov rdi, inp_occupation
    call strlen ; rax = length of string in rdi
    sub rax, 1 ; index of final character (\n)
    mov byte [inp_occupation + rax], 0

    mov rdi, str_prompt_height
    mov rsi, inp_occupation
    call printf

    ;; -- NUMBER --
    push qword 0 ; store input on stack
    mov rdi, str_input_double
    mov rsi, rsp
    call scanf

    ;; -- VALIDATE INPUT --
    ; if valid value entered, rax = 1. else, rax = 0.)
    mov rdi, 0
    cmp rdi, rax
    je error_input

    ; check if negative entered
    movsd xmm15, [rsp] ; xmm15 = user input
    mov rax, 0
    cvtsi2sd xmm14, rax ; xmm14 = 0
    cmpsd xmm14, xmm15, 1 ; xmm14 = xmm15 > 0 ? FFFFFF : 0
    mov rax, 0
    cvtsd2si rdi, xmm14
    cmp rdi, rax
    je error_negative

    ; -- CALCULATE AND PRINT --
    ; t = sqrt(2h/g)
    mov rax, 2
    cvtsi2sd xmm14, rax
    mulsd xmm15, xmm14
    movsd xmm14, [gravity]
    divsd xmm15, xmm14
    sqrtsd xmm15, xmm15 ; xmm15 = final result
    
    ; printing
    mov rax, 2 ; 1 xmm-reg
    movsd xmm0, [rsp]
    movsd xmm1, xmm15
    mov rdi, str_result
    call printf

    ; return the desired calculation
    movsd xmm0, xmm15
    mov rax, 1
    jmp exit

error_input:
    mov rdi, str_error_generic
    jmp print_string_exit

error_negative:
    mov rdi, str_error_negative
    jmp print_string_exit

print_string_exit:
    call printf
    mov rax, -1 ; non-zero exit
    jmp exit

exit:
    pop rdi ; double number input (not using rax 'cause it's my return code)
    popf
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbp
    ret ;  return