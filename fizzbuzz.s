%include "lib.inc"

section .data
  fizz db "Fizz", 0
  buzz db "Buzz", 0

section .text

divtest:
  cqo
  div rbx
  cmp rdx, 0
  ret

fizzbuzz:
  push rbx
  push rcx
  push rax
  mov rcx, 0

  mov rbx, 3
  call divtest
  jne _fizzbuzznofizz
  mov rax, fizz
  call print
  inc rcx
_fizzbuzznofizz:

  pop rax
  push rax

  mov rbx, 5
  call divtest
  jne _fizzbuzznobuzz
  mov rax, buzz
  call print
  inc rcx
_fizzbuzznobuzz:

  cmp rcx, 0
  jne _fizzbuzzend
  pop rax
  push rax
  call itoa
  call print

_fizzbuzzend:
  mov rax, newline
  call print
  pop rax
  pop rcx
  pop rbx
  ret

_start:
  pop rax
  cmp rax, 2
  jne _end
  pop rax
  pop rax
  call atoi
  inc rax
  mov rbx, rax
  mov rax, 1

_loop:
  cmp rax, rbx
  je _end
  call fizzbuzz
  inc rax
  jmp _loop

_end:
  exit 0
