.globl div

# Division
#     Params:
#         a5 - dividend
#         a6 - divider
#         a7 - result

div:
	# a4 - pointer to current digit in result (and dividend)
	# pointer == shift to the left
	li a4, 0
	li a7, 0

	# a3 - accomulator
	li a3, 0

next_digit:
	li t2, 64
	beq t2, a4, done

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
	
	sd ra, 72(t0)
	sd a3, 80(t0)
	sd a4, 88(t0)
	sd a5, 96(t0)
	sd a6, 104(t0)
	sd a7, 112(t0)
	
	li t4, 0
	mv t5, a3
	mv t6, a6
	
	call summ

	ld ra, 72(t0)
	mv a3, t6
	ld a4, 88(t0)
	ld a5, 96(t0)
	ld a6, 104(t0)
	ld a7, 112(t0)

	j ans_inc_loop

iteration_end:
	addi a4, a4, 4
	j next_digit

done:
	ret
