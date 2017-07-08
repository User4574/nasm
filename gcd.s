STDOUT equ 1
SYS_WRITE equ 1

%macro exit 1
  mov rax, 60
  mov rdi, %1
  syscall
%endmacro

section .data
  a db 42
  b db 56

section .bss
  text resb 16
  tp resb 8

section .text
  global _start

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

printrax:
  mov rcx, text
  mov rbx, 10
  mov [rcx], rbx
  inc rcx
  mov [tp], rcx
_printRAXLoop:
	mov rdx, 0
	mov rbx, 10
	div rbx
	push rax
	add rdx, 48
	mov rcx, [tp]
	mov [rcx], dl
	inc rcx
	mov [tp], rcx
	pop rax
	cmp rax, 0
	jne _printRAXLoop
_printRAXLoop2:
	mov rcx, [tp]
	mov rax, 1
	mov rdi, 1
	mov rsi, rcx
	mov rdx, 1
	syscall
	mov rcx, [tp]
	dec rcx
	mov [tp], rcx
	cmp rcx, text
	jge _printRAXLoop2
	ret

_start:
  mov rax, [a]
  mov rbx, [b]
  call gcd
  call printrax

  exit 0
