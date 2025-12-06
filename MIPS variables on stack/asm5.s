# Michael Masenheimer
# CSC 252 
# ASIM  5- variables on stack
# Purpose: This MIPS program is intended to give me
# practice with saving variables on to the stack.
# I can't use global variables so extra-large stack frames
# are used instead.

.data

newline:       .asciiz  "\n"
dashString:    .asciiz  "----------------\n"
colonNum:      .asciiz  ": "
other:	       .asciiz  "<other>: "

.text

.globl countLetters
.globl subsCipher
.globl strlen

# FUNCTION 1: COUNT LETTERS
#
# void countLetters(char *str) {
#	int letters[26]; // must fill this with 0s
#	int other = 0;
#
#	printf("----------------\n%s\n----------------\n", str);
#
#	char *cur = str;
# 	while (*cur != ’\0’) {
#		if (*cur >= ’a’ && *cur <= ’z’) {
#			letters[*cur-’a’]++;
#		} else if (*cur >= ’A’ && *cur <= ’Z’) {
#			letters[*cur-’A’]++;
#		} else {
#			other++
#		}
#		cur++
# 	}
#
#	for (int i=0; i<26; i++) {
#		printf("%c: %d\n", ’a’+i, letters[i]);
#	} printf("<other>: %d\n", other);
# }
#
# REGISTERS:
# $a0 - str parameter and syscall parameter
# $t3 - char *cur
# $t5 - address of letters[index]
# $t7 - current character val (*cur)
# Various other tX registers for iteration variables andtemporary comparizon vars
countLetters:

	addi $sp, $sp, -112	# I'm saving 112 bytes because of (26 * 4 bytes plus 4 for other and 4 for param 0)
	
	add $t1, $zero, $zero	# 0 to be stored at each index
	addi $t0, $zero, 26	# Loop counter starting at the end of the array
	add $t2, $zero, $sp	# Start of the array
	
	LOOP_FILL:
		sw $t1, 0($t2)			# Store a 0 at the current address of the array
		addi $t2, $t2, 4		# Next item in the array
		addi $t0, $t0, -1		# Decrement the end of array pointer
		
		bne $zero, $t0, LOOP_FILL	# Loop until the array counter == 0
	
	sw $t1, 104($sp)	# other = 0 (stored at 104 on the stack)
	sw $a0, 108($sp)	# str saved to  108 on the stack
	
	la $a0, dashString	# Print the dash string out
	addi $v0, $zero, 4	# Syscall 4 for print string out
	syscall
	
	lw $a0, 108($sp)	# Print the input string out
	addi $v0, $zero, 4	# Syscall 4 for print string out
	syscall
	
	la $a0, newline		# Print a new line out
	addi $v0, $zero, 4	# Syscall 4 for print string out
	syscall
	
	la $a0, dashString	# Print the dash string out
	addi $v0, $zero, 4	# Syscall 4 for print string out
	syscall
	
	lw $t3, 108($sp)	# char *cur = str;
	
	LOOP_COUNT_LETTERS:
	
		lb $t7, 0($t3)            		# load *cur
		beq $zero, $t7, EXIT_LOOP_COUNT_LETTERS	# If cur is Null, break the loop
		
		addi $t2, $zero, 'a'			# t2 = 'a'
		slt $t9, $t7, $t2			# $t9 = 1 if cur < 'a'
		bne $zero, $t9, AFTER_FIRST_CONDITION	# if (*cur >= ’a’)
		
		addi $t2, $zero, 123			# t2 = 'z' + 1
		slt $t8, $t7, $t2			# $t9 = 1 if cur < 'z'
		beq $zero, $t8, AFTER_FIRST_CONDITION	# if (*cur >= ’a’)
		
		lb $t1, 0($t3)				# Load *cur
		
		addi $t2, $zero, 97			# Load 'a' into $t2
		sub $t1, $t1, $t2			# t1 = cur - 'a'
		
		sll $t4, $t1, 2				# Multiply the index by 4 (2 places)
		
		add $t5, $sp, $t4			# $t5 = letters[index] (since we shifted)
		
		lw  $t6, 0($t5)   			# load letters[index]
		addi $t6, $t6, 1  			# increment
		sw  $t6, 0($t5)   			# store back
		
		j AFTER_ALL_CONDITIONS			# Exit the conditional bodies
		
		AFTER_FIRST_CONDITION:
		
		addi $t2, $zero, 'A'			# t2 = 'A'
		slt $t9, $t7, $t2			# $t9 = 1 if cur < 'A'
		bne $zero, $t9, AFTER_SECOND_CONDITION	# if (*cur >= ’A’)
		
		addi $t2, $zero, 91			# t2 = 'Z'
		slt $t8, $t7, $t2			# $t9 = 1 if cur < 'Z' + 1
		beq $zero, $t8, AFTER_SECOND_CONDITION	# if (*cur >= ’Z’ + 1)
		
		lb $t1, 0($t3)				# Load *cur
		
		addi $t2, $zero, 65			# Load 'A' into $t2
		sub $t1, $t1, $t2			# t1 = cur - 'A'
		
		sll $t4, $t1, 2				# Multiply the index by 4 (2 places)
		
		add $t5, $sp, $t4			# $t5 = letters[index] (since we shifted)
		
		lw  $t6, 0($t5)   			# load letters[index]
		addi $t6, $t6, 1  			# increment
		sw  $t6, 0($t5)   			# store back
		
		j AFTER_ALL_CONDITIONS			# Exit the conditional bodies
		
		AFTER_SECOND_CONDITION:
		
		lw $t0, 104($sp)			# Load other from the stack (104)
		addi $t0, $t0, 1			# Other ++
		sw $t0, 104($sp)			# Store back to the stack
		
		AFTER_ALL_CONDITIONS:
		
		addi $t3, $t3, 1    			# Move cur pointer to the next char (cur ++)
		
		j LOOP_COUNT_LETTERS
		
	EXIT_LOOP_COUNT_LETTERS:
	
	# for (int i=0; i<26; i++) {
	#	printf("%c: %d\n", ’a’+i, letters[i]);
	# } 

	add $t0, $zero, $zero			# int i = 0
	
	LOOP_PRINT_LETTERS:
	
	slti $t1, $t0, 26			# $t1 = 1 if i < 26
	beq $t1, $zero, EXIT_LOOP_PRINT_LETTERS	# If i >= 26, break the loop
	
	addi $t9, $t0, 'a'			# $t9 = 'a' + i
	
	sll $t2, $t0, 2   			# i * 4
	add $t8, $sp, $t2			# $t8 = letters[i]
	
	add $a0, $t9, $zero			# Print 'a' + i
	addi $v0, $zero, 11	  		# Syscall 11 for print char
	syscall
	
	la $a0, colonNum			# Print the colon num out
	addi $v0, $zero, 4			# Syscall 4 for print string out
	syscall
	
	lw $a0, 0($t8) 				# Print letters[i]
	addi $v0, $zero, 1			# Syscall 1 for print int out
	syscall
	
	la $a0, newline				# Print a new line out
	addi $v0, $zero, 4			# Syscall 4 for print string out
	syscall
	
	addi $t0, $t0, 1			# i++
	
	j LOOP_PRINT_LETTERS
	
	EXIT_LOOP_PRINT_LETTERS:
	
	la $a0, other				# Print the other formatter out (<other>)
	addi $v0, $zero, 4			# Syscall 4 for print string out
	syscall
	
	lw $a0, 104($sp)			# Print the value of "Other"
	addi $v0, $zero, 1			# Syscall 1 for print integer out
	syscall
	
	la $a0, newline				# Print a new line out
	addi $v0, $zero, 4			# Syscall 4 for print string out
	syscall
	
	addi $sp, $sp, 112      		# Restore 112 bytes on the stack
	jr $ra					# Return nothing

