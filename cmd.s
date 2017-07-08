STDOUT equ 1
SYS_WRITE equ 1

%macro exit 1
  mov rax, 60
  mov rdi, %1
  syscall
%endmacro

section .data
  newl db 10

section .text
  global _start

_start:
  pop rax
_loop:
  cmp rax, 0
  je _end
  pop rbx
  call printrbx
  dec rax
  jmp _loop
_end:
  exit 0

printrbx:
  push rax

  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, rbx
  call countrbx
  syscall

  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, newl
  mov rdx, 1
  syscall

  pop rax
  ret

countrbx:
  push rbx
  mov rdx, 0

_countrbxloop:
  cmp [rbx], byte 0
  je _countrbxend
  inc rbx
  inc rdx
  jmp _countrbxloop
  
_countrbxend:
  pop rbx
  ret
