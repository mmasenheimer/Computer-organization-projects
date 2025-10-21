.data

newline:       .asciiz "\n"
newlinex:      .asciiz "!\n"
nobottles:     .asciiz "No more bottles of "
bottlesof:     .asciiz " bottles of "
takeonedown:   .asciiz "Take one down, pass it around, "
onthewallcomma:.asciiz " on the wall, "
onthewallperiod:.asciiz " on the wall.\n"
onthewallfinal:.asciiz " on the wall!\n"
onthewallexit: .asciiz " on the wall!"

.text

.globl strlen
.globl gcf
.globl bottles
.globl longestSorted
.globl rotateShort
.globl rotateLong

# FUNCTION 1: STRLEN()

# strlen() {
#	count = 0
#	while {currByte} != '\0':
#		count++
#	return count
#
# REGISTERS:
#
# $a0-address of the string
# $s0-character count variable

strlen:
	addi $sp, $sp, -8	# Allocate 8 bytes onto the stack
    	sw   $ra, 4($sp)	# Save return address
    	sw   $s0, 0($sp)	# Save $s0 for character counter
    	
    	addi $s0, $zero, 0	# Count = 0
    	
    	LOOP_STRLEN:
    	
    		lb $t0, 0($a0)				# Load the current byte of the string
    		beq $t0, $zero, AFTER_LOOP_STRLEN	# If current char is '\0', break the loop
    		
    		addi $s0, $s0, 1			# Count = count + 1
    		addi $a0, $a0, 1			# Ptr = Ptr + 1

    		j LOOP_STRLEN
    	
    	AFTER_LOOP_STRLEN:

    	add $v0, $s0, $zero     # Return value = count
    	lw   $s0, 0($sp)	# Restore saved register
    	lw   $ra, 4($sp)	# Restore return address
    	addi $sp, $sp, 8	# De-allocate space on the stack
    	jr   $ra		# Return to caller

# FUNCTION 2: GCF

# int gcf(int a, int b) {
#	if (a < b) {
#		a, b = b, a;
#	} if (b == 1) {
#		return 1;
#	} if (a % b == 0) {
#		return b
#	} else {
#		return gcf(b, a % b);
#	}
# }
#
# REGISTERS:
#
# $a0 = a
# $a1 = b
# various tX registers for comparison and slt

gcf:
	addi $sp, $sp, -12		# Allocate 12 bytes on the stack
    	sw $ra, 8($sp)			# Save return address
    	sw $a0, 4($sp)			# Save a
    	sw $a1, 0($sp)			# Save b
    	
    	slt $t0, $a0, $a1		# a < b
    	beq $t0, $zero, NEXT_ONE	# If a < b, continue to next if clause
    	
    	add  $t2, $zero, $a0   		# temp = a
    	add  $a0, $zero, $a1   		# a = b
    	add  $a1, $zero, $t2   		# b = temp

    	NEXT_ONE:
    	
    	addi $t8, $zero, 1		# t8 = 1 for comparison
    	
    	bne $a1, $t8, NEXT_TWO		# b != 1

    	addi $v0, $zero, 1		# Return 1
    	
    	j EXIT_GCF
    	
    	NEXT_TWO:
    	
    	div  $a0, $a1     		# Divide a by b
    	mfhi $t7           		# Move remainder into t7
    	
    	bne $t7, $zero, ELSE		# If a % b != 0
    	
    	add $v0, $a1, $zero		# Return b
    	
    	j EXIT_GCF
    	
    	ELSE:
    	
    	add $a0, $a1, $zero     	# B = first param
    	add $a1, $t7, $zero     	# a % b
    	jal gcf				# Return gcf(b, a % b)
    	
    	EXIT_GCF:
    	
    	lw $ra, 8($sp)			# Restore the caller address
    	addi $sp, $sp, 12		# De-allocate 12 bytes on the stack
    	jr $ra				# Return to caller
    	
# void bottles(int count, char *thing) {
#	for (int i=count; i > 0; i--) {
#		printf("%d bottles of %s on the wall, %d bottles of %s!\n",
#			i,thing, i,thing);
#		printf("Take one down, pass it around, %d bottles of %s on the wall.\n",
#			i-1,thing);
#		printf("\n");
#	}
#	printf("No more bottles of %s on the wall!\n", thing);
#	printf("\n");
# }
# REGISTERS:
#
# $a0 = count
# $a1 = reference to the string (item)
# vaious tX registers for comparison


