# Michael Masenheimer
# CSC 252 
# ASIM  6- toys (two different sorting algorithms)
# Purpose: This MIPS project was given so I can create
# something interesting to me. I chose to do a few different
# sorting algorithms with timing since we are learning about them
# in CSC 345 and I think it's interesting to compare the speeds
# of sorting algorithms.

.data

array1:   		.word 64, 34, 25, 12, 22, 11, 90, 88, 45, 50  	# Array to sort using insertion sort
size1:    		.word 10                                      	# Size of array

array2:	  		.word 73, 2, 65, 9, 73, 2, 1, 45, 7, 79		# Array to sort using selection sort
size2:	  		.word 10					# Size of array 2

space:    		.asciiz " " 
newline:  		.asciiz "\n"
insertion_header: 	.asciiz "=== INSERTION SORT ===\n"
selection_header: 	.asciiz "=== SELECTION SORT ===\n"

time_msg: 		.asciiz "Time elapsed: "
ms_msg:   		.asciiz " ms\n"

.text

.globl mainInsertion
.globl mainSelection
.globl main

main:

    jal mainInsertion		# Call insertion sort (This will handle the arrays)
    
    la $a0, newline		# Print out a new line for formatting between sorts
    li $v0, 4			# Syscall 4 for printing out a string
    syscall
    
    jal mainSelection		# Call selection sort (Also handles the arrays)
    
    li $v0, 10			# Exit the program here (I found this is good practice from a stack overflow forum)
    syscall

mainInsertion:

    	addi $sp, $sp, -8		# Allocate 8 bytes on the stack
    	sw $ra, 4($sp)			# Save return address
    	sw $s0, 0($sp)			# Save s0 for start time
    	
    	li $v0, 30			# Syscall 30 for start time
	syscall
	
	move $s0, $a0			# Save start time in s0
    	
	la $a0, insertion_header	# Print the insertion sort header
	li $v0, 4			# Syscall 4 for string
	syscall

    	la $a0, array1			# Print original array (unsorted first)
    	lw $a1, size1			# Print array function needs 2 args, the array itself and the size
    	jal print_array
    
    	la $a0, array1			# Insertion sort also needs the array as arg 1
    	lw $a1, size1			# Size of array in arg 2
    	jal insertion_sort		# Call insertion sort
    
    	la $a0, array1			# Print the sorted array (After sorting), arg 1 is the array
    	lw $a1, size1			# print rry needs the size as the second argument
    	jal print_array
    	
    	
    	li $v0, 30			# Syscall 30 for end time
    	syscall
    	
    	sub $a0, $a0, $s0		# Calculate elapsed time (stop mnus start time)
    	
    	# This code prints out the time elapsed for the sorting methods
    	move $t0, $a0			# Save elapsed time into t0
    	
    	la $a0, time_msg		# Print time message out
    	li $v0, 4			# Syscall 4 for string
    	syscall
    	
    	move $a0, $t0			# Actual time
    	li $v0, 1			# Syscall 1 for int
    	syscall
    	
    	la $a0, ms_msg			# Print out milliseconds message
    	li $v0, 4			# Syscall 4 for print string
    	syscall
    
    	lw $ra, 4($sp)			# Restore return address
    	lw $s0, 0($sp)			# Restore s0
    	addi $sp, $sp, 8		# Restore 4 bytes onto the stack
    	jr $ra

# insertion sort:
#
# for (int i = 1; i < size; i++) {
#     int key = array[i];
#     int j = i - 1;
#     while (j >= 0 && array[j] > key) {
#         array[j + 1] = array[j];
#         j--;
#     }
#     array[j + 1] = key;
# }
#
# REGISTERS:
# $s0 = base address of the array
# $s1 = size of the array
# $s2 = i (outer loop counter)
# $s3 = key (current element being inserted)
# Various tX registers

