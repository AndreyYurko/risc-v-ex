all:
	as -g -march=rv64i main_sine.s -o main_sine.o
	as -g -march=rv64i sine.s -o sine.o
	as -g -march=rv64i mult.s -o mult.o
	as -g -march=rv64i summ.s -o summ.o
	size sine.o

	ld -g mult.o summ.o sine.o main_sine.o -o ./solution

clean:
	rm ./*.o
	rm ./solution

