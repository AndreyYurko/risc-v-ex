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
	srli a3, a3, 4
	j next_char

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

div:
	# a4 - pointer to current digit in result (and dividend)
	# pointer == shift to the left
	li a4, 0
	li a7, 0

	# a3 - accomulator
	li a3, 0

next_digit:
	li t2, 64
	beq t2, a4, done_div

	# get next_digit
	sll t2, a5, a4
	srli t2, t2, 60
	
	slli a3, a3, 4
	add a3, a3, t2

ans_inc_loop:
	blt a3, a6, iteration_end
	
	li t3, 60
	sub t3, t3, a4
	li t4, 1
	sll t4, t4, t3
	add a7, a7, t4
	
	sd ra, 80(t0)
	sd a4, 88(t0)
	sd a5, 96(t0)
	sd a6, 104(t0)
	sd a7, 112(t0)
	
	li t4, 0
	mv t5, a3
	mv t6, a6
	
	call summ

	mv a3, t6
	ld ra, 80(t0)
	ld a4, 88(t0)
	ld a5, 96(t0)
	ld a6, 104(t0)
	ld a7, 112(t0)

	j ans_inc_loop

iteration_end:
	addi a4, a4, 4
	j next_digit

done_div:
	ret

mult:
	li t2, 0
	li a5, 16

step_of_mult:
	beqz a5, done_mult

	# get decimal
	srli t1, a7, 60
	slli a7, a7, 4

step_of_mult_by_dec:
	beqz t1, continue_step
	mv t5, a6
	mv t6, t2
	li t4, 1

	sd ra, 48(t0)
	sd a5, 56(t0)
	sd a6, 64(t0)
	sd a7, 72(t0)
	call summ
	ld ra, 48(t0)
	ld a5, 56(t0)
	ld a6, 64(t0)
	ld a7, 72(t0)
	
	mv t2, t6

	addi t1, t1, -1
	j step_of_mult_by_dec
	
continue_step:
	srli a6, a6, 4
	addi a5, a5, -1
	j step_of_mult

done_mult:
	mv a7, t2
	ret


summ:
	mv a6, t5
	mv a7, t6
	mv t2, t4
	li t6, 0
	li t5, 60
	# overflow
	li a5, 0

summ_step:
	# get current digits
	sll t3, a6, t5
	srli t3, t3, 60

	sll t4, a7, t5
	srli t4, t4, 60
	
	# summ or substract digits
	beqz t2, substract_digit

	add t3, t3, t4
	j after_determination

substract_digit:
	sub t3, t3, t4

after_determination:
	add t3, t3, a5
	li a5, 0

	li t4, 0
	blt t3, t4, substract_1

	li t4, 10
	blt t3, t4, continue_summ

	# substract 10 from digit
	addi t3, t3, -10
	li a5, 1

continue_summ:
	li t4, 60
	sub t4, t4, t5
	sll t3, t3, t4
	add t6, t6, t3

	beqz t5, done_sum
	addi t5, t5, -4
	j summ_step

substract_1:
	addi t3, t3, 10
	li a5, -1
	j continue_summ

done_sum:
	ret		
