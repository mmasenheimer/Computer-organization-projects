.data

sorted:    .asciiz      "Sort Results: "
space:     .asciiz      " "
newline:   .asciiz      "\n"
current:   .asciiz      "Cur Values: "

less:      .asciiz      "LESS"
more:      .asciiz      "MORE"

.text
.globl studentMain

studentMain:
	addiu $sp, $sp, -24      # allocate stack space -- default of 24 here
	sw $fp, 0($sp)           # save frame pointer of caller
	sw $ra, 4($sp)           # save return address
	addiu $fp, $sp, 20       # setup frame pointer of main
	
	la $t0, sort             # load address of sort
	lw $t1, 0($t0)           # $t1 = sort
	
	la $t0, compare          # load address of compare
	lw $t2, 0($t0)           # $t2 = compare
	
	la $t0, swap             # load address of swap
	lw $t3, 0($t0) 		 # $t3 = swap
	
	la $t0, print  		 # load address of print
	lw $t4, 0($t0) 		 # $t4 = print
	
	la   $t0, alpha 	 # Load address of alpha
	lw   $t5, 0($t0) 	 # $t5 = alpha

	la   $t0, bravo 	 # Load address of bravo
	lw   $t6, 0($t0)  	 # $t6 = bravo

	la   $t0, charlie 	 # Load address of charlie
	lw   $t7, 0($t0)  	 # $t7 = charlie

	la   $t0, delta 	 # Load address of delta
	lw   $t8, 0($t0) 	 # $t8 = delta
	
	addiu $t9, $zero, 1   	 # $t9 = 1 for comparison
	bne $t1, $t9, JUMP_SORT  # If sort = 1, run sort code else jump to next instruction
	
	LOOP_START: 		 # Loop to be running for swaps REGISTERS WILL DIFFER
	
    		addiu $t9, $zero, 0   		# Temp variable = 0

    		slt $s0, $t6, $t5      		# $s0 = 1 if $t6 > $t5
    		beq $s0, $zero, CONTINUE 	# If $s6 > $t5, run the swap code
    		
    		addu $s1, $t5, $zero   		# tmp = $t5
    		addu $t5, $t6, $zero   		# $t5 = $t6
    		addu $t6, $s1, $zero   		# $t6 = tmp

    		addi $t9, $t9, 1       		# $t9 ++ if this swap happened

		CONTINUE:
    			
    			slt $s3, $t6, $t7       	# if $t6 < $t7, then $s3 = 1
    			bne $s3, $zero, CONTINUE_AGAIN  # If $s3 = 1, swap

    			addu $s5, $t6, $zero   		# tmp = $t6
    			addu $t6, $t7, $zero   		# $t6 = $t7
    			addu $t7, $s5, $zero   		# $t7 = tmp

    			addi $t9, $t9, 1       		# $t9 ++ if a swap happened

		CONTINUE_AGAIN:

    			beq $t9, $zero, LOOP_EXIT 	# if no swaps happened ($t9 = 0), end loop
    			j LOOP_START			# If there was a swap, restart the loop

	LOOP_EXIT:
	
		la $a0, sorted      		# Print "Sort Results: "
		addiu $v0, $zero, 4 		# Syscall 4 = print string
		syscall

		addu $a0, $t5, $zero		# Print first value
		addiu $v0, $zero, 1 		# Syscall 1 = print integer
		syscall

		la $a0, space			# Print " "
		addiu $v0, $zero, 4		# Syscall 4 = print string
		syscall

		addu $a0, $t6, $zero		# Print second value
		addiu $v0, $zero, 1		# Syscall 1 = print integer
		syscall

		la $a0, space			# Print " "
		addiu $v0, $zero, 4		# Syscall 4 = print string
		syscall

		addu $a0, $t7, $zero		# Print third value
		addiu $v0, $zero, 1		# Syscall 1 = print integer
		syscall

		la $a0, newline			# Print a "\n"
		addiu $v0, $zero, 4		# Syscall 4 = print string
		syscall

		j JUMP_SORT

	JUMP_SORT:
	
	addiu $t9, $zero, 1   		# $t9 = 1 for comparison
	bne $t2, $t9, JUMP_COMPARE 	# If $t2 = 1, run compare code else skip it
	
	la $t0, bravo			# Load address of bravo
	lw $s6, 0($t0)      		# Place bravo into $s6
	
	la $t0, charlie			# Load address of charlie
	lw $s7, 0($t0)      		# Place charlie into $s7
	
	slt $t0, $s6, $s7       	# $t0 = 1 if bravo < charlie
	bne $t0, $zero, PRINT_LESS	# If bravo < charlie, jump to LESS line
	
	slt $t0, $s7, $s6       	# $t0 = 1 if charlie < bravo
	bne $t0, $zero, PRINT_MORE	# If charlie < bravo, jump to MORE line
	
	PRINT_LESS:
		la $a0, less		# Print "LESS"
		addiu $v0, $zero, 4	# Syscall 4 = print string
		syscall
		j PRINT_COMPARE_NEWLINE	# Always print a new line
	
	PRINT_MORE:
		la $a0, more		# Print "MORE"
		addiu $v0, $zero, 4	# Syscall 4 = print string
		syscall
	
	PRINT_COMPARE_NEWLINE:
		la $a0, newline		# Print "\n"
		addiu $v0, $zero, 4	# Syscall 4 = print string
		syscall
	
	JUMP_COMPARE:
	
	addiu $t9, $zero, 1   		# $t9 = 1 for comparison 
	bne $t3, $t9, JUMP_SWAP 	# If swap = 1, run the code else move to JUMP_SWAP
	
	la $t0, alpha			# Load address of alpha
	lw $s2, 0($t0)      		# Place alpha into $s2
	
	la $t0, bravo			# Load address of bravo
	lw $s3, 0($t0)      		# Place bravo into $s3
	
	la $t0, charlie			# Load address of charlie
	lw $s4, 0($t0)      		# Place charlie into $s4
	
	la $t0, delta			# Load address of delta
	lw $s5, 0($t0)      		# Place delta into $s5
	
	# Switching alpha and bravo
	addu $s0, $s2, $zero   		# tmp = alpha
	addu $t5, $s3, $zero   		# alpha = bravo
	addu $t6, $s0, $zero   		# bravo = tmp
	
	# Swtiching charlie with delta
	addu $s1, $s4, $zero   		# tmp = charlie
	addu $t7, $s5, $zero   		# charlie = delta
	addu $t8, $s1, $zero   		# delta = tmp

	la $t0, alpha			# Update address of alpha
	sw $t5, 0($t0)     		# Save word into the alpha address

	la $t0, bravo			# Update address of bravo
	sw $t6, 0($t0)     		# Save word into the bravo address

	la $t0, charlie			# Update the address of charlie
	sw $t7, 0($t0)     		# Save word into the charlie address

	la $t0, delta			# Update the address of delta
	sw $t8, 0($t0)			# Save word into the delta address
	
	JUMP_SWAP:
	addiu $t9, $zero, 1   		# $t9 = 1 for comparison
	bne $t4, $t9, JUMP_PRINT 	# If print = 1, run the code else jump to the end
	
	la $t0, alpha			# Load address of alpha
	lw $t5, 0($t0)			# Place alpha in $t5
	
	la $t0, bravo			# Load address of bravo
	lw $t6, 0($t0)			# Place bravo into $t6
	
	la $t0, charlie			# Load address of charlie
	lw $t7, 0($t0)			# Place charlie into $t7
	
	la $t0, delta			# Load address of delta
	lw $t8, 0($t0)			# Place delta into $t8

	la $a0, current			# Print "Cur Values: "
	addiu $v0, $zero, 4		# Syscall = 4 for string
	syscall	

	addu $a0, $t5, $zero		# Print the first value
	addiu $v0, $zero, 1		# Syscall = 1 for integer
	syscall

	la $a0, space			# Print " "
	addiu $v0, $zero, 4		# Syscall = 4 for string
	syscall

	addu $a0, $t6, $zero		# Print the second value
	addiu $v0, $zero, 1		# Syscall = 4 for integer
	syscall

	la $a0, space			# Pring another " "
	addiu $v0, $zero, 4		# Syscall = 4 for strng
	syscall

	addu $a0, $t7, $zero		# Print the thirdd value
	addiu $v0, $zero, 1		# Syscall = 1 for integer
	syscall

	la $a0, space			# Print another " "
	addiu $v0, $zero, 4		# Syscall = 4 for string
	syscall

	addu $a0, $t8, $zero		# Print the fourth value
	addiu $v0, $zero, 1		# Syscall = 1 for integer
	syscall

	la $a0, newline			# Print "\n"
	addiu $v0, $zero, 4		# Syscall = 4 for string
	syscall

	JUMP_PRINT:
	
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the frame pointer of caller
	addiu $sp, $sp, 24 	# restore the stack pointer of caller
	jr $ra 			# return to code of caller
