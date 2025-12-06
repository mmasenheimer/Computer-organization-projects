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


# THIS BUILDS A TREE (USING bst_insert()) THAT LOOKS AS FOLLOWS:
#
#                                63
#                           /---/  \
#                          9        70
#                    /----/ \       /\
#                  -15       46   66  99
#                  / \      / \       /\
#               -28  -2   35   52   71  100
#                /   /        /      \
#             -29  -3       49       92
#                                    /
#                                   86
#                                  / \
#                                 85  87


.data

BUFFER:
	.align  2
	.space  240

VALUES:
	.byte	63
	.byte   9
	.byte   70
	.byte   99
	.byte   -15
	.byte   -2
	.byte   100
	.byte   -3
	.byte   -28
	.byte   66
	.byte   46
	.byte   52
	.byte   71
	.byte   -29
	.byte   92
	.byte   86
	.byte   85
	.byte   87
	.byte   35
	.byte   49


.text
	la      $a0, BUFFER
	addi    $a0, $a0,0
	la      $a1, VALUES
	lb      $a1, 0($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,12
	la      $a1, VALUES
	lb      $a1, 1($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,24
	la      $a1, VALUES
	lb      $a1, 2($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,36
	la      $a1, VALUES
	lb      $a1, 3($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,48
	la      $a1, VALUES
	lb      $a1, 4($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,60
	la      $a1, VALUES
	lb      $a1, 5($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,72
	la      $a1, VALUES
	lb      $a1, 6($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,84
	la      $a1, VALUES
	lb      $a1, 7($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,96
	la      $a1, VALUES
	lb      $a1, 8($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,108
	la      $a1, VALUES
	lb      $a1, 9($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,120
	la      $a1, VALUES
	lb      $a1, 10($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,132
	la      $a1, VALUES
	lb      $a1, 11($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,144
	la      $a1, VALUES
	lb      $a1, 12($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,156
	la      $a1, VALUES
	lb      $a1, 13($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,168
	la      $a1, VALUES
	lb      $a1, 14($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,180
	la      $a1, VALUES
	lb      $a1, 15($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,192
	la      $a1, VALUES
	lb      $a1, 16($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,204
	la      $a1, VALUES
	lb      $a1, 17($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,216
	la      $a1, VALUES
	lb      $a1, 18($a1)
	jal     bst_init_node

	la      $a0, BUFFER
	addi    $a0, $a0,228
	la      $a1, VALUES
	lb      $a1, 19($a1)
	jal     bst_init_node


	# link the first 2 nodes
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 12
	jal     bst_insert


.data
DIVIDER:
	.asciiz "---\n"
.text
	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [2]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 24
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [3]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 36
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [4]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 48
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [5]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 60
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [6]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 72
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [7]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 84
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [8]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 96
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [9]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 108
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [10]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 120
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [11]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 132
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [12]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 144
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [13]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 156
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [14]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 168
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [15]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 180
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [16]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 192
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [17]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 204
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [18]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 216
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# insert node [19]
	la      $a0, BUFFER
	la      $a1, BUFFER
	addi    $a1, $a1, 228
	jal     bst_insert

	la      $a0, BUFFER
	jal     bst_in_order_traversal

	addi    $v0, $zero,4             # print_str("---\n")
	la      $a0, DIVIDER
	syscall

	la      $a0, BUFFER
	jal     bst_pre_order_traversal

	addi    $v0, $zero,11            # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall



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



dump_count_retval:
	addi    $v0, $zero,1            # print_int(node->key)
	# a0 is already set
	syscall

	addi    $v0, $zero,11           # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall

	jr	$ra



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