bottles:
	addi $sp, $sp, -12		# Allocate 12 bytes on the stack
    	sw $ra, 8($sp)			# Save return address
    	sw $a0, 4($sp)			# Save count
    	sw $a1, 0($sp)			# Save reference to the string
    	
    	addi $t0, $a0, 0		# int i = count
    	
    	LOOP_BOTTLES:
    	
    		slt $t1, $zero, $t0		# 0 < i
    		beq $t1, $zero, EXIT		# if 0 >= 1, exit loop
    		
    		# First printf
    		
    		addi $v0, $zero, 1		# Print_int(count)
    		add $a0, $t0, $zero
    		syscall
    		
    		addi $v0, $zero, 4		# Print_str(" bottles of ")
    		la $a0, bottlesof
    		syscall
    		
    		addi $v0, $zero, 4		# Print_str(" {item}")
    		lw $a0, 0($sp)  		
    		syscall
    		
    		addi $v0, $zero, 4		# Print_str(" on the wall, ")
    		la $a0, onthewallcomma
    		syscall
    		
    		addi $v0, $zero, 1		# Print_int(count)
    		add $a0, $t0, $zero
    		syscall
    		
    		addi $v0, $zero, 4		# Print_str(" bottles of ")
    		la $a0, bottlesof
    		syscall
    		
    		lw $a0, 0($sp)			# Print_str(" {item}")
    		addi $v0, $zero, 4		
    		syscall
    		
    		addi $v0, $zero, 4		# Print_str(" !\n")
    		la $a0, newlinex
    		syscall
    		
    		# Second printf
    		
    		addi $t3, $t0, -1
    		
    		addi $v0, $zero, 4		# Print_str("Take one down, pass it around, ")
    		la $a0, takeonedown
    		syscall
    		
    		addi $v0, $zero, 1		# Print_int(count - 1)
    		add $a0, $t3, $zero
    		syscall
    		
    		addi $v0, $zero, 4		# Print_str(" bottles of ")
    		la $a0, bottlesof
    		syscall
    		
    		lw $a0, 0($sp)			# Print_str(" {item}")
    		addi $v0, $zero, 4		
    		syscall
    		
    		addi $v0, $zero, 4		# Print_str(" on the wall.\n")
    		la $a0, onthewallperiod
    		syscall
    		
    		addi $v0, $zero, 4		# print_str("\n")
		la $a0, newline			
		syscall
    		
    		addi $t0, $t0, -1		# i--
    		j LOOP_BOTTLES
    	
    	EXIT:
    	
    	addi $v0, $zero, 4	# Print_str("No more bottles of ")
    	la $a0, nobottles
    	syscall
    	
    	lw $a0, 0($sp)		# Print_str(" {item}")
    	addi $v0, $zero, 4
    	syscall
    	
    	addi $v0, $zero, 4	# Print_str(" on the wall, ")
    	la $a0, onthewallfinal
    	syscall
    	
    	addi $v0, $zero, 4	# print_str("\n")
	la $a0, newline			
	syscall
	
	lw $ra, 8($sp)		# Restore return address
    	addi $sp, $sp, 12	# Deallocate 12 bytes back to the stack
    	jr $ra
    	
# Function 4- int longestSorted(int *array, int len)
#
# int finalCoiunt = 1
# int currCount = 1
#
# if (nums.size == 0) {
#	return 0
# }
#
# for i in range(len(nums) - 1) {
#	if (nums[i+1] == nums[i] + 1) {
#		currCount += 1
#	} else {
#		if (currCount > finalCount {
#			finalCount = currCount
#		} currCount = 1
# return finalCount
#
# REGISTERS:
#
# $a0 - pointer to the location of the array
# $a1 - len(array)
# Various tX registers for comparison and indexing

