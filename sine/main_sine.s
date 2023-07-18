
# syscalls
exit    = 93
read    = 63
write   = 64

.section .data 

# This is  0-ended string with input data
input:
.align 4
.space  200

# This will be used for 0-ended string with result. Use "-1" if you cannot calculate the function
# output:    
# .align 8  
# .space	100
  

.section .text 
.globl _start

_start:     


	# Buffer initialisation will be here

	li a7, read
	li a0, 0	
	la a1, input
	li a2, 80
	ecall

	la	a1, input
	li t0, 80
	add a2, a1, t0
	call 	sine

	# Result checking will be here
	
	li a7, write
	li a0, 1
	mv a1, a2
	li a2, 80
	ecall

	li	a0, 0
	li	a7, exit
	ecall
