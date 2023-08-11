.globl sine

max_steps = 0x99

.section .data
# if you need some data, put it here
var:
.align 8
.space 48


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
	sd ra, 0(t0)
loop:
	# multiply by 10
	slli t2, a3, 3
	slli a3, a3, 1
	add a3, a3, t2

loop_without_mult:
	# read char
	lbu a4, 0(a1)
	beqz a5, transform_to_bin
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

transform_to_bin:
	li a4, 1000000000000000000

transform_to_bin_loop:
	beqz a4, calculation
	
	blt a3, a4, next_to_bin_step
	addi a5, a5, 1
	sub a3, a3, a4

next_to_bin_step:
	srli a4, a4, 1
	slli a5, a5, 1
	j transform_to_bin_loop

calculation:
	mv a3, a5
	# a3 - ans
	# a4 - square of x
	# a5 - last member of Taylor series
	# a6 - last number in factorial
	# a7 - current sign
	
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
	bgt a6, t1, transform_to_decimal

	sd a3, 8(t0)
	sd a4, 16(t0)
	sd a6, 32(t0)
	sd a7, 40(t0)

	mv a6, a5
	mv a7, a4
	call mult

	mv a5, a7
	ld a6, 32(t0)

	addi a6, a6, 1
	
	# a5 already == dividend
	# a6 already == divider
	call div

	mv a5, a7
	ld a6, 32(t0)

	addi a6, a6, 2
	
	# a5 already == dividend
	# a6 already == divider
	call div

	mv a5, a7
	ld a6, 32(t0)

	addi a6, a6, 2
	
	ld a3, 8(t0)
	ld a4, 16(t0)
	ld a7, 40(t0)
	
	li t2, -1
	beq a7, t2, substract_member
add_member:
	add a3, a3, a5	

	li a7, -1
	j step_of_taylor
substract_member:
	sub a3, a3, a5
	li a7, 1
	j step_of_taylor

transform_to_decimal:
	li a4, 61
	slli a3, a3, 3
	li a5, 1000000000000000000
	li a6, 0

transform_to_decimal_loop:
	beqz a4, transform_to_string
	srli t1, a3, 63
	beqz t1, next_dec_step
	add a6, a6, a5
next_dec_step:
	slli a3, a3, 1
	srli a5, a5, 1
	addi a4, a4, -1
	j transform_to_decimal_loop

transform_to_string:
	mv a3, a6
	li a5, 20
	mv a4, a2
	addi a4, a4, 19
string_loop:
	beqz a5, done	

	# check if we need to add dot
	li t1, 2
	beq t1, a5, add_dot

	# get decimal number
	sd a4, 8(t0)
	sd a5, 16(t0)
	mv a5, a3
	li a6, 10
	call div
	mv t1, a3
	mv a3, a7

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
	ld ra, 0(t0)
	ret

# Multiplication
#   Params:
#      a6 - first number
#      a7 - second number
#      a7 - result

mult:
        li t2, 0
        li a5, 64
        slli a6, a6, 2
        slli a7, a7, 1

step_of_mult:
        beqz a5, mult_done

        srli t1, a7, 63
        slli a7, a7, 1

step_of_mult_by_dec:
        beqz t1, continue_step

        add t2, t2, a6

continue_step:
        srli a6, a6, 1
        addi a5, a5, -1
        j step_of_mult

mult_done:
        mv a7, t2
        ret


# Division
#     Params:
#         a5 - dividend
#         a6 - divider
#         a7 - result
#         a3 - mod

div:
        # a4 - pointer to current digit in result (and dividend)
        # pointer == shift to the left
        li a4, 0
        li a7, 0

        # a3 - accomulator
        li a3, 0

next_digit:
        li t2, 64
        beq t2, a4, div_done

        # get next_digit
        sll t2, a5, a4
        srli t2, t2, 63

        slli a3, a3, 1

        add a3, a3, t2

ans_inc_loop:
        blt a3, a6, iteration_end

        li t3, 63
        sub t3, t3, a4
        li t4, 1
        sll t4, t4, t3
        add a7, a7, t4

        sub a3, a3, a6

iteration_end:
        addi a4, a4, 1
        j next_digit

div_done:
        ret
	