insertion_sort:

    	addi $sp, $sp, -20		# Allocate 20 bytes onto the stack
    	sw $ra, 16($sp)			# Save return address
    	sw $s0, 12($sp)			# Save s0
    	sw $s1, 8($sp)			# Save s1
    	sw $s2, 4($sp)			# Save s2
    	sw $s3, 0($sp)			# Save s3
    
    	add $s0, $a0, $zero      	# $s0 is the base address of the array
    	add $s1, $a1, $zero      	# $s1 = size of the array
    	addi $s2, $s2, 1          	# $s2 = i which is the outer loop index variable
    
	outer_loop_insertion_sort:
	
    		bge $s2, $s1, FINISHED_INSERTION_SORT  # if i >= size of the array, break the loop
    
    		# This code loads the item i from the array
    		sll $t0, $s2, 2     			# $t0 = i * 4
    		add $t0, $s0, $t0   			# $t0 = address of array[i]
    		lw $s3, 0($t0)      			# $s3 = key = array[i]
    
    		addi $t1, $s2, -1   			# $t1 = j which is just i - 1
    
		inner_loop_insertion_sort:
		
    			bltz $t1, insert    	# if j < 0, we will insert the current key (this is branch less than 0)
    
    			# This code now loads the item at array index j
    			sll $t2, $t1, 2     	# $t2 = j * 4 which is address indexing, since each index is 4 bytes
    			add $t2, $s0, $t2   	# $t2 = address of array[j]
    			lw $t3, 0($t2)      	# $t3 = array[j]
    
    			ble $t3, $s3, insert	# if array[j] <= key, we insert the key
    
    			sw $t3, 4($t2)      	# array[j+1] = array[j]
    
    			addi $t1, $t1, -1   	# j-= 1
    			
    			j inner_loop_insertion_sort
    
		insert:
		
    		addi $t1, $t1, 1    		# j+1
    		sll $t2, $t1, 2     		# (j+1) * 4
    		add $t2, $s0, $t2   		# address of array at index [j+1]
    		sw $s3, 0($t2)      		# array[j+1] = key to be inserted
    
    		addi $s2, $s2, 1    		# i+= 1
    		j outer_loop_insertion_sort
    
FINISHED_INSERTION_SORT:
	
    	lw $ra, 16($sp)			# Restore return address
    	lw $s0, 12($sp)			# Restore s0
    	lw $s1, 8($sp)			# Restore s1
    	lw $s2, 4($sp)			# Restore s2
    	lw $s3, 0($sp)			# Restore s3
    	addi $sp, $sp, 20		# Resoree 20 bytes onto the stack
    	jr $ra				# Return
	
# Print Array in C:
# for (int i = 0; i < size; i++) {
#     printf("%d ", array[i]);
# }
# printf("\n");
#
#
#
#
#

print_array:
    	addi $sp, $sp, -16	# Allocate 16 bytes onto the stack
    	sw $ra, 12($sp)		# Save return address
    	sw $s0, 8($sp)		# Save s0 
    	sw $s1, 4($sp)		# Save s1
    	sw $s2, 0($sp)		# Save s2
    
    	move $s0, $a0      	# $s0 is the base address of the array
    	move $s1, $a1      	# $s1 is the size of the arrY
    	li $s2, 0          	# $s2 is the counter for the outer loop
    
	print_loop:
	
    		bge $s2, $s1, print_done	# If the counter i >= size, break out of the loop
    
   		# This code prints the item at array[i]
    		sll $t0, $s2, 2			# mult the counter by 4 to reach the desired index
    		add $t0, $s0, $t0		# add the offset to the base address
    		lw $a0, 0($t0)			# a0 = array[i]
    		li $v0, 1			# # Syscall 1 for printing integer
    		syscall
    
    		la $a0, space			# Print out a space in between indexes
    		li $v0, 4			# Syscall 4 for string
    		syscall
    
    		addi $s2, $s2, 1		# i += 1
    		j print_loop
    
	print_done:
    		
    		la $a0, newline			# Print newline
    		li $v0, 4			# Syscall 4 for printing string
    		syscall
    
    		lw $ra, 12($sp)			# Restore return addresss
    		lw $s0, 8($sp)			# Restore s0
    		lw $s1, 4($sp)			# Restore s1
    		lw $s2, 0($sp)			# Restore s2
    		addi $sp, $sp, 16		# Restore 16 bytes back to the stack
    		jr $ra				# Return

mainSelection:

    	addi $sp, $sp, -8		# Allocate 8 bytes onto the stack
    	sw $ra, 4($sp)			# Save return address
    	sw $s0, 0($sp)			# Save s0 for start time
    	
    	li $v0, 30			# Syscall 30 for start time
	syscall
	
	move $s0, $a0			# Save start time in s0
    	
    	la $a0, selection_header	# Print the selection sort header
	li $v0, 4			# Syscall 4 for string 
	syscall		
	
    	# Print original array, loading the array and its size into a0 a1
    	la $a0, array2			# a0 is the base address of array 2
    	lw $a1, size2			# a1 is the size of the array
    	
    	jal print_array			# Call print function on the original unsorted array
    
    	la $a0, array2			# Load array into arg 0 of the selection sort function
    	lw $a1, size2			# Load the size into arg 1 of the selection sert function
    	
    	jal selection_sort		# Call selection sort
    
    	# Print sorted array, loading the array and its size into a0 and a1
    	la $a0, array2			# Array 2 address into a0
    	lw $a1, size2			# Array 2 size 
    	jal print_array
    	
    	li $v0, 30			# Syscall 30 for end time
    	syscall
    	
    	sub $a0, $a0, $s0		# Calculate elapsed time (stop minus start time)
    	
    	# This code prints out the time elapsed for the sorting methods
    	move $t0, $a0			# Save elapsed time into t0
    	
    	la $a0, time_msg		# Print time message out
    	li $v0, 4			# Syscall 4 for string
    	syscall
    	
    	move $a0, $t0			# Aa0 holds the final time now
    	li $v0, 1			# Syscall 1 for int
    	syscall
    	
    	la $a0, ms_msg			# Print out milliseconds message
    	li $v0, 4			# Syscall 4 for string
    	syscall

    	lw $ra, 4($sp)			# Restore the return address
    	lw $s0, 0($sp)			# Restore s0
    	addi $sp, $sp, 8		# Restore 8 bytes onto the stack
    	jr $ra				# Return

