.globl mult 


# Multiplication
#   Params: 
#      a6 - first number
#      a7 - second number
#      a7 - result

mult:
	li t2, 0
	li a5, 16

step_of_mult:
	beqz a5, done

	# get decimal
	srli t1, a7, 60
	slli a7, a7, 4

step_of_mult_by_dec:
	beqz t1, continue_step
	mv t5, a6
	mv t6, t2

	sw ra, 8(t0)
	call summ
	lw ra, 8(t0)
	
	mv t2, t6

	addi t1, t1, -1
	j step_of_mult_by_dec
	
continue_step:
	srli a6, a6, 4
	addi a5, a5, -1
	j step_of_mult

done:
	mv a7, t2
	ret
	
