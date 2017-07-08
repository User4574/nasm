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
  ;pop rax
  ;cmp rax, 3
  ;jne _end
;
  ;pop rax ;dump path
;
  ;pop rax
  ;call atoi
  mov rax, 12
  call itoa
  call println
  ;mov rbx, rax
  ;pop rax
  ;call atoirax

  ;call gcd
  ;call printrax

_end:
  exit 0