longestSorted:

	addi $sp, $sp, -16		# Allocate 20 bytes on the stack
	sw $ra, 12($sp)			# Save return address
	sw $s0, 8($sp)			# Save $s0
    	sw $a0, 4($sp)			# Save pointer to array
    	sw $a1, 0($sp)			# Save len of array
    	
    	beq $a1, $zero, RETURN_ZERO	# If len(array) != 0, do the function
    	
    	j LONGEST_SORTED
    	
    	RETURN_ZERO:
    	
    		addi $v0, $zero, 0		# Return 0
    		lw $a1, 0($sp)			# Restore len of array
    		lw $a0, 4($sp)			# Restor pointer to the array
    		lw $s0, 8($sp)			# Restore $s0
    		lw $ra, 12($sp)			# Load the return address
    		addi $sp, $sp, 16		# 16 bytes back to the stack
    		jr $ra
    	
    	LONGEST_SORTED:
    	lw $a0, 4($sp)    		# Reload pointer to array
	lw $a1, 0($sp)    		# Reload length

    	addi $s0, $zero, 1		# finalCount = 1
    	addi $t2, $zero, 1		# Currcount = 1
    	
    	addi $t0, $zero, 0		# int i = 0
    	addi $t3, $a1, -1		# t3 = len(array) - 1 (for the loop)
    	
    	LOOP_LONGEST_SORTED:
    	
    		slt $t1, $t0, $t3			# i < len(array) - 1
    		beq $t1, $zero, EXIT_LOOP_ARRAY_SORT	# if i >= len(array), break the loop
    		
    		sll $t6, $t0, 2   			# $t6 = $t0 * 4
    		add $t6, $t6, $a0  			# $t0 now contains address of array[i]
  
    		lw $t1, 0($t6)     			# $t1 = nums[i]
    		lw $t4, 4($t6)				# $t4 = nums[i+1]
    		
    		slt $t5, $t4, $t1			# $t5 = 1 if nums[i] < nums[i+1]
    		bne $t5, $zero, ELSE_SORTED		# if not consecutive, go to else
    		
    		addi $t2, $t2, 1			# CurrCount += 1
    		addi $t0, $t0, 1			# i++
    		j LOOP_LONGEST_SORTED			# Skip else block
    		
    		ELSE_SORTED:
    			
    			slt $t9, $s0, $t2		# finalCount < currCount
    			beq $t9, $zero, SKIP_UPDATE	# Update count but don't update final count
    			
    			add $s0, $t2, $zero		# FinalCount = CurrentCount
    			
    		SKIP_UPDATE:
    			addi $t2, $zero, 1		# Reset currCount = 1
    			addi $t0, $t0, 1		# i++
    			j LOOP_LONGEST_SORTED
    		
    	EXIT_LOOP_ARRAY_SORT:
    	
    	slt  $t9, $s0, $t2           		# Final check for if currArrayTotal > finalArraytotal
    	beq  $t9, $zero, RETURN_RESULT		# If it's not greater, exit
    	add $s0, $t2, $zero			# finalCount = currentCount
    	
    	RETURN_RESULT:
    	
    	add $v0, $s0, $zero     	# Return value = finalCount
    	
    	lw $a1, 0($sp)			# Load the lengh of the array
    	lw $a0, 4($sp)			# Load the pointer to the array itself
    	lw $s0, 8($sp)			# Restore $s0
    	lw $ra, 12($sp)			# Load the return address
    	addi $sp, $sp, 16		# Add the 20 bytes back onto the stack
    	jr $ra
    	
# FUNCTION 5 PART A- rotateShort()

# int rotateShort(int count, int a, int b, int c) {
#	int retval = 0;
#	for (int i = 0; i < count; i++) {
#		retval += utilShort(a,b,c);
#			int tmp = a;
#			a = b;
#			b = c
#			c = tmp;
#	}
#	return retval;
# }
#
# REGISTERS:
# $a0 = count
# $a1 = a
# $a2 = b
# $a3 = c
# $s0 = retVal (later returned in $v0
# various $tX registers for comparison/temp variables

rotateShort:
	addi $sp, $sp, -28		# Allocate 28 bytes on the stack
    	sw $ra, 24($sp)			# Save return address
    	sw $s0, 20($sp)			# Save $s0
    	sw $a3, 16($sp)			# Save c
    	sw $a2, 12($sp)			# Save b
    	sw $a1, 8($sp)			# Save a
    	sw $a0, 4($sp)			# Save count
    	
    	addi $s0, $zero, 0		# int retval = 0
    	addi $t0, $zero, 0		# int i = 0
    	
    	LOOP_ROTATE_SHORT:
    		
    		lw $a0, 4($sp)				# Load count for comparison
    		slt $t1, $t0, $a0			# i < count
    		beq $t1, $zero, EXIT_LOOP_ROTATE_SHORT	# if i>= count, break the loop
    		
    		lw $a0, 8($sp)    			# Load a
		lw $a1, 12($sp)    			# Load b
		lw $a2, 16($sp)   			# Load c
		
		sw $t0, 0($sp)				# Save loop counter
		
		jal utilShort				# Call utilShort with a, b, c parameters
		
		lw $t0, 0($sp)				# Restore loop counter
    		
    		addu $s0, $s0, $v0			# retval += utilShort(a, b, c)
    		
    		lw $t3, 8($sp)				# tmp = a
    		
    		lw  $t1, 12($sp)    			# Load b
		sw  $t1, 8($sp)    			# a = b
		
		lw  $t2, 16($sp)   			# Load c
		sw  $t2, 12($sp)    			# b = c
		
		sw  $t3, 16($sp)   			# c = tmp
   
    		addi $t0, $t0, 1			# i++
    	
    		j LOOP_ROTATE_SHORT
    	
    	EXIT_LOOP_ROTATE_SHORT:
    	
    	add $v0, $zero, $s0		# Add return value, retval
    	lw $s0, 20($sp)			# Restore $s0
    	lw $ra, 24($sp)			# Restore return address
    	addi $sp, $sp, 28		# Deallocate 28 bytes on the stack
    	
    	jr $ra

