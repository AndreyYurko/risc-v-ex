.globl sine

default_answer = 0x312d

.text
# if you need some data, put it here

.section .text

# Sine
#   Params
#	a1 -- input buffer will contain string with the argument
#	a2 -- output string buffer for the string result
sine:
	# implement here

	li a3, 0
	li a5, 16
loop:
	# shift a3 4 bits to the left - each 4 bits are decimal number
	slli a3, a3, 4

	# read char
	lbu a4, 0(a1)
	beqz a5, transform_to_string
	beqz a4, next_step

	# check if char is '.'
	li t0, '.'
	beq t0, a4, next_char	

	# get decimal number and replace 4 last bits with it
	addi a4, a4, -'0'
	add a3, a3, a4

next_char:
	addi a1, a1, 1
next_step:
	addi a5, a5, -1
	j loop

transform_to_string:
	li a5, 17
	mv a4, a2
string_loop:
	beqz a5, done	

	# check if we need to add 
	li t0, 16
	beq t0, a5, add_dot

	# get decimal number
	srli t0, a3, 60

	# transform it to char
	addi t0, t0, '0'
	
	sb t0, 0(a4)

	slli a3, a3, 4
next_string_step:
	addi a5, a5, -1
	addi a4, a4, 1

	j string_loop

add_dot:
	li t0, '.'
	sb t0, 0(a4)
	j next_string_step
done:

	ret
	
