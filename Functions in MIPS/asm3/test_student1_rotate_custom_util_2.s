# test_rotateLong_custom_util_2.s
#
# A testcase for Asm 3.



# ----------- main() -----------
.text


.globl	main
main:
	# fill the sX registers (and fp) with junk.  Each testcase will use a different
	# set of values.
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
test_MSG1:	.asciiz "unspecified non-alcoholic beverage"
.text
	addi    $a0, $zero,99
	la      $a1, test_MSG1
	jal	bottles

.data
test_ARR1:
	.word	 10
	.word	  5
	.word	100
	.word	125
	.word	125
	.word	199
	.word	 -1
.text
	la      $a0, test_ARR1
	addi    $a1, $zero,7
	jal     longestSorted

	add     $a0, $v0,$zero                      # print_int(retval)
	addi    $v0, $zero, 1
	syscall

.data
test_LS_RET_MSG:   .asciiz  " <- longestSorted() retval\n"
.text
	addi    $v0, $zero,4                        # print_str(RET_MSG)
	la      $a0, test_LS_RET_MSG
	syscall

	# rotateLong(16, 1,2,3,4,5,6)
	addi    $a0, $zero,16
	addi    $a1, $zero,1
	addi    $a2, $zero,2
	addi    $a3, $zero,3

	addi    $t0, $zero,4
	sw      $t0, -12($sp)

	addi    $t0, $zero,5
	sw      $t0, -8($sp)

	addi    $t0, $zero,6
	sw      $t0, -4($sp)

	jal     rotateLong

	add     $a0, $v0,$zero                      # print_int(retval)
	addi    $v0, $zero, 1
	syscall

.data
test_ROTATE_RET_MSG:   .asciiz  " <- rotateLong() retval\n"
custom_MSG:	.asciiz   "If you fail this test case, the implementation is the exact same as test_01.s, I just changed what gets printed out in util().\n\n"
.text
	addi    $v0, $zero,4                        # print_str(RET_MSG)
	la      $a0, test_ROTATE_RET_MSG
	syscall

	addi    $v0, $zero,4                        # print_str(custom_MSG)
	la      $a0, custom_MSG
	syscall

j AFTER_util
	# ******************** WARNING ********************
	#
	# I'm doing something very weird here!
	#
	# Normally, I never nest functions inside each other in assembly.
	# But in this case, the *only* point of the following function is
	# that it is a callback utility, for the student code to call
	# from *inside* the rotateLong() function.  So in a high-level
	# programming language, I might have passed this as a *parameter*
	# to rotateLong(), using a lambda or function pointer.  So I'm going
	# to just declare this helper here, *inside* main()
	#
	# ******************** WARNING ********************

.globl utilShort
utilShort:
        addi    $a3, $zero,-11   # arg4
        sw      $t0, -12($sp)
        addi    $t0, $zero,-21   # arg5
        sw      $t0,  -8($sp)
        addi    $t0, $zero,-31   # arg6
        sw      $t0,  -4($sp)

        j utilLong

.globl utilLong
utilLong:
	# Function prologue -- even main has one
	addiu   $sp, $sp, -32   # allocate stack space -- default of 24 here
	sw      $fp, 0($sp)     # save caller's frame pointer
	sw      $ra, 4($sp)     # save return address
	sw      $a0, 8($sp)     # we are going to overwrite a0 in a moment
	addiu   $fp, $sp, 28    # setup main's frame pointer

.data
util_MSG1:  .asciiz   "util(): no useful information here :s"
.text

	addi    $v0, $zero,4            # print_str(MSG1)
	la      $a0, util_MSG1
	syscall

	addi    $v0, $zero,11           # print_char('\n')
	addi    $a0, $zero,'\n'
	syscall


	# return value!
	lw      $a0, 8($sp)    
	add     $v0, $a0,$zero          # return arg1

	# trash *ALL* of the non-save registers!
	xori    $t0, $t0,0xdead
	addiu   $t1, $t1,1234
	xor     $t2, $t3,$t4
	addiu   $t3, $zero,5678
	lui     $t4, 0xf00f
	la      $t5, utilLong
	nor     $t6, $t6,$t6
	addiu   $t7, $t7,-10
	addu    $t8, $t9,$t9
	addu    $t9, $t7,$t8
	la      $a0, util_MSG1
	addiu   $a1, $zero,0
	addu    $a2, $t2,$t3
	addu    $a3, $t4,$t5
	addu    $v1, $t4,$t5

        # Epilogue - util()
	lw      $ra, 4($sp)     # get return address from stack
	lw      $fp, 0($sp)     # restore the caller's frame pointer
	addiu   $sp, $sp, 32    # restore the caller's stack pointer
	jr      $ra             # return to caller's code

AFTER_util:

.data
strlen_STR1:   .asciiz  "Hello world"
strlen_STR2:   .asciiz  "This is a test.  This is only a test."

strlen_MSG:    .asciiz  " <- strlen() retval\n"
.text

	la      $a0, strlen_STR1
	jal     strlen

	add     $a0, $v0,$zero                # print_int(retval)
	addi    $v0, $zero,1
	syscall

	addi    $v0, $zero,4                  # print_str(MSG)
	la      $a0, strlen_MSG
	syscall

	la      $a0, strlen_STR2
	jal     strlen

	add     $a0, $v0,$zero                # print_int(retval)
	addi    $v0, $zero,1
	syscall

	addi    $v0, $zero,4                  # print_str(MSG)
	la      $a0, strlen_MSG
	syscall


.data
gcf_MSG:    .asciiz  " <- gcf() retval\n"
.text

	# gcf(81,29)
	addi    $a0, $zero,81
	addi    $a1, $zero,29
	jal     gcf

	add     $a0, $v0,$zero                # print_int(retval)
	addi    $v0, $zero,1
	syscall

	addi    $v0, $zero,4                  # print_str(MSG)
	la      $a0, gcf_MSG
	syscall

	# gcf(646,54)
	addi    $a0, $zero,630
	addi    $a1, $zero,54
	jal     gcf

	add     $a0, $v0,$zero                # print_int(retval)
	addi    $v0, $zero,1
	syscall

	addi    $v0, $zero,4                  # print_str(MSG)
	la      $a0, gcf_MSG
	syscall

	# gcf(330,736)
	addi    $a0, $zero,330
	addi    $a1, $zero,736
	jal     gcf

	add     $a0, $v0,$zero                # print_int(retval)
	addi    $v0, $zero,1
	syscall

	addi    $v0, $zero,4                  # print_str(MSG)
	la      $a0, gcf_MSG
	syscall



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


