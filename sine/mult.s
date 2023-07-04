.globl mult 

# Multiplication
#   Params: 
#      a6 - first number
#      a7 - second number
#      a7 - result

mult:
	li t1, 0
	li a5, 16

step_of_mult:
	beqz a5, done

	# get decimal
	srli t0, a7, 60
	slli a7, a7, 4

step_of_mult_by_dec:
	beqz t0, continue_step
	mv t4, a6
	mv t5, t1
	call summ
	
	mv t1, t5

	addi t0, t0, -1
	j step_of_mult_by_dec
	
continue_step:
	srli a6, a6, 4
	addi a5, a5, -1
	j step_of_mult

done:
	mv a7, t2
	ret
	
