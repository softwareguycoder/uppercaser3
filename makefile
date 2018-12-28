uppercaser3: uppercaser3.o
	ld -o uppercaser3 uppercaser3.o
uppercaser3.o: uppercaser3.asm
	nasm -f elf64 -g -F stabs uppercaser3.asm -l uppercaser3.lst
clean:
	rm -f *.o *.lst uppercaser3
