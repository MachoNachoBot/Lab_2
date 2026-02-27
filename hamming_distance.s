.intel_syntax noprefix

.data
prompt1:
    .ascii "Enter first string: "
len_prompt1 = . - prompt1

prompt2:
    .ascii "Enter second string: "
len_prompt2 = . - prompt2

result_msg:
    .ascii "Hamming Distance: "
len_result_msg = . - result_msg

newline:
    .ascii "\n"

.bss
str1:
    .space 256
str2:
    .space 256
num_buffer:
    .space 16

.text
.global _start

_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [prompt1]
    mov rdx, len_prompt1
    syscall

    mov rax, 0
    mov rdi, 0
    lea rsi, [str1]
    mov rdx, 256
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [prompt2]
    mov rdx, len_prompt2
    syscall

    mov rax, 0
    mov rdi, 0
    lea rsi, [str2]
    mov rdx, 256
    syscall

    lea r8, [str1]
    lea r9, [str2]
    xor r10, r10

compare_loop:
    movzx eax, byte ptr [r8]
    movzx ecx, byte ptr [r9]

    cmp al, 0
    je print_result
    cmp al, 10
    je print_result
    cmp cl, 0
    je print_result
    cmp cl, 10
    je print_result

    xor al, cl

count_bits:
    test al, al
    jz next_char
    
    lea edx, [eax - 1]
    and al, dl
    inc r10
    jmp count_bits

next_char:
    inc r8
    inc r9
    jmp compare_loop

print_result:
    mov rax, 1
    mov rdi, 1
    lea rsi, [result_msg]
    mov rdx, len_result_msg
    syscall

    mov rax, r10
    lea rcx, [num_buffer + 15]
    mov byte ptr [rcx], 0
    mov rbx, 10

convert_loop:
    dec rcx
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov byte ptr [rcx], dl
    test rax, rax
    jnz convert_loop

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    lea rdx, [num_buffer + 15]
    sub rdx, rcx
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall