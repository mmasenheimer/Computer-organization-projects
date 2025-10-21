.data

.globl	sort
.globl	compare
.globl	swap
.globl	print

.globl	alpha
.globl	bravo
.globl	charlie
.globl	delta

compare:	.word	0
swap:		.word	1
charlie:	.word	560
print:		.word	0
bravo:		.word	637
sort:		.word	0
delta:		.word	433
alpha:		.word	-51


.text

.globl	main

main:
	jal studentMain
	
	
	# dump out the 4 values.
.data
TESTCASE_MSG:	.asciiz	"\n\nTestcase Variable Dump: "
.text
	addi	$v0, $zero, 4		# print_str(TESTCASE_MSG)
	la	$a0, TESTCASE_MSG
	syscall

	addi	$v0, $zero, 1		# print_int(alpha)
	la	$a0, alpha
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(bravo)
	la	$a0, bravo
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(charlie)
	la	$a0, charlie
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(delta)
	la	$a0, delta
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,0xa
	syscall
	
	
	# terminate the program	
	addi	$v0, $zero, 10		# syscall_exit
	syscall


