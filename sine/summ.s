.globl summ

# .section .data
# ra_storage:
# .align 8
# .space 8

# .section .text
# Summ
#     Params:
#         t5 - first number
#         t6 - second number
#         t6 - result

summ:
	mv a6, t5
	mv a7, t6
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
	
	# summ digits
	add t3, t3, t4
	add t3, t3, a5
	li a5, 0

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

	beqz t5, done
	addi t5, t5, -4
	j summ_step

done:
	ret
          