# FUNCTION 5 PART B- int rotateLong()
# int rotateLong(int count, int a, int b, int c, int d, int e, int f) {
#	int retval = 0;
#	for (int i = 0; i < count; i++) {
#		retval += utilLong(a,b,c, d, e, f);
#			int tmp = a;
#			a = b;
#			b = c;
#			c = d;
#			d = e;
#			e = f;
#			f = tmp;
#	}
#	return retval;
# }
#
# REGISTERS:
#
# $t0 = d
# $t1 = e
# $t2 = f
# $s0 = retval
# tX registers for swapping

rotateLong:

	lw $t0, -12($sp)           # Load in d
    	lw $t1, -8($sp)            # Load in e
    	lw $t2, -4($sp)            # Load in f

    	addi $sp, $sp, -40         # Allocate 40 bytes on the stack
    	sw $ra, 36($sp)            # Save return address
    	sw $s0, 32($sp)            # Save $s0

    	sw $a0, 0($sp)             # Save count
    	sw $a1, 4($sp)             # Save a
    	sw $a2, 8($sp)             # Save b
    	sw $a3, 12($sp)            # Save c
    	sw $t0, 16($sp)            # Load in d
    	sw $t1, 20($sp)            # Load in e
    	sw $t2, 24($sp)            # Load in f

    	addi $s0, $zero, 0         # int retval = 0
    	addi $t9, $zero, 0         # int i = 0

	LOOP_ROTATE_LONG:
	
    		lw $a0, 0($sp)             # reload count
    		slt $t8, $t9, $a0          # i < count
    		
    		beq $t8, $zero, EXIT_LOOP_ROTATE_LONG   # if i>= count, break the loop

    		lw $a0, 4($sp)             # Load a
    		lw $a1, 8($sp)             # Load b
    		lw $a2, 12($sp)            # Load c
    		lw $a3, 16($sp)            # Load d
    		lw $t0, 20($sp)            # Load e (5th argument stack push)
    		lw $t1, 24($sp)            # Load f (6th argument stack push)
    
    		sw $t9, 28($sp)	       	   # Save loop counter between calls

    		sw $t0, -8($sp)             # Store e as arg 5
    		sw $t1, -4($sp)             # Store f as arg 6

    		jal utilLong               # Call utilShort with a, b, c, d, e, f parameters

    		lw $t9, 28($sp)            # load loop counter from before the call

    		addu $s0, $s0, $v0         # retval += utilShort(a, b, c, d, e, f)

    		lw $t2, 4($sp)             # tmp = a
    		lw $t3, 8($sp)             # b
    		lw $t4, 12($sp)            # c
    		lw $t5, 16($sp)            # d
    		lw $t6, 20($sp)            # e
    		lw $t7, 24($sp)            # f

    		sw $t3, 4($sp)             # a = b
    		sw $t4, 8($sp)             # b = c
    		sw $t5, 12($sp)            # c = d
    		sw $t6, 16($sp)            # d = e
    		sw $t7, 20($sp)            # e = f
    		sw $t2, 24($sp)            # f = tmp

    		addi $t9, $t9, 1           # i++
    		j LOOP_ROTATE_LONG

	EXIT_LOOP_ROTATE_LONG:
	
    	addu $v0, $s0, $zero       # Add return value, retval
    	lw $s0, 32($sp)            # Restore $s0
    	lw $ra, 36($sp)            # Restore return address
    	addi $sp, $sp, 40          # Deallocate 40 bytes on the stack
    	jr $ra