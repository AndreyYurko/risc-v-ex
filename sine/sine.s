.globl sine

default_answer = 0x312d

.section .data
# if you need some data, put it here
ra_storage:
.align 8
.space 24


.section .text

# Sine
#   Params
#	a1 -- input buffer will contain string with the argument
#	a2 -- output string buffer for the string result
sine:
	# implement here

	li a3, 0
	li a5, 16
	la t0, ra_storage
loop:
	# shift a3 4 bits to the left - each 4 bits are decimal number
	slli a3, a3, 4

	# read char
	lbu a4, 0(a1)
	beqz a5, calculation
	beqz a4, next_step

	# check if char is '.'
	li t1, '.'
	beq t1, a4, next_char	

	# get decimal number and replace 4 last bits with it
	addi a4, a4, -'0'
	add a3, a3, a4

next_char:
	addi a1, a1, 1
next_step:
	addi a5, a5, -1
	j loop

calculation:
	mv a6, a3
	mv a7, a3
	
	sw ra, 0(t0)
	call mult
	lw ra, 0(t0)

	mv a3, a7
	j transform_to_string

transform_to_string:
	li a5, 17
	mv a4, a2
string_loop:
	beqz a5, done	

	# check if we need to add 
	li t1, 16
	beq t1, a5, add_dot

	# get decimal number
	srli t1, a3, 60

	# transform it to char
	addi t1, t1, '0'
	
	sb t1, 0(a4)

	slli a3, a3, 4
next_string_step:
	addi a5, a5, -1
	addi a4, a4, 1

	j string_loop

add_dot:
	li t1, '.'
	sb t1, 0(a4)
	j next_string_step
done:

	ret
	
