.globl sine

default_answer = 0x312d

.text
# if you need some data, put it here
result: .word 0

.section .text

# Sine
#   Params
#	a1 -- input buffer will contain string with the argument
#	a2 -- output string buffer for the string result
sine:
	# implement here
	
loop:
	lbu a0, 0(a1)
	beqz a0, done
	li t0, '.'
	beq t0, a0, next	

	addi a0, a0, -'0'
	add a3, a3, a0
	la a3, result
next:
	add a1, a1, 1
	j loop
done:
	sw	a3, 0(a2)


	ret
	
