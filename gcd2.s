%include "lib.inc"

section .text

gcd:
  cmp rbx, 0
  je _gcdend
  mov rdx, 0
  div rbx
  mov rax, rbx
  mov rbx, rdx
  jmp gcd
_gcdend:
  ret


_start:
  pop rax
  cmp rax, 3
  jne _end

  pop rax ;dump path

  pop rax
  call atoi
  mov rbx, rax
  pop rax
  call atoi

  call gcd

  call itoa
  call println

_end:
  exit 0
