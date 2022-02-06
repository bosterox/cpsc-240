extern printf   ; includes printf
extern scanf    ; includes scanf 

; constants
INPUT_LEN equ 64
MATH_EXPRESSION equ 24 * INPUT_LEN

;; symbol to expose to C
global my_asm_program

;; declared data blocks
segment .data
prompt_name: db "It's me, a string.", 0 ; <--- null terminator

;; declared uninitialized data blocks
segment .bss
user_name: resb INPUT_LEN ;; char user_name[INPUT_LEN]

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

    mov rax, 'd'

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