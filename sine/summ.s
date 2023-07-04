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
	add t6, t6, t5
	li t4, 60

normalize_step:
	# get current digit
	sll t3, t6, t4
	srli t3, t3, 60
	
	# t5 now free
	li t5, 9
	blt t3, t5, continue_summ

	# substract 10 from digit
	li t3, 10
	
	li t5, 60
	sub t5, t5, t4

	sll t3, t3, t5

	sub t6, t6, t3

	# add 1 to the next one
	li t3, 1
	li t5, 64
	sub t5, t5, t4
	
	sll t3, t3, t5

	add t6, t6, t3

continue_summ:
	beqz t4, done
	addi t4, t4, -4
	j normalize_step

done:
	ret
          
