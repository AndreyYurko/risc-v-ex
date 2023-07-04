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
	srli t0, a7, 60
	slli a7, a7, 4
	
	mv t1, t0

step_of_mult_by_dec:
	beqz t1, continue_step
	add a0, a0, a6
	addi t1, t1, -1
	j step_of_mult
	
continue_step:
	srli a6, a6, 4
	addi a5, a5, -1
	j step_of_mult

done:
	mv a7, t2
	ret
	
