.globl mult 


# Multiplication
#   Params: 
#      a6 - first number
#      a7 - second number
#      a7 - result

mult:
	li t2, 0
	li a5, 64
	slli a6, a6, 4

step_of_mult:
	beqz a5, done

	srli t1, a7, 63
	slli a7, a7, 1

step_of_mult_by_dec:
	beqz t1, continue_step
	
	add t2, t2, a6
	
continue_step:
	srli a6, a6, 1
	addi a5, a5, -1
	j step_of_mult

done:
	mv a7, t2
	ret
	
