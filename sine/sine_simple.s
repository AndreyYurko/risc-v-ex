.globl sine

.section .data
# if you need some data, put it here
var:
.align 8
.asciz "0.00"
.asciz "0.09"
.asciz "0.19"
.asciz "0.29"
.asciz "0.39"
.asciz "0.48"
.asciz "0.56"
.asciz "0.64"
.asciz "0.71"
.asciz "0.78"
.asciz "0.84"
.asciz "0.89"
.asciz "0.93"
.asciz "0.96"
.asciz "0.98"
.asciz "1.00"


.section .text

# Sine
#   Params
#	a1 -- input buffer will contain string with the argument
#	a2 -- output string buffer for the string result
sine:
	# implement here
	
	li t2, 30
	
	# Load the first byte from the string
  	lb t0, 0(a1)
  	lb t1, 1(a1)

  	# Check if the string has more than two characters
  	beqz t1, calculation
 
  	lb t2, 2(a1)	
	bnez t2, calculation
	li t2, 30
	
calculation:
	
	addi t0, t0, -48
	addi t2, t2, -48

	la a3, var
	beqz t0, resolve_second
	
	addi a3, a3, 50
resolve_second:
	
	add a3, a3, t2
	add a3, a3, t2
	add a3, a3, t2
	add a3, a3, t2
	add a3, a3, t2
	
	lw a4, 0(a3)	
	sw a4, 0(a2)

done:	
	ret	
