;; Name: Alex Tran (887519064)
;; Section: CPSC 240-07
;; E-mail: altran@csu.fullerton.edu

extern printf
extern scanf
extern noroots
extern oneroot

;; constants
INPUT_LEN equ 100

;; symbol to expose to C
global roots

;; declare initialized data blocks
segment .data
prompt: db `Hello.\nPlease enter three quadratic coefficients (a, b, c), each separated by a space.\n`, 0
strf_input: db "%lf %lf %lf", 0
strf_show_vals: db `a = %lf    b = %lf    c = %lf\n`, 0
strf_tworoots_print: db `The roots of the equation are %lf and %lf.\n`, 0

;; declare uninitialized data blocks
segment .bss
user_name: resb INPUT_LEN ;; char user_name[INPUT_LEN]

segment .text
roots:
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

    ; [Retrieve values from user]
    call get_coeff ; prompt
    call display_values ; input

    ; xmm15 = a
    ; xmm14 = b
    ; xmm13 = c

    ; [Calculate radicand]
    movsd xmm12, xmm14
    mulsd xmm12, xmm12 ;; xmm12 = b^2

    movsd xmm11, xmm15
    mulsd xmm11, xmm13
    mov rax, -4
    cvtsi2sd xmm10, rax
    mulsd xmm11, xmm10 ;; xmm11 = -4ac
    addsd xmm12, xmm11 ;; xmm12 = radicand

    ; CASE 1: radicand < 0? no roots
    mov rax, 0
    cvtsi2sd xmm11, rax ; xmm11 = 0
    movsd xmm10, xmm12 ; xmm10 = temporary_radicand
    cmpsd xmm10, xmm11, 1 ; xmm10 = radicand < 0 ? FFFFFF : 0
    mov rax, 0
    cvtsd2si rdi, xmm10
    cmp rdi, rax
    jnz no_roots

    ; [Calculate values for the next cases]
    ; fraction 
    movsd xmm11, xmm12
    sqrtsd xmm11, xmm11 ; xmm11 = sqrt(radicand)
    movsd xmm10, xmm15 ; xmm10 = a
    mov rax, 2
    cvtsi2sd xmm9, rax
    mulsd xmm10, xmm9 ; xmm10 = 2a
    divsd xmm11, xmm10 ; xmm11 = sqrt(...)/2a
    ; -b
    mov rax, -1
    cvtsi2sd xmm10, rax ; xmm10 = -1
    mulsd xmm10, xmm14 ; xmm10 = -b

    ; CASE 2: radicand = 0? 1 root
    mov rax, 0
    cvtsi2sd xmm9, rax ; xmm9 = 0
    cmpsd xmm9, xmm12, 0 ; xmm9 = (xmm12 == 0 ? FFF... : 0)
    mov rax, 0
    cvtsd2si rdi, xmm9
    cmp rdi, rax
    jnz one_root

    ; CASE 3: radicand > 0, 2 roots
    movsd xmm0, xmm10 ; xmm0 = -b
    addsd xmm0, xmm11 ; xmm0 = -b + fraction
    movsd xmm1, xmm10 ; xmm1 = -b
    subsd xmm1, xmm11 ; xmm1 = -b - fraction
    ; print the two roots
    mov rax, 2
    mov rdi, strf_tworoots_print
    call printf

    jmp exit

;; --Prompts user and gets values for calculation-- ;;
get_coeff:
    ; [Print prompt]
    mov rdi, prompt
    call printf

    ; [Memory setup for getting values from user]
    push qword 0 ; stack alignment
    ; make room for 3 doubles
    push qword 0
    push qword 0
    push qword 0
    mov rsi, rsp ; rsp = a
    mov rdx, rsp
    add rdx, 8 ; rsp+8 = b
    mov rcx, rsp
    add rcx, 16 ; rsp+16 = c

    ; [Get values from user]
    mov rdi, strf_input ; formatted string for inputs
    call scanf

    ; [Put received values into XMM registers for calculations]
    movsd xmm15, [rsp] ; a
    pop rax
    movsd xmm14, [rsp] ; b
    pop rax
    movsd xmm13, [rsp] ; c
    pop rax
    pop rax ; undo rsp line up
    ret

;; -- PRINT STORED VALUES -- ;;
display_values:
    mov rdi, strf_show_vals
    mov rax, 3
    movsd xmm0, xmm15
    movsd xmm1, xmm14
    movsd xmm2, xmm13
    call printf
    ret

no_roots:
    call noroots
    mov rax, 0
    jmp exit

one_root:
    movsd xmm0, xmm11
    movsd xmm1, xmm10
    mov rax, 2
    call oneroot
    jmp exit


exit:
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
    ret