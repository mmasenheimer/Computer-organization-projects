.data

fibTitle:	.asciiz		"Fibonacci Numbers:\n"
fibZero:	.asciiz		"  0: 1\n"
fibOne:		.asciiz		"  1: 1\n"
space:		.asciiz		" "
newline:	.asciiz		"\n"
colon:		.asciiz		":"
ascending:	.asciiz		"Run Check: ASCENDING"
descending:	.asciiz		"Run Check: DESCENDING"
neither:	.asciiz		"Run Check: NEITHER"
wordcount:	.asciiz		"Word Count: "
swapstring:	.asciiz		"String successfully swapped!\n"

lr:  		.byte 0       	# init lr to 0
mid: 		.byte 0       	# init mid to 0

.text
.globl studentMain

studentMain:

	addiu $sp, $sp, -24 		# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 			# save frame pointer of caller
	sw $ra, 4($sp) 			# save return address
	addiu $fp, $sp, 20 		# setup frame pointer of main
	
	# Task 1: Fibonacci

	la $s1, fib 			# fib = $s1
	lw $s1, 0($s1)
	
	beq $s1, $zero, AFTER_FIB	# If fib = 0, skip fibbonacci code
	
	addi $v0, $zero, 4		# print_str("Fibonacci Numbers:\n")
	la $a0, fibTitle		
	syscall
	
	addi $v0, $zero, 4		# print_str("  0: 1\n")
	la $a0, fibZero			
	syscall
	
	addi $v0, $zero, 4		# print_str("  1: 1\n"
	la $a0, fibOne			
	syscall

	addi $t1, $zero, 1		# prev = 1
	addi $t2, $zero, 1		# beforeThat = 1
	addi $t3, $zero, 2		# n = 2
	
	# while (n<=fib) {
	#	int curr = prev + beforeThat
	#	printf(" %d: %d\n", n curr);
	#	#n++
	#	beforeThat = prev;
	#	prev = cur
	#}
	# REGISTERS
	# $t1 = prev
	# $t2 = beforeThat
	# $t3 = n
	# $t4 temporaries for comparison

	LOOP:
		slt $t4, $s1, $t3		# fib < n 
		bne $t4, $zero, AFTER_LOOP1	# if fib < n, exit the loop
		
		add $t4, $t1, $t2		# cur = prev + beforeThat
		
		addi $v0, $zero, 4		# print_str(" ")
		la $a0, space			
		syscall
		
		addi $v0, $zero, 4		# print_str(" ")
		la $a0, space			
		syscall
		
		addi $v0, $zero, 1		# print_int(n)
		add $a0, $t3, $zero
		syscall
		
		addi $v0, $zero, 4		# print_str(":")
		la $a0, colon
		syscall
		
		addi $v0, $zero, 4		# print_str(" ")
		la $a0, space			
		syscall
		
		addi $v0, $zero, 1
		add $a0, $t4, $zero		# copy integer into $a0
		syscall
		
		addi $v0, $zero, 4		# print_str("\n")
		la $a0, newline			
		syscall
		
		addi $t3, $t3, 1		# n++
		
		addi $t2, $t1, 0		# beforeThat = prev
		addi $t1, $t4, 0		# prev = curr

		j LOOP
	
	AFTER_LOOP1:
	
		addi $v0, $zero, 4		# print_str("\n")
		la $a0, newline
		syscall

	AFTER_FIB:
	
	# Task 2: square
	
	la $s2, square			
	lw $s2, 0($s2)			# square = $s2
	
	la $t0, square_fill		
	lb  $s3, 0($t0)   		# square_fill = $s3
	
	la $t0, square_size
	lw $s4, 0($t0)   		# square_size = $s4
	
	beq $s2, $zero, AFTER_SQUARE	# if square = 0, skip square code
	
	
	# for (int row=0; row < square_size; row++) {
	#	char lr, mid;
	#	if (row == 0 || row == square_size - 1) {
	#		lr = '+';
	#		mid = '-';
	#	} else {
	#		lr = '|';	
	#		mid = square_fill;
	# }
	#
	# REGISTERS:
	# $s2 = square
	# $s3 = square_fill
	# $s4 = square_size
	# $t9 = row
	# $t1, $t2 = lr, mid
	
	addi $t9, $zero, 0		# row = 0
	
	LOOPTWO:
		
		slt $t1, $t9, $s4		# row < square_size
		beq $t1, $zero, AFTER_LOOPTWO	# if row >= square size, exit the loop
		
		addi $t3, $s4, -1		# square_size - 1
		
		la $t0, lr
		lb  $t1, 0($t0)       		# $t1 = lr
		
		la $t0, mid
		lb  $t2, 0($t0)      		# $t2 = mid
		
		beq $t9, $zero, TRUE_OR		# if row == 0, branch to true body
		beq $t9, $t3, TRUE_OR		# if row == square_size - 1, branch to true body
		
		addi $t1, $zero, 124   		# '|' is 124 in ASCII
		
		la $t0, lr        		
		sb $t1, 0($t0)          	# lr = '|'
		
		la $t0, mid
		sb $s3, 0($t0)			# mid = square_fill
		
		j AFTER_OR
		
		TRUE_OR:
		
			addi $t1, $zero, 43		# $t1 = '+'
			
			la $t0, lr
			sb $t1, 0($t0)          	# lr = '+'
			
			addi $t2, $zero, 45   		# $t2 = '-'
			
			la $t0, mid
			sb $t2, 0($t0)         		# mid = '-'

		# if (square_size) > 1) {
		#	printf("%c", lr);
		#	for (int i = 1; i < square_size - 1; i++) {
		#		printf("%c", mid);
		#}}
		#
		# REGISTERS: 
		#
		# $t1 = lr
		# $t2 = mid
		# $t6 for comparisons
		# $s4 = sq_size
			
		AFTER_OR:
	
        		la $t0, lr
        		lb $t1, 0($t0)          	# $t1 = lr
        
        		la $t0, mid
        		lb $t2, 0($t0)          	# $t2 = mid
		
			addi $t6, $zero, 1		# $t6 = 1 for comparison
			
			slt $t5, $t6, $s4		# 1 < square_size
			beq $t5, $zero, AFTER_COMPARE	# if square_size <= 1, don't execute
		
			addi $v0, $zero, 11		# print_char ("lr")
			addi $a0, $t1, 0
			syscall
		
			addi $t5, $zero, 1		# i = 1
		
		LOOP_SQUARE:
		
			slt $t6, $t5, $t3			# i < square_size - 1
			beq $t6, $zero, BREAK_LOOP_SQUARE	# if i >= square_size - 1, break the loop
			
			addi $v0, $zero, 11			# print_char ("mid")
			addi $a0, $t2, 0			
			syscall
			
			addi $t5, $t5, 1			# i++
			
			j LOOP_SQUARE
		
		BREAK_LOOP_SQUARE:
		
		AFTER_COMPARE:
		
			addi $v0, $zero, 11			# print_char("lr")
			addi $a0, $t1, 0
			syscall
		
			addi $v0, $zero, 4			# print_str("\n")
			la $a0, newline				
			syscall
		
			addi $t9, $t9, 1			# row++
			j LOOPTWO
		
	AFTER_LOOPTWO:
	
		addi $v0, $zero, 4		# print_string("\n")
		la $a0, newline				
		syscall

	AFTER_SQUARE:

	# Task 3: Run Check
	
	la $s5, runCheck		# $s5 = runCheck
	lw $s5, 0($s5)
	
	addi $t0, $zero, 1		# $t0 = 1 for comparison
	
	bne $s5, $t0, AFTER_RUN_CHECK	# if runCheck != 1, skip runcheck task
	
	la $t9, intArray_len		# $t9 = len(array)
	lw $t9, 0($t9)		
	
	addi $t3, $zero, 0		# $t3 = ascending variable counter
	addi $t4, $zero, 0		# $t4 = descending variable counter
	
	slti $t2, $t9, 2		# if len(array) < 2
	beq $t2, $zero, VALID_LEN	# if len(array) >= 2, go to VALID_LEN
	
	j BOTH
	
	VALID_LEN:
	
		addi $t9, $t9, -1		# $t9 = len(array) - 1
	
		la $t8, intArray 		# $t8 = address of intArray
	
		addi $t1, $zero, 0		# i = 0 for the for loop
		
	# for (int i = 0; i < intArray_len - 1; i++) {
	#	int current = intArray[i];
	#	int next = intArray[i + 1]
	#
	#	if (next < current) {
	#		ascending++
	#	} else if (current < next) {
	#		descending++
	#	}
	# }
	#
	# REGISTERS:
	# $t1 = i
	# $t9 = intArray_len
	# $t8 = base address of intArray
	# $s2 = current element (a[i])
	# $s3 = next element (a[i+1])
	# $t3 = ascending counter
	# $t4 = descending counter
	# $t5, $t6, $t7 = temporaries for comparison/addressing
	
	LOOP_RUNCHECK:
	
		slt $t2, $t1, $t9			# while i < (intArray_len - 1)
		beq $t2, $zero, EXIT_LOOP_RUNCHECK	# if i >= intArray_len, break the loop
		
		sll $t7, $t1, 2        			# $t7 = i * 4 by shifting left by 2
		add $t6, $t8, $t7      			# $t6 = base address + i*4 = &a[i]
		
		lw  $s2, 0($t6)        			# load a[i] into $s2
		lw  $s3, 4($t6)        			# s3 = a[i+1]
		
		slt $t5, $s3, $s2      			# a[i+1] < a[i]
		bne $t5, $zero, ASCENDINGLOOP		# branch if descending pair (a[i] > a[i+1])
		
		slt $t5, $s2, $s3      			# $t5 = 1 if a[i+1] < a[i] (descending order)
    		bne $t5, $zero, DESCENDINGLOOP
		
		j AFTER_CHECK
		
		ASCENDINGLOOP:
		
			addi $t3, $t3, 1		# Add 1 to ascending to show that the array is ascending
			j AFTER_CHECK
		
		DESCENDINGLOOP:
		
			addi $t4, $t4, 1		# descending++
			j AFTER_CHECK
		
		AFTER_CHECK:
		
			addi $t1, $t1, 1 		# i++
			j LOOP_RUNCHECK    	

	EXIT_LOOP_RUNCHECK:
	
	beq $t3, $zero, CHECK_T4_ONLY    # if ascending is zero, check descending
	beq $t4, $zero, DESCENDING    	 # if $t4 is zero, then it must be descending
	
	j NEITHER			 # both are zero so it must it be neither

	CHECK_T4_ONLY:
	
    		bne $t4, $zero, ASCENDING     	# only $t4 is non-zero so it's ascending
    		j BOTH                     	# both are not zero so print both
	
	ASCENDING:	
	
		addi $v0, $zero, 4		# print_str("ASCENDING")
		la $a0, ascending		
		syscall

		j END_RUNCHECK

	DESCENDING:			
		
		addi $v0, $zero, 4		# print_str("\n")
		la $a0, descending		
		syscall
		
		j END_RUNCHECK
	
	NEITHER:
	
		addi $v0, $zero, 4		# print_str("NEITHER")
		la $a0, neither 		
		syscall
		j END_RUNCHECK
		
	BOTH:
	
		addi $v0, $zero, 4		# print_str("ASCENDING")
		la $a0, ascending		
		syscall
		
		addi $v0, $zero, 4		# print_str("\n")
		la   $a0, newline          	
		syscall
		
		addi $v0, $zero, 4		# print_str("DESCENDING")
		la $a0, descending		
		syscall
		
	END_RUNCHECK:
	
		addi $v0, $zero, 4		# print_str("\n")
		la   $a0, newline          
		syscall

		addi $v0, $zero, 4		# print_str("\n")
		la   $a0, newline          	
		syscall
	
	AFTER_RUN_CHECK:
	
	# TASK 4: Count Words
	
	la $t6, countWords		# $t6 = countWords
	lw $t6, 0($t6)
	
	addi $t0, $zero, 1		# $t0 = 1 for comparison
	
	bne $t6, $t0, AFTER_COUNT_WORDS	# If countWords is not 1, skip count words task
	
	addi $t0, $zero, 0		# $t0 = word counter
	
	addi $t1, $zero, 0		# $t1 = null character terminator
	
	addi $t5, $zero, 0		# $t5 is the flag for if we are in or out of a word
	
	la   $t2, str       		# $t2 = address of str
	
	
	# int counter = 0;
	# int inWord =0;
	# char strPtr = str
	# while (strPtr != '\0') {
	#	if (strPtr == ' ' || strPtr == '\n') }
	#		inword = 0;
	#	} else if (!inWOrd) {
	#		wordCounter++;
	#		inWord = 1;
	#
	# strPtr++
	
	LOOP_COUNTWORDS:
		lb   $t1, 0($t2)     			# $t2 = current byte
		beq  $t1, $zero, EXIT_LOOP_COUNTWORDS 	# if null terminator, exit loop
		
		addi $t3, $t1, -32			# $t3 = space
		addi $t4, $t1, -10			# $t4 = newline character
		
		beq $t3, $zero, SPACE_NEWLINE		# the current byte is a space
		
		beq $t4, $zero, SPACE_NEWLINE		# the current byte is a newline
		
		bne $t5, $zero, AFTER_WORD_COMPARES	# If we are nto in a word
		
		addi $t0, $t0, 1			# wordCounter++
		
		addi $t5, $zero, 1			# We are in a word now
	
		j AFTER_WORD_COMPARES
		
		SPACE_NEWLINE:
		
		addi $t5, $zero, 0			# set flag to outside of a word
		
		AFTER_WORD_COMPARES:
		
		addi $t2, $t2, 1			# $t2++ move to next byte
		j LOOP_COUNTWORDS

	EXIT_LOOP_COUNTWORDS:
	
	addi $v0, $zero, 4		# print_str("WORDCOUNT: ")
	la $a0, wordcount
	syscall
	
	addi $v0, $zero, 1		# print_int(word count in int form)
	add $a0, $t0, $zero
	syscall
	
	addi $v0, $zero, 4		# print_str("\n")
	la   $a0, newline          
	syscall

	addi $v0, $zero, 4		# print_str("\n")
	la   $a0, newline        
	syscall
   	
	AFTER_COUNT_WORDS:

	# TASK 5: Reverse String
	
	la $s7, revString		# $s7 = revString
	lw $t0, 0($s7)
	
	la $s0, str			# $s0 = address of str
	
	addi $t1, $zero, 1		# $t0 = 1 for comparison
	
	bne $t0, $t1, AFTER_REVSTRING
	
	addi $t1, $zero, 0		# head = 0
	addi $t2, $zero, 0		# tail = 0
	addi $t3, $zero, 0		# Null character terminator for comparison
	
	#char *strPtr = str;  
	#int head = 0;
	#int tail = 0;
	# while (strPtr[tail] != '\0') {
	#    tail++;
	#}
	# tail--;
	# while (head < tail) {
	#    char temp = strPtr[head];
	#    strPtr[head] = strPtr[tail];
	#    strPtr[tail] = temp;
	#    head++;
	#    tail--;
	#}
	# REGISTERS:
	# $s0 = str pointer (strPtr)
	# $t1 = head index
	# $t2 = tail index
	# $t3 = null character '\0'
	# $t6, $t7 = temp addresses
	# t8, $t9 = temp values for swappinG
	
	LOOP_FIND_TAIL:
		add $t6, $s0, $t2               # base address + tail offset
		lb $t9, 0($t6)			# Load current byte of the word
		
		beq $t9, $t3, BREAK_TAIL_LOOP	# If str[tail] == '\0', end loop
		
		addi $t2, $t2, 1		# tail++
		j LOOP_FIND_TAIL
		
	BREAK_TAIL_LOOP:
	
	addi $t2, $t2, -1		# tail--
	
	LOOP_SWAP_CHARS:
	
		slt $t8, $t1, $t2			# head < tail
		beq $t8, $zero, BREAK_SWAP_CHARS	# If head >= tail, exit the loop
		
		add $t6, $s0, $t1   			# head address
		add $t7, $s0, $t2   			# tail address

		lb $t8, 0($t6)   			# load head value into temp
		lb $t9, 0($t7)   			# load tail value
		
		sb $t9, 0($t6)   			# store tail at head address
		sb $t8, 0($t7)   			# store head at tail address

		addi $t1, $t1, 1			# head++
		addi $t2, $t2, -1			# tail--
		
		j LOOP_SWAP_CHARS
	
	BREAK_SWAP_CHARS:
	
	addi $v0, $zero, 4		# print_str("String successfully swapped!\n")
	la $a0, swapstring
	syscall
	
	addi $v0, $zero, 4		# print_str("\n"
	la $a0, newline
	syscall
	
	AFTER_REVSTRING:
	
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the frame pointer of caller
	addiu $sp, $sp, 24 	# restore the stack pointer of caller
	jr $ra 			# return to code of caller