# FUNCTION 2: SUBSTITUTION CIPHER ENCRYPTION
#
# void subsCipher(char *str, char *map) {
#
#	int len = strlen(str) + 1
#	int len_roundUp = (len+3) & ~0x3;
#
#	char dup[len_roundUp]; // not legal c, but implementable
#
#	for (int i=0; i<len-1; i++) {
#		dup[i] = map[str[i]];
#	}
#	dup[len-1] = ’\0’;
#	printSubstitutedString(dup);
# }
#
# REGISTERS:
#
# $a0 - str (param 1)
# $a1 - map parameter (param 2)
# $s0 - len (strlen(str) + 1)
# $s1 - saved copy of str pointer
# $s2 - saved copy of map pointer
# $s3 - len_roundUp (rounded-up array size)
# Various other tX registers for temportary values of iterator variables

subsCipher:

	addi $sp, $sp, -28	# Allocate 28 bytes on the stack
    	sw $ra, 0($sp)		# Save return address
    	sw $a0, 4($sp)		# Save param 1
    	sw $a1, 8($sp)		# Save param 2
    	sw $s0, 12($sp)         # Save $s0
    	sw $s1, 16($sp)         # Save $s1
    	sw $s2, 20($sp)         # Save $s2
    	sw $s3, 24($sp)         # Save $s3
    	
    	lw $a0, 4($sp)		# Restore str for calling strlen
	
	jal strlen		# Grab the length of the 
	addi $s0, $v0, 1	# len = strlen(str) + 1
	
	addi $t0, $s0, 3	# len_roundUp = (len+3) 1/2 functions
	
	addi $t1, $zero, 0x3	# $t1 = 0x3
	nor $t1, $t1, $zero	# ~0x3
	and $t0, $t0, $t1	# (len+3) & ~0x3 (rounded the number)
	
	add $s3, $zero, $t0     # Save len_roundUp in $s3
	
	lw $s1, 4($sp)          # Loading s1 before movign the stack pointer
	lw $s2, 8($sp)          # Loading s2 before moving the stack pointer

	sub $sp, $sp, $s3	# Subtract len_roundUp bytes from $sp
	
	addi $t9, $zero, 0	# int i = 0
	addi $t8, $s0, -1	# len - 1 (used for loop upper bound)
	
	LOOP_SUBS_CIPHER:
	
		slt $t7, $t9, $t8			# $s7 = 1 if i < len - 1
		beq $t7, $zero, AFTER_SUBS_CIPHER	# If i < len - 1, break the loop
		
		add $t3, $s1, $t9   			# $t3 is the address of str[i]
		lb  $t1, 0($t3)     			# load byte at str[i] into $t1
		
		add $t4, $s2, $t1   			# $t4 = address of map[str[i]]
		lb  $t2, 0($t4)     			# $t2 = map[str[i]]
		add $t5, $sp, $t9   			# $t5 = address of dup[i]
		sb  $t2, 0($t5)     			# store into dup[i]
		
		addi $t9, $t9, 1			# i++
		j LOOP_SUBS_CIPHER
		
	AFTER_SUBS_CIPHER:
		
	add $t3, $sp, $t9	# Add null terminator to the end of dup ('\0'), $t3 is address of dup[len - 1])
	sb  $zero, 0($t3)	# Stor the null terminator on the stack
	add $a0, $zero, $sp	# printSubstitutedString needs the pointer to the first element of dup
	
	jal printSubstitutedString
	
	add $sp, $sp, $s3       # Restore dup array space (the size is in s3)
    
    	lw $ra, 0($sp)          # Restore return address
    	lw $a0, 4($sp)          # Restore $a0
    	lw $a1, 8($sp)          # Restore $a1
    	lw $s0, 12($sp)         # Restore $s0
    	lw $s1, 16($sp)         # Restore $s1
    	lw $s2, 20($sp)         # Restore $s2
    	lw $s3, 24($sp)         # Restore $s3
    
    	addi $sp, $sp, 28       # Restore 28 bytes for the s registers
	jr $ra			# Return nothing
	
# FUNCTION 2.1: strlen(str)
#
# int length = 0;
# while (*str != '\0') {
#        length++;
#        str++;
#    }
#    return length;
#
# REGISTERS:
# 
# $a0 is a pointer to the string
# $v0 is the running total length of the input string

strlen:

	add $v0, $zero, $zero	# Length(str) = 0 (currently)
	
	LOOP_STRLEN:
	
		lb $t0, 0($a0)			# Load the current character
		beq $t0, $zero, END_LOOP	# If the current character is null, return the length
		
		addi $v0, $v0, 1		# length += 1
		addi $a0, $a0, 1		# Move to next char
		
		j LOOP_STRLEN			# Continue the loop
		
	END_LOOP:
	jr $ra			# Return the length of the string
	