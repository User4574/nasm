%: %.o
	ld $< -o $@

%.o: %.s
	nasm -felf64 -g $< -o $@

.SUFFIXES:
