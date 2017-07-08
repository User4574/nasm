STDOUT equ 1
SYS_WRITE equ 1

%macro exit 1
  mov rax, 60
  mov rdi, %1
  syscall
%endmacro

section .data
  text db "Hello, World!", 10

section .text
  global _start

_start:
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, text
  mov rdx, 14
  syscall

  exit 0
