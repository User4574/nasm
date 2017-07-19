; Sized strings are a string preceeded by its length. This presents a horrible security hole, but hey, what doesn't?

; Preceeding length can be theoretically any length, though here we are limited to the 64 bits of rdx. This is achieved as follows.

; The length is specified in base-127. Any byte where the highest bit is 1 means the length continues in the next byte. Where the bit is 0, it means this is the last byte of the length and the next byte is the first character of the string.

; In the example, the string is 300 characters long, plus one for the newline, hence 0b10000010 0b00101101, which is two 127's and 45 more.

STDOUT equ 1
SYS_WRITE equ 1

%macro exit 1
  mov rax, 60
  mov rdi, %1
  syscall
%endmacro

section .data
  ; text is a sized string
  text db 0x82, 45, "een1ohth0Phuarohwohth4oohool6Rohmeingechaz3gahaf5uchie1pisi7zoojei5fie6sheoH8ais1oghe6dor7UiGh0aefee5aithooX2Rohm9Uu4wuoShoopoiGhohrahChu1Eik8Dik6Iomee9viiveic4ziey3quooNeec8wee5hei4Eithei9kielaiyahkooPhanienooreezoo9shie6xabaech7viehietohf9aeTh7uzeis9oov2eengei6eiphooghuw5xaij0thayaifee7aem1Lae8Ubi", 10

section .text
  global _start

_start:
  mov rax, text
  call ssprint
  exit 0

; ssprint takes a pointer to a sized string in rax and prints it
ssprint:
  call getlen
  mov rsi, rax
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  syscall
  ret

; getlen takes a pointer to a sized string in rax, returns the length in rdx and a pointer to the start of the string in rax
getlen:
  push rbx
  mov rbx, 0
  mov rdx, 0
getlenloop:
  shl rdx, 7
  mov rbx, [rax]
  and rbx, 0x80
  jz getlendone
  mov rbx, [rax]
  and rbx, 0x7f
  add rdx, rbx
  inc rax
  jmp getlenloop
getlendone:
  mov rbx, [rax]
  and rbx, 0x7f
  add rdx, rbx
  inc rax
  pop rbx
  ret
