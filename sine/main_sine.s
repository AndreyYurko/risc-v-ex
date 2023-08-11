
# syscalls
exit    = 93

.section .data 

# This is  0-ended string with input data
input: 	.asciz "1.1234"

# This will be used for 0-ended string with result. Use "-1" if you cannot calculate the function
output:                
.align 4
.space	100
  

.section .text 
.globl _start

_start:     


	# Buffer initialisation will be here

	la	a1, input
	la	a2, output
	call 	sine

	# Result checking will be here


	li	a0, 0
	li	a7, exit
	ecall
