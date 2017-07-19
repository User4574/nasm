%include "lib.inc"

_start:
  call gets
  mov rax, text
  call println
  exit 0
