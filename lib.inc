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

section .data
  newline db 10
  debug db "Here", 0

section .bss
  text resb 128
  tp resb 8

section .text
  global _start

; atoi turns a 0t string into a number
; input: string addr in rax
; output: number in rax
atoi:
  ;preserve registers
  push rcx
  push rbx

  mov rcx, 0 ;rcx will be our count

_atoiloop:
  cmp [rax], byte 0 ;are we at the end?
  je _atoiend

  ;multiply result by 10
  push rax
  mov rax, rcx
  mov rbx, 10
  mul rbx
  mov rcx, rax
  pop rax

  ;subtract 48 from char, add to rcx
  mov rbx, [rax]
  sub rbx, 48
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
  push rax
  mov rbx, 10
  mov rcx, text

_itoacount:
  cmp rax, 0
  je _itoawrite

  mov rdx, 0
  div rbx
  inc rcx
  jmp _itoacount

_itoawrite:
  inc rcx
  mov [rcx], byte 0
  pop rax
_itoawriteloop:
  dec rcx
  div rbx
  mov [rcx], dl

  cmp rcx, text
  jne _itoawriteloop
  ret

; println displays a 0t string followed by a newline
; input: text addr in rax
println:
  push rax
  push rdi
  push rsi
  push rdx
  mov rdx, 0

  mov rsi, rax
_printlncount:
  cmp [rax], byte 0
  je _printlndisp

  inc rax
  inc rdx
  jmp _printlncount

_printlndisp:
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  syscall

  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, newline
  mov rdx, 1
  syscall

  pop rdx
  pop rsi
  pop rdi
  pop rax
  ret
