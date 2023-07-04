.globl summ

# Summ
#     Params:
#         t4 - first number
#         t5 - second number
#         t5 - result

summ:
	add t5, t5, t4
	li t6, 60

normalize_step:
	# get current digit
	sll t3, a7, t6
	srli t3, t3, 60
	
	li t4, 9
	blt t3, t4, continue_summ

	addi t3, t3, -10
	
	li t4, 60
	sub t4, t4, t6

	sll t3, t3, t4

	sub t5, t5, t3

continue_summ:
	beqz t6, done
	addi t6, t6, -4
	j normalize_step

done:
	ret
          
