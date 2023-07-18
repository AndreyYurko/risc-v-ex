.globl sine

max_steps = 0x99

.section .data
# if you need some data, put it here
var:
.align 8
.space 200


.section .text

# Sine
#   Params
#	a1 -- input buffer will contain string with the argument
#	a2 -- output string buffer for the string result
sine:
	# implement here

	li a3, 0
	li a5, 16
	la t0, var
loop:
	# shift a3 4 bits to the left - each 4 bits are decimal number
	slli a3, a3, 4

	# read char
	lbu a4, 0(a1)
	beqz a5, calculation
	beqz a4, next_step

	# check if char is '.' or '\n'
	li t1, '.'
	beq t1, a4, next_char	
	li t1, 10
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
	# a3 - ans
	# a4 - square of x
	# a5 - last member of Taylor series
	# a6 - last number in factorial
	# a7 - current sign
	sd ra, 0(t0)
	sd a3, 8(t0)
	
	mv a6, a3
	mv a7, a3
	call mult

	mv a4, a7
	ld a3, 8(t0)
	mv a5, a3
	li a6, 1
	li a7, -1

step_of_taylor:
	li t1, max_steps
	bgt a6, t1, transform_to_string

	sd a3, 8(t0)
	sd a4, 16(t0)
	sd a6, 24(t0)
	sd a7, 32(t0)

	mv a6, a5
	mv a7, a4
	call mult

	mv a5, a7
	ld a6, 24(t0)

	addi a6, a6, 1
	
	# a5 already == dividend
	# a6 already == divider
	call div

	mv a5, a7
	ld a6, 24(t0)

	addi a6, a6, 2
	
	# a5 already == dividend
	# a6 already == divider
	call div

	mv a5, a7
	ld a6, 24(t0)
	sd a5, 24(t0)
	
	li t4, 1
	mv t5, a6
	li t6, 2
	call summ

	mv a6, t6
	ld a3, 8(t0)
	sd a6, 8(t0)
	ld a5, 24(t0)
	ld a7, 32(t0)

	mv t5, a3
	mv t6, a5
	
	li t2, -1
	beq a7, t2, substract_member
add_member:
	li t4, 1
	call summ	

	li a7, -1
	j continue_taylor_step
substract_member:
	li t4, 0
	call summ
	li a7, 1
continue_taylor_step:
	
	mv a3, t6
	ld a4, 16(t0)
	ld a5, 24(t0)
	ld a6, 8(t0)

	j step_of_taylor

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
	ld ra, 0(t0)
	ret
	
