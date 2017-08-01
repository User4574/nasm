%include "lib.inc"

section .data
  prompt db "> ", 0
  overflow db "TOO LARGE", 0

section .text

fun:
  cqo
  mov rbx, 5
  mul rax
  mul rax
  mul rbx
  ret

_start:
  mov rcx, 11

_getnums:
  mov rax, prompt
  call print

  call gets
  call atoi
  push rax

  dec rcx
  cmp rcx, 0
  jne _getnums

  mov rcx, 11
_loop:
  pop rax

  call fun

  cmp rax, 400
  jg _over
  call itoa
  call println
  jmp _next
_over:
  mov rax, overflow
  call println

_next:
  dec rcx
  cmp rcx, 0
  jne _loop

_end:
  exit 0
