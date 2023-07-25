all:
	as -g -march=rv64i main_sine.s -o main_sine.o
	as -g -march=rv64i sine.s -o sine.o
	size sine.o

	ld -g sine.o main_sine.o -o ./solution

clean:
	rm ./*.o
	rm ./solution

