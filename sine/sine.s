.globl sine

default_answer = 0x312d
.data
# result: .space 20

.text
.align 4
result: .space 20
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
	beq t0, t0, next_char	

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
	la a4, result
string_loop:
	beqz a5, done	

	srli t0, a3, 60
	addi t0, t0, '0'
	sb t0, 0(a4)

	slli a3, a3, 4
	addi a5, a5, -1

	j string_loop
done:
	la a2, result

	ret
	