# Selection Sort in C:
# for (int i = 0; i < size - 1; i++) {
#     int min_idx = i;
#     for (int j = i + 1; j < size; j++) {
#         if (array[j] < array[min_idx]) {
#             min_idx = j;
#         }
#     }
#     if (min_idx != i) {
#         int temp = array[i];
#         array[i] = array[min_idx];
#         array[min_idx] = temp;
#     }
# }
#
# REGISTERS:
# $s0 = base address of the array
# $s1 = size of the array
# $s2 = i (outer loop counter)
# $s3 = min_idx (index of minimum element)
# $s4 = j (inner loop counter)
# Various tX registers

selection_sort:

    	addi $sp, $sp, -24		# Allocate 24 bytes to the stack
    	sw $ra, 20($sp)			# Save the return address
    	sw $s0, 16($sp)			# Save s0
    	sw $s1, 12($sp)			# Save s1
    	sw $s2, 8($sp)			# save s2
    	sw $s3, 4($sp)			# save s3
    	sw $s4, 0($sp)			# sSave s4
    	
    	# I'm using move for these for convenience
    	
    	move $s0, $a0      		# $s0 = array base address
    	move $s1, $a1      		# $s1 = size of the array
    	li $s2, 0          		# $s2 = i which is the outer loop counter
    
	outer_loop_selection_sort:
	
    		addi $t0, $s1, -1   			# t0 = size of array minus 1
    		bge $s2, $t0, FINISHED_SELECTION_SORT   # if i >= size-1, break the outer loop
    
    		move $s3, $s2       			# $s3 = min index = i
    		addi $s4, $s2, 1    			# $s4 = j = i + 1
    
		inner_loop_selection_sort:
		
    			bge $s4, $s1, exit_inner_loop 
    
    			# This code loads the item at array array[j]
    			sll $t1, $s4, 2     		# $t1 = j * 4
    			add $t1, $s0, $t1   		# $t1 = address of array[j]
    			lw $t2, 0($t1)      		# $t2 = array[j]
    
    			# # Load the array at the minimum index
    			sll $t3, $s3, 2     		# $t3 = min index * 4
    			add $t3, $s0, $t3   		# $t3 = address of array[min index]
    			lw $t4, 0($t3)      		# $t4 = array[min index]
    
    			bge $t2, $t4, skip_update	# if array[j] < array[min index], update min index
    			move $s3, $s4       		# min index = j
    
			skip_update:			# If we do not need to update the min index
			
    			addi $s4, $s4, 1    		# j+= 1
    			
    			j inner_loop_selection_sort
    
		exit_inner_loop:
		
    		beq $s2, $s3, next_iteration	# Swap array[i] and array[min index] if min index  != i
    
    		sll $t1, $s2, 2     		# i * 4 for addressing
    		add $t1, $s0, $t1   		# address of array[i]
    
    		sll $t2, $s3, 2     		# min index * 4 (address)
    		add $t2, $s0, $t2   		# address of array[min index]
    
    		# This code actually does the element swapping
    		lw $t3, 0($t1)      		# $t3 = array[i]
    		lw $t4, 0($t2)      		# $t4 = array[min index]
    		sw $t4, 0($t1)      		# array[i] = array[min index]
    		sw $t3, 0($t2)      		# array[min index] = array[i]
    
		next_iteration:
    		addi $s2, $s2, 1    		# i+= 1
    		
    		j outer_loop_selection_sort
    
FINISHED_SELECTION_SORT:

    	lw $ra, 20($sp)		# Restore the return address
    	lw $s0, 16($sp)		# Restore s0
    	lw $s1, 12($sp)		# Restore s1
    	lw $s2, 8($sp)		# Restore s2
    	lw $s3, 4($sp)		# Restore s3
    	lw $s4, 0($sp)		# Restore s4
    	addi $sp, $sp, 24	# Restore 24 bytes on to the stack
    	jr $ra			# Return
