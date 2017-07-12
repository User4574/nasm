INC=lib.inc

%: %.o
	ld $< -o $@

%.o: %.s ${INC}
	nasm -felf64 -g $< -o $@

.SUFFIXES:
