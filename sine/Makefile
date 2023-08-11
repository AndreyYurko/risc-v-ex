all:
	as -g -march=rv64i main_sine.s -o main_sine.o
	as -g -march=rv64i sine.s -o sine.o
	size sine.o

	ld -g sine.o main_sine.o -o ./solution

test:
	as -g -march=rv64imafd sine.s -o sine.o
	gcc -o test_program test_program.c sine.o -march=rv64imafd	

clean:
	rm ./*.o
	rm ./solution

