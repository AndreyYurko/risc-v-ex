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
	li a5, 19
	la t0, var
loop:
	# multiply by 10
	slli t2, a3, 3
	slli a3, a3, 1
	add a3, a3, t2
loop_without_mult:
	# read char
	lbu a4, 0(a1)
	beqz a5, calculation
	beqz a4, next_step

	# check if char is '.'
	li t1, '.'
	beq t1, a4, process_dot	

	# get decimal number and replace 4 last bits with it
	addi a4, a4, -'0'
	add a3, a3, a4

next_char:
	addi a1, a1, 1
next_step:
	addi a5, a5, -1
	j loop
process_dot:
	addi a1, a1, 1
	addi a5, a5, -1
	j loop_without_mult

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

	addi a6, a6, 2
	
	ld a3, 8(t0)
	ld a4, 16(t0)
	ld a7, 32(t0)
	
	li t2, -1
	beq a7, t2, substract_member
add_member:
	add a5, a5, a3	

	li a7, -1
	j step_of_taylor
substract_member:
	sub a5, a5, a3
	li a7, 1
	j step_of_taylor

transform_to_string:
	li a5, 20
	mv a4, a2
	addi a4, a4, 19
string_loop:
	beqz a5, done	

	# check if we need to add dot
	li t1, 2
	beq t1, a5, add_dot

	# get decimal number
	sd ra, 0(t0)
	sd a4, 8(t0)
	sd a5, 16(t0)
	mv a5, a3
	li a6, 10
	call div
	mv t1, a3
	mv a3, a7

	ld ra, 0(t0)
	ld a4, 8(t0)
	ld a5, 16(t0)

	# transform it to char
	addi t1, t1, '0'
	
	sb t1, 0(a4)

next_string_step:
	addi a5, a5, -1
	addi a4, a4, -1

	j string_loop

add_dot:
	li t1, '.'
	sb t1, 0(a4)
	j next_string_step
done:
	ret
	
