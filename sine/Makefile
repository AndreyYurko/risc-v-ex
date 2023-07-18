all:
	as -g -march=rv64i main_sine.s -o main_sine.o
	as -g -march=rv64i sine.s -o sine.o
	as -g -march=rv64i mult.s -o mult.o
	as -g -march=rv64i summ.s -o summ.o
	as -g -march=rv64i div.s -o div.o
	size sine.o mult.o summ.o div.o

	ld -g div.o mult.o summ.o sine.o main_sine.o -o ./solution

clean:
	rm ./*.o
	rm ./solution

