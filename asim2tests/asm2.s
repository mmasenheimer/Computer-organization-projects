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

lr:  		.byte 0       # init lr to 0
mid: 		.byte 0       # init mid to 0

.text
.globl studentMain

studentMain:

	addiu $sp, $sp, -24 		# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 			# save frame pointer of caller
	sw $ra, 4($sp) 			# save return address
	addiu $fp, $sp, 20 		# setup frame pointer of main
	
	#TASK  1: FIBBONACI NUMBER CALCULATION---------------------------------------------------------------------------------------------------------------------
	
	la $s1, fib 			# fib = $s1
	lw $s1, 0($s1)
	
	beq $s1, $zero, AFTER_FIB	# If fib = 0 don't run the fibonacci code
	
	addi $v0, $zero, 4
	la $a0, fibTitle		# load address of fib title into $a0
	syscall
	
	addi $v0, $zero, 4
	la $a0, fibZero			# load address of fibzero into the $a0
	syscall
	
	addi $v0, $zero, 4
	la $a0, fibOne			# load address of fibzero into the $a0
	syscall
	
	addi $t1, $zero, 1		# prev = 1 in $t1
	addi $t2, $zero, 1		# beforeThat = 1 in $t2
	addi $t3, $zero, 2		# n = 2 in $t3
	
	LOOP:
		slt $t4, $s1, $t3		# fib < n and puts result into $t4
		bne $t4, $zero, AFTER_LOOP1	# if n >= fib, do not do the loop
		
		add $t4, $t1, $t2		# cur = prev + beforeThat
		
		addi $v0, $zero, 4
		la $a0, space			# load address of the space into $a0
		syscall
		
		addi $v0, $zero, 4
		la $a0, space			# load address of the space into $a0
		syscall
		
		addi $v0, $zero, 1
		add $a0, $t3, $zero
		syscall
		
		addi $v0, $zero, 4
		la $a0, colon			# load address of the colon into $a0
		syscall
		
		addi $v0, $zero, 4
		la $a0, space			# load address of the space into $a0
		syscall
		
		addi $v0, $zero, 1
		add $a0, $t4, $zero		# copy integer into $a0
		syscall
		
		addi $v0, $zero, 4
		la $a0, newline			# load address of newline into $a0
		syscall
		
		addi $t3, $t3, 1		# n++
		
		addi $t2, $t1, 0		# beforeThat = prev
		addi $t1, $t4, 0		# prev = curr
		

		j LOOP
	
	AFTER_LOOP1:
	
	addi $v0, $zero, 4
	la $a0, newline			# load address of newline into $a0
	syscall
	
	addi $t0, $zero, 0		# reset t registers that were used for this task
	addi $t1, $zero, 0
	addi $t2, $zero, 0
	addi $t3, $zero, 0
	addi $t4, $zero, 0

	
	AFTER_FIB:
	
	# TASK 2- SQUARE FUNCTION--------------------------------------------------------------------------------------------------------------------------------------
	
	la $s2, square			# square = $s2
	lw $s2, 0($s2)
	
	la $t0, square_fill
	lb  $s3, 0($t0)   		# square_fill = $s3
	
	la $t0, square_size
	lw $s4, 0($t0)   		# square_size = $s4
	
	beq $s2, $zero, AFTER_SQUARE	# if square = 0, don't execute square code
	
	addi $t9, $zero, 0		# row = 0
	
	LOOPTWO:
		
		slt $t1, $t9, $s4		# row < square_size
		beq $t1, $zero, AFTER_LOOPTWO	# if row >= square size, exit the loop
		
		addi $t3, $s4, -1		# square_size - 1
		
		la $t0, lr
		lb  $t1, 0($t0)       		# load lr into $t1
		
		la $t0, mid
		lb  $t2, 0($t0)      		# load mid into $t2
		
		
		beq $t9, $zero, TRUE_OR		# if row == 0, branch to true body
		beq $t9, $t3, TRUE_OR		# if row == square_size - 1, branch to true body
		
		
		addi $t1, $zero, 124   		# '|' is 124 in ASCII
		
		la $t0, lr        		# load the address of lr into $t0
		sb $t1, 0($t0)          	# store into lr
		
		la $t0, mid
		sb $s3, 0($t0)			# mid = square_fill
		
		j AFTER_OR
		
		TRUE_OR:
		
			addi $t1, $zero, 43		# '+' is 43 in ASCII
			
			la $t0, lr
			sb $t1, 0($t0)          		# store + into lr
			
			addi $t2, $zero, 45   		# '-' is 45 in ASCII
			
			la $t0, mid
			sb $t2, 0($t0)         		# store into mid
			
		AFTER_OR:
		
		# NOW load the updated values
        	la $t0, lr
        	lb $t1, 0($t0)          # load lr into $t1
        
        	la $t0, mid
        	lb $t2, 0($t0)          # load mid into $t2
		
		addi $t6, $zero, 1		# $t6 = 1 for comparison
		slt $t5, $t6, $s4		# 1 < square_size
		beq $t5, $zero, AFTER_COMPARE	# if square_size <=1, do not execute this code
		
		addi $v0, $zero, 11
		addi $a0, $t1, 0		# copy value into $a0
		syscall
		
		addi $t5, $zero, 1		# i = 1
		
		LOOP_SQUARE:
		
			slt $t6, $t5, $t3			# i < square_size - 1
			beq $t6, $zero, BREAK_LOOP_SQUARE	# if i >= square_size - 1, break the loop
			
			addi $v0, $zero, 11
			addi $a0, $t2, 0		# copy value into $a0
			syscall
			
			addi $t5, $t5, 1		# i++
			
			j LOOP_SQUARE
			
		
		BREAK_LOOP_SQUARE:
		
		AFTER_COMPARE:
		
			addi $v0, $zero, 11
			addi $a0, $t1, 0
			syscall
		
			addi $v0, $zero, 4
			la $a0, newline			# load address of newline into $a0
			syscall
		
			addi $t9, $t9, 1		# row++
			j LOOPTWO
		
	AFTER_LOOPTWO:
	
		addi $v0, $zero, 4
		la $a0, newline			# load address of newline into $a0
		syscall
	

	AFTER_SQUARE:
	
	addi $t1, $zero, 0			# reset t registers for next task
	addi $t2, $zero, 0
	addi $t3, $zero, 0
	addi $t5, $zero, 0
	addi $t6, $zero, 0
	addi $t8, $zero, 0
	addi $t9, $zero, 0

	
	# TASK 3 CHECK THROUGH ARRAY OF ITEMS IN A LIST--------------------------------------------------------------------------------------------------------------------------
	
	la $s5, runCheck		# Load runCheck into $s5
	lw $s5, 0($s5)
	
	addi $t0, $zero, 1		# $t0 = 1 for comparison
	bne $s5, $t0, AFTER_RUN_CHECK	# if runCheck != 1, skip runcheck task
	
	la $t9, intArray_len		# load address of the length of array
	lw $t9, 0($t9)			# intArray_len = $t9
	
	addi $t3, $zero, 0		# variable for ascending
	addi $t4, $zero, 0		# variable for descending
	
	slti $t2, $t9, 2		# if len(array) < 2, it is neither ascending and descending
	beq $t2, $zero, VALID_LEN
	j EXIT_LOOP_RUNCHECK		# want to skip the for loop in these cases
	
	VALID_LEN:
	
		addi $t9, $t9, -1		# For the loop we want to make sure we dont go out of bounds for i+1
	
		la $t8, intArray 		# intArray is located at address $t8
	
		addi $t1, $zero, 0		# i = 0 for the for loop
	
	LOOP_RUNCHECK:
	
		slt $t2, $t1, $t9			# while i < intArray_len
		beq $t2, $zero, EXIT_LOOP_RUNCHECK	# if i >= intArray_len, break the loop
		
		sll $t7, $t1, 2        			# $t7 = i * 4   (shift left by 2 is faster/clearer)
		add $t6, $t8, $t7      			# $t6 = base address + i*4 = &a[i]
		lw  $s2, 0($t6)        			# load a[i] into $s2
		lw  $s3, 4($t6)        			# s3 = a[i+1]
		
		slt $t5, $s2, $s3      			# a[i+1] < a[i]
		bne $t5, $zero, ASCENDINGLOOP		# If next element is less than current, the list is descending
		
		slt $t5, $s3, $s2      			# $t5 = 1 if a[i+1] < a[i] (descending order)
    		bne $t5, $zero, DESCENDINGLOOP
		
		j AFTER_CHECK
		
		ASCENDINGLOOP:
			addi $t3, $t3, 1		# Add 1 to ascending to show that the array is ascending
			j AFTER_CHECK
		
		DESCENDINGLOOP:
			addi $t4, $t4, 1		# increment descending counter
			j AFTER_CHECK
		
		AFTER_CHECK:
		addi $t1, $t1, 1 	# i++
		j LOOP_RUNCHECK    	

	EXIT_LOOP_RUNCHECK:
	
	beq $t3, $zero, CHECK_T4_ONLY    # if $t3 is zero, can't both be non-zero
	beq $t4, $zero, CHECK_T3_ONLY    # if $t4 is zero, can't both be non-zero
	
	j BOTH			 # both are nonzero, so ascending and descending

	CHECK_T4_ONLY:
    		bne $t4, $zero, DESCENDING     # only $t4 is non-zero → ascending
    		j NEITHER                     # both are zero → neither

	CHECK_T3_ONLY:
    
    		j ASCENDING
	
	ASCENDING:			# the array is ascending
	
		addi $v0, $zero, 4
		la $a0, ascending		# load address of newline into $a0
		syscall
		
		j END_RUNCHECK
		
	DESCENDING:			# the array is descending
		
		addi $v0, $zero, 4
		la $a0, descending		# load address of newline into $a0
		syscall
		
		j END_RUNCHECK
	
	NEITHER:
		addi $v0, $zero, 4
		la $a0, neither 		# load address of newline into $a0
		syscall
		j END_RUNCHECK
		
	BOTH:
	
		addi $v0, $zero, 4
		la $a0, ascending		# load address of newline into $a0
		syscall
		
		addi $v0, $zero, 4
		la   $a0, newline          # load address of newline string
		syscall
		
		addi $v0, $zero, 4
		la $a0, descending		# load address of newline into $a0
		syscall

		
	END_RUNCHECK:
	
	addi $v0, $zero, 4
	la   $a0, newline          # load address of newline string
	syscall

	addi $v0, $zero, 4
	la   $a0, newline          # again for second newline
	syscall
	
	AFTER_RUN_CHECK:
	
	addi $t0, $zero, 0		# reset t registers for next task
	addi $t1, $zero, 0
	addi $t2, $zero, 0
	addi $t3, $zero, 0
	addi $t4, $zero, 0
	addi $t5, $zero, 0
	addi $t6, $zero, 0
	addi $t7, $zero, 0
	addi $t8, $zero, 0
	addi $t9, $zero, 0

	
	# TASK 4: COUNT WORDS-------------------------------------------------------------------------------------------------------------------------------------------------------
	
	la $t6, countWords		# Load countWords into $t6
	lw $t6, 0($t6)
	
	addi $t0, $zero, 1		# $t0 = 1 for comparison
	
	bne $t6, $t0, AFTER_COUNT_WORDS
	
	addi $t0, $zero, 0		# $t0 = word counter
	
	addi $t1, $zero, 0		# $t1 = null terminator, if not zero, exit loop
	
	addi $t5, $zero, 0		# $t5 is the flag for if we are in or out of a word
	
	la   $t2, str       		# load address of string
	
	LOOP_COUNTWORDS:
		lb   $t1, 0($t2)     			# load current byte
		beq  $t1, $zero, EXIT_LOOP_COUNTWORDS 	# if null terminator, exit loop
		
		addi $t3, $t1, -32			# ASCII for space is 32
		addi $t4, $t1, -10			# ASCII for newline is 10
		
		beq $t3, $zero, SPACE_NEWLINE			# the current byte is a space
		
		beq $t4, $zero, SPACE_NEWLINE			# the current byte is a newline
		
		bne $t5, $zero, AFTER_WORD_COMPARES
		
		addi $t0, $t0, 1			# wordCounter++
		
		addi $t5, $zero, 1			# We are in a word now
	
		j AFTER_WORD_COMPARES
		
		SPACE_NEWLINE:
		
		addi $t5, $zero, 0			# Outside of a word
		
		AFTER_WORD_COMPARES:
		
		addi $t2, $t2, 1			# move to the next byte
		j LOOP_COUNTWORDS

	EXIT_LOOP_COUNTWORDS:
	
	addi $v0, $zero, 4
	la $a0, wordcount
	syscall
	
	addi $v0, $zero, 1
	add $a0, $t0, $zero
	syscall
	
	addi $v0, $zero, 4
	la   $a0, newline          # load address of newline string
	syscall

	addi $v0, $zero, 4
	la   $a0, newline          # again for second newline
	syscall
   	
	AFTER_COUNT_WORDS:
	
	addi $t0, $zero, 0	# reset t registers for next task
	addi $t1, $zero, 0
	addi $t2, $zero, 0
	addi $t3, $zero, 0
	addi $t4, $zero, 0
	addi $t5, $zero, 0

	# TASK 5, REVSTRING---------------------------------------------------------------------------------------------------------------------------------------------------------
	
	la $s7, revString		# Load revStringinto $s7
	lw $t0, 0($s7)
	
	la $s0, str			# load str into $s0
	
	addi $t1, $zero, 1		# $t0 = 1 for comparison
	
	bne $t0, $t1, AFTER_REVSTRING
	
	addi $t1, $zero, 0		# head = 0
	addi $t2, $zero, 0		# tail = 0
	addi $t3, $zero, 0		# Null character terminator for comparison
	
	LOOP_FIND_TAIL:
		add $t6, $s0, $t2               # base address + tail offset
		lb $t9, 0($t6)			# Load current byte of the word
		
		beq $t9, $t3, BREAK_TAIL_LOOP	# If str[tail] == '\0', end loop
		
		addi $t2, $t2, 1			# tail++
		j LOOP_FIND_TAIL
		
	BREAK_TAIL_LOOP:
	
	addi $t2, $t2, -1		# tail--
	
	LOOP_SWAP_CHARS:
	
		slt $t8, $t1, $t2			# head < tail
		beq $t8, $zero, BREAK_SWAP_CHARS	# If head >= tail, exit the loop
		
		add $t6, $s0, $t1   # head address
		add $t7, $s0, $t2   # tail address

		lb $t8, 0($t6)   # load head value into temp
		lb $t9, 0($t7)   # load tail value
		
		sb $t9, 0($t6)   # store tail at head address
		sb $t8, 0($t7)   # store head at tail address

		addi $t1, $t1, 1			# head++
		addi $t2, $t2, -1			# tail--
		
		j LOOP_SWAP_CHARS
	
	
	BREAK_SWAP_CHARS:
	
	addi $v0, $zero, 4
	la $a0, swapstring
	syscall
	
	addi $v0, $zero, 4
	la $a0, newline
	syscall
	
	AFTER_REVSTRING:
	
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the frame pointer of caller
	addiu $sp, $sp, 24 	# restore the stack pointer of caller
	jr $ra 			# return to code of caller
