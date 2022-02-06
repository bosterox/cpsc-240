extern printf
extern scanf
extern cos
extern sin

;; constants (EQU)

;; main code to expose to C
global my_asm_program

;; declared initialized data blocks
segment .data
pi: dq 0x400921FB54442D18
str_prompt: db `--- Triangle Calculations ---\nPlease enter two sides and an angle (deg) all on the same line, each separated by a space.\n`, 0
str_nextline: db `\n`, 0
strf_user_values: db `\nInputted sides %lf and %lf with angle %lf°\n`, 0
strf_answers: db `\nPerimeter: %lf\nArea: %lf\n`, 0

strf_three_doubles: db "%lf %lf %lf", 0

;; declare uninitialized data blocks
segment .bss
perimeter: resq 1
area: resq 1

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

    ;; print prompt
    mov rdi, str_prompt
    call printf

    ;; --- GET DOUBLE VALUES FROM USER ---
    push qword 0 ; ??? extra push explained eventually
    ; make room for 3 doubles
    push qword 0
    push qword 0
    push qword 0
    mov rdi, strf_three_doubles ; address to format str
    mov rsi, rsp ; store 1st result
    mov rdx, rsp ; store 2nd result
    add rdx, qword 8
    mov rcx, rsp; store 3rd result
    add rcx, qword 16
    call scanf

    ; put received values into XMM registers for calculations
    movsd xmm15, [rsp] ; SIDE 1
    pop rax
    movsd xmm14, [rsp] ; SIDE 2
    pop rax
    movsd xmm13, [rsp] ; ANGLE (deg)
    pop rax
    pop rax ; unexplained extra

    ;; --- PRINTING USER'S INPUTED VALUES ---
    mov rdi, strf_user_values
    mov rax, 3
    movsd xmm0, xmm15
    movsd xmm1, xmm14
    movsd xmm2, xmm13
    call printf

    ; convert xmm13 into radians
    movsd xmm12, [pi] ; xmm12 = pi (numerator)
    mov rax, 180
    cvtsi2sd xmm11, rax ; xmm11 = 180 (denominator)
    divsd xmm12, xmm11 ; xmm12 = pi/180
    mulsd xmm13, xmm12 ; -- xmm13 = rad angle --

    ;; -- PERIMETER CALCULATION --
    ; missing side = sqrt(a^2 + b^2 - 2ab*cos(x))

    ; xmm15 = a
    ; xmm14 = b
    ; xmm13 = angle (rad)
    mov rax, 2
    cvtsi2sd xmm12, rax
    mulsd xmm12, xmm15
    mulsd xmm12, xmm14 ; xmm12 = 2ab

    movsd xmm11, xmm15
    mulsd xmm11, xmm11 ; xmm11 = a^2

    movsd xmm10, xmm14
    mulsd xmm10, xmm10 ; xmm10 = b^2
    
    ; cos(x)
    movsd xmm0, xmm13
    call cos ; xmm0 = cos(x)
    
    mov rax, -1
    cvtsi2sd xmm9, rax
    mulsd xmm9, xmm12 ; xmm9 = -2ab
    mulsd xmm9, xmm0 ; xmm9 = -2ab*cos(x)
    addsd xmm9, xmm10
    addsd xmm9, xmm11 ; xmm9 = a^2 + b^2 - 2ab*cos(x)
    sqrtsd xmm9, xmm9 ; xmm9 = missing side

    addsd xmm9, xmm15
    addsd xmm9, xmm14; --- xmm9 = perimeter ---
   
    movsd [perimeter], xmm9 ; store for later

    ;; -- AREA CALCULATION --
    ; area = [a*b*sin(x)]/2

    ; xmm15 = a
    ; xmm14 = b
    ; xmm13 = angle (rad)
    movsd xmm0, xmm13
    call sin ; xmm0 = sin(x)

    movsd xmm12, xmm0
    mulsd xmm12, xmm15
    mulsd xmm12, xmm14
    mov rax, 2
    cvtsi2sd xmm11, rax
    divsd xmm12, xmm11 ; xmm12 = area
    movsd [area], xmm12

    ;; -- PRINTING FINAL RESULT --
    movsd xmm0, [perimeter]
    movsd xmm1, [area]
    mov rdi, strf_answers
    mov rax, 2
    call printf

    mov rax, 0 ; return code 0

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