extern printf
extern scanf

;; constants
INPUT_LEN equ 100

;; symbol to expose to C
global my_asm_program

;; declare initialized data blocks
segment .data
gravity: dq 0x411cf5c3 ; Earth's grav. acceleration constant: 9.81 m/s^2
str_intro: db `--- Drop Time Calculator ---\nEnter the height (in meters) from which you are dropping something: `, 0
str_result: db `From %lf meters up, it will take %lf seconds to hit the ground.\n`, 0

;; declare uninitialized data blocks
segment .bss
str_height: resb INPUT_LEN

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

    ;; --- INTRO TEXT ---
    mov rdi, str_intro
    call printf

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