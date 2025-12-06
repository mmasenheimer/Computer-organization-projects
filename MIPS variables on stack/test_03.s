# ----------- main() -----------
.text


.globl	main
main:
	# fill the sX registers (and fp) with junk.  Each testcase will use a different
	# set of values.
	lui   $fp,      0x0cb0
	ori   $fp, $fp, 0x03be
	lui   $s0,      0x22df
	ori   $s0, $s0, 0xc51c
	lui   $s1,      0x1abf
	ori   $s1, $s1, 0x856e
	lui   $s2,      0xd119
	ori   $s2, $s2, 0xed8c
	lui   $s3,      0x080d
	ori   $s3, $s3, 0x48f2
	lui   $s4,      0x8c23
	ori   $s4, $s4, 0xbdbd
	lui   $s5,      0xcecf
	ori   $s5, $s5, 0x8827
	lui   $s6,      0xf09f
	ori   $s6, $s6, 0x055a
	lui   $s7,      0xe609
	ori   $s7, $s7, 0x11b8

	# instead of explicitly dumping the stack pointer, I'll push a dummy
	# variable onto the stack.  Some students are reporting different
	# stack values in their output.
	lui   $t0, 0xbdb5
	ori   $t0, $t0,0x42db
	addiu $sp, $sp,-4
	sw    $t0, 0($sp)
	
	
.data
main__STR1:	.asciiz "xpdf proj_sw05.pdf"
.text


	# countLetters(STR1)
	la      $a0, main__STR1
	jal     countLetters


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



.globl printSubstitutedString
printSubstitutedString:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	sw     $a0, 8($sp)       # save arg1 for later
	addiu  $fp, $sp, 20
	
.data
printSubstitutedString__MSG1:	.asciiz "pSS(dup): dup="
.text
	addi   $v0, $zero, 4     # print_str(MSG1)
	la     $a0, printSubstitutedString__MSG1
	syscall

	lw     $a0, 8($sp)       # print_str(str)
	syscall

	addi   $v0, $zero,11     # print_char('\n')
	addi   $a0, $zero,'\n'
	syscall
	
	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra



.globl test_subsCipher
test_subsCipher:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	sw     $a0, 8($sp)       # save arg1 for later
	sw     $a1, 12($sp)      # save arg2 for later
	addiu  $fp, $sp, 20

	# first, we call the student function	
	jal    subsCipher
	
	# now, we dump out both of the inputs - to ensure that the
	# student didn't modify them.
.data
test_subsCipher__MSG1:	.asciiz "------------ Original String ------------\n"
test_subsCipher__MSG2:	.asciiz "----------------- Map -------------------\n"
test_subsCipher__MSG3:	.asciiz "-----------------------------------------\n"
.text
	addi   $v0, $zero, 4     # print_str(MSG1)
	la     $a0, test_subsCipher__MSG1
	syscall

	lw     $a0, 8($sp)       # print_str(str)
	syscall

	addi   $v0, $zero,11     # print_char('\n')
	addi   $a0, $zero,'\n'
	syscall
	
	addi   $v0, $zero, 4     # print_str(MSG2)
	la     $a0, test_subsCipher__MSG2
	syscall

	lw     $a0, 12($sp)      # print_str(map)
	syscall
	
	addi   $v0, $zero,11     # print_char('\n')
	addi   $a0, $zero,'\n'
	syscall
	
	addi   $v0, $zero, 4     # print_str(MSG3)
	la     $a0, test_subsCipher__MSG3
	syscall

	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra



.globl sumN_DEBUG
sumN_DEBUG:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	sw     $a0, 8($sp)       # save arg1 for later
	sw     $a1, 12($sp)      # save arg2 for later
	addiu  $fp, $sp, 20
	
.data
sumN_DEBUG_MSG1:	.asciiz	"sumN_DEBUG: len="
sumN_DEBUG_MSG2:	.asciiz	" val="
.text

	addi   $v0, $zero,4         # print_str(MSG1)
	la     $a0, sumN_DEBUG_MSG1
	syscall
	
	addi   $v0, $zero,1         # print_int(len)
	lw     $a0, 8($sp)
	syscall
	
	addi   $v0, $zero,4         # print_str(MSG2)
	la     $a0, sumN_DEBUG_MSG2
	syscall

	addi   $v0, $zero,1         # print_int(val)
	lw     $a0, 12($sp)
	syscall
	
	addi   $v0, $zero,11        # print_char('\n')
	addi   $a0, $zero,'\n'
	syscall
	
	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra



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

