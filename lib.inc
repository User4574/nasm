STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ equ 0
SYS_WRITE equ 1

%macro exit 1
  mov rax, 60
  mov rdi, %1
  syscall
%endmacro

%macro DEBUG 0
  push rax
  mov rax, debug
  call println
  pop rax
%endmacro

section .data
  newline db 10, 0
  debug db "Here", 0

section .bss
  text resb 128

section .text
  global _start

; atoi turns a string into a number
; expects decimal
; stops when a char is not an ascii digit
; input: string addr in rax
; output: number in rax
atoi:
  ;preserve registers
  push rcx
  push rbx

  mov rcx, 0 ;rcx will be our result

_atoiloop:
  ;are we at the end?
  cmp [rax], byte 48
  jl _atoiend

  cmp [rax], byte 57
  jg _atoiend

  ;multiply result by 10
  push rax
  mov rax, rcx
  mov rbx, 10
  mul rbx
  mov rcx, rax
  pop rax

  ;subtract 48 from char, add to rcx
  mov bl, byte [rax]
  sub bl, 48
  add rcx, rbx
  inc rax

  ;loop
  jmp _atoiloop
  
_atoiend:
  mov rax, rcx
  ;restore before returning
  pop rbx
  pop rcx
  ret

; itoa turns a number into a 0t string
; input: number in rax
; output: string addr in rax
itoa:
  push rdx
  push rcx
  push rbx

  push rax
  mov rbx, 10
  mov rcx, text

_itoacount:
  cmp rax, 0
  je _itoawrite

  cqo
  div rbx
  inc rcx
  jmp _itoacount

_itoawrite:
  mov [rcx], byte 0
  pop rax
_itoawriteloop:
  dec rcx
  cqo
  div rbx
  add rdx, 48
  mov [rcx], dl

  cmp rcx, text
  jne _itoawriteloop

  mov rax, text

  pop rbx
  pop rcx
  pop rdx
  ret

; print displays a 0t string
; input: text addr in rax
print:
  push rcx
  push rax
  push rdi
  push rsi
  push rdx
  mov rdx, 0

  mov rsi, rax
_printcount:
  cmp [rax], byte 0
  je _printdisp

  inc rax
  inc rdx
  jmp _printcount

_printdisp:
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  syscall

  pop rdx
  pop rsi
  pop rdi
  pop rax
  pop rcx
  ret

; println displays a 0t string followed by a newline
; input: text addr in rax
println:
  push rax

  call print

  mov rax, newline
  call print

  pop rax
  ret


gets:
  push rcx
  push rdi
  push rsi
  push rdx

  mov rax, SYS_READ
  mov rdi, STDIN
  mov rsi, text
  mov rdx, 128
  syscall

  pop rdx
  pop rsi
  pop rdi
  pop rcx
  mov rax, text
  ret
