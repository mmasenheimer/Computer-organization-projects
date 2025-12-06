# test_01_init.s
#
# A testcase for Asm 4.



# ----------- main() -----------
.text


.globl	main
main:
	# fill the sX registers (and fp) with junk.  Each testcase will use a different
	# set of values.
# TODO: update
	lui   $fp,      0xffff
	ori   $fp, $fp, 0xffff
	lui   $s0,      0x17eb
	ori   $s0, $s0, 0xe47d
	lui   $s1,      0xf977
	ori   $s1, $s1, 0xc17a
	lui   $s2,      0xb1df
	ori   $s2, $s2, 0x81b0
	lui   $s3,      0x8836
	ori   $s3, $s3, 0x9c73
	lui   $s4,      0x922f
	ori   $s4, $s4, 0x0f13
	lui   $s5,      0xa2e5
	ori   $s5, $s5, 0x35cc
	lui   $s6,      0xe36e
	ori   $s6, $s6, 0x4168
	lui   $s7,      0x4ab5
	ori   $s7, $s7, 0x5b22

	# instead of explicitly dumping the stack pointer, I'll push a dummy
	# variable onto the stack.  Some students are reporting different
	# stack values in their output.
	lui   $t0, 0xbfb3
	ori   $t0, $t0,0xa429
	addiu $sp, $sp,-4
	sw    $t0, 0($sp)


.data

OBJ1:	.word	1234
	.word	5678
	.word	9012

OBJ2:	.word	-1
	.word	10
	.word	13

OBJ3:	.word	237
	.word	'x'
	.word	128256

.text

	la      $a0, OBJ1
	addi    $a1, $zero,13
	jal     bst_init_node

	la      $a0, OBJ2
	addi    $a1, $zero,-10
	jal     bst_init_node

	la      $a0, OBJ3
	addi    $a1, $zero,237
	jal     bst_init_node

.data
MSG:	.asciiz "\nDumping out the contents of all of the objects:\n"
.text

	# printf(MSG);
	# for (int i=0; i<9; i++)
	#     print("%d\n", word_array[i]);
	#
	# REGISTERS:
	#   t0 - i
	#   t1 - temporaries
	#   t2 - temporaries

	addi    $v0, $zero,4        # print_str(MSG)
	la      $a0, MSG
	syscall

	addi    $t0, $zero,0        # i = 0

word_dump__LOOP:
	slti    $t1, $t0,9          # t1 = (i<9)
	beq     $t1,$zero, word_dump__LOOP_DONE

	la	$t1, OBJ1           # t1 = &words_array
	sll     $t2, $t0,2          # t2 =  i*4
	add     $t1, $t1,$t2        # t1 = &words_array[i]
	lw      $t1, 0($t1)         # t1 =  words_array[i]

	addi    $v0, $zero,1        # print_int(words_array[i])
	add     $a0, $t1,$zero
	syscall

	addi    $v0, $zero,11       # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall

	addi    $t0, $t0,1          # i++
	j       word_dump__LOOP

word_dump__LOOP_DONE:

	# dump out all of the registers.
.data
TESTCASE_DUMP1:	.ascii  "\n"
               	.ascii 	"+-----------------------------------------------------------+\n"
		.ascii	"|    Magic Value (popped from the stack):                   |\n"
		.asciiz	"+-----------------------------------------------------------+\n"

TESTCASE_DUMP2:	.ascii  "\n"
               	.ascii 	"+-----------------------------------------------------------+\n"
		.ascii	"|    Testcase Register Dump (fp, then 8 sX regs):           |\n"
		.asciiz	"+-----------------------------------------------------------+\n"
.text
	addi	$v0, $zero, 4		# print_str(TESTCASE_DUMP1)
	la	$a0, TESTCASE_DUMP1
	syscall

	# we pop this from the stack so that, if the stack pointer is not
	# predictable, we'll still get reliable results.
	lw      $a0, 0($sp)
	addiu   $sp, $sp,4
	jal     printHex

	# the rest of the registers have hard-coded values
	addi	$v0, $zero, 4		# print_str(TESTCASE_DUMP2)
	la	$a0, TESTCASE_DUMP2
	syscall

	add	$a0, $fp, $zero
	jal     printHex
	add	$a0, $s0, $zero
	jal     printHex
	add	$a0, $s1, $zero
	jal     printHex
	add	$a0, $s2, $zero
	jal     printHex
	add	$a0, $s3, $zero
	jal     printHex
	add	$a0, $s4, $zero
	jal     printHex
	add	$a0, $s5, $zero
	jal     printHex
	add	$a0, $s6, $zero
	jal     printHex
	add	$a0, $s7, $zero
	jal     printHex
	
	# terminate the program	
	addi	$v0, $zero, 10		# syscall_exit
	syscall
	# never get here!



# ---- some functions that the student code can call ----





# ---- UTILITY FUNCTIONS, FOR THE TESTCASE ITSELF ----

# void printHex(int val)
# {
#     printHex_recurse(val, 8);
#     printf("\n");
# }
printHex:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	addiu  $fp, $sp, 20
	
	# printHex(val, 8)
	addi   $a1, $zero, 8
	jal    printHex_recurse
	
	addi   $v0, $zero, 11      # print_char('\n')
	addi   $a0, $zero, 0xa
	syscall

	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra
	
	
	
printHex_recurse:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	addiu  $fp, $sp, 20
	
	# if (len == 0) return;    // base case (NOP)
	beq    $a1, $zero, printHex_recurse_DONE

	# recurse first, before we print this character.
	#
	# The reason for this is because the easiest way to break up
	# a long integer is using a small shift and modulo; so *this*
	# call will be responsible for the *last* hex digit, and we'll
	# use recursion to handle the things which come *before* it.
	#
	# As we've seen just above, if the current len==1, then the
	# recursive call will be the base case, and a NOP.
	
	# of course, we have to save a0 before we recurse.  We do *NOT*
	# need to save a1, since we'll never need it again.
	sw     $a0, 8($sp)
	
	# printHex_recurse(val >> 4, len-1)
	srl    $a0, $a0,4
	addi   $a1, $a1,-1
	jal    printHex_recurse
	
	# restore a0
	lw     $a0, 8($sp)
	
	# the value we will print is (val & 0xf), interpreted as hex.
	andi   $t0, $a0,0x0f      # digit = (val & 0xf)
	
	slti   $t1, $t0,10        # t1 = (digit < 10)
	beq    $t1, $zero, printHex_recurse_LETTER
	
	# if we get here, then $t0 contains an integer from 0 to 9, inclusive.
	addi   $v0, $zero, 11     # print_char(digit+'0')
	addi   $a0, $t0, '0'
	syscall
	
	j      printHex_recurse_DONE
	
printHex_recurse_LETTER:
	# if we get here, then $t0 contains an integer from 10 to 15, inclusive.
	# convert to the equivalent letter.
	addi   $t0, $t0,-10        # digit -= 10
	
	addi   $v0, $zero, 11     # print_char(digit+'a')
	addi   $a0, $t0, 'a'
	syscall
	
	# intentional fall-through to the epilogue	

printHex_recurse_DONE:
	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra


