# test_rev_zero_1.s
#
# A testcase for Asm 2.

.data

.globl fib
fib:
	.word	0

.globl square
.globl square_size
.globl square_fill
square:
	.word	0
square_size:
	.word	8
square_fill:
	.byte	'.'

.globl runCheck
runCheck:
	.word	0

.globl intArray_len
.globl intArray
intArray_len:
	.word	1
intArray:
	.word	1

.globl countWords
countWords:
	.word	0

.globl revString
revString:
	.word	1

.globl str
str:
	.asciiz "there is a 0 here"



# ----------- main() -----------
.text


.globl	main
main:
	# call the student code
	jal	studentMain


.data
MAIN_HEAD_MSG:
	.asciiz	"--- Dumping out all of the variables, after the student code ran:\n"

MAIN_LABEL_fib:           .asciiz "fib:          "
MAIN_LABEL_square:        .asciiz "square:       "
MAIN_LABEL_square_size:   .asciiz "square_size:  "
MAIN_LABEL_square_fill:   .asciiz "square_fill:  "
MAIN_LABEL_runCheck:      .asciiz "runCheck:     "
MAIN_LABEL_countWords:    .asciiz "countWords:   "
MAIN_LABEL_str:           .asciiz "str:          \""
MAIN_LABEL_intArray_len:  .asciiz "intArray_len: "
MAIN_LABEL_intArray:      .asciiz "intArray[]:   "

MAIN_TAIL_MSG:
	.asciiz "--- Testcase end---\n"
.text

	# print_str(HEAD_MSG)
	addi	$v0, $zero,4
	la	$a0, MAIN_HEAD_MSG
	syscall


	# print_str(LABEL_fib)
	addi	$v0, $zero,4
	la	$a0, MAIN_LABEL_fib
	syscall

	# print_int(fib)
	addi	$v0, $zero,1
	la	$a0, fib
	lw	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,'\n'
	syscall


	# print_str(LABEL_square)
	addi	$v0, $zero,4
	la	$a0, MAIN_LABEL_square
	syscall

	# print_int(square)
	addi	$v0, $zero,1
	la	$a0, square
	lw	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,'\n'
	syscall


	# print_str(LABEL_square_size)
	addi	$v0, $zero,4
	la	$a0, MAIN_LABEL_square_size
	syscall

	# print_int(square_size)
	addi	$v0, $zero,1
	la	$a0, square_size
	lw	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,'\n'
	syscall


	# print_str(LABEL_square_fill)
	addi	$v0, $zero,4
	la	$a0, MAIN_LABEL_square_fill
	syscall

	# print_int(square_fill)
	addi	$v0, $zero,1
	la	$a0, square_fill
	lb	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,'\n'
	syscall


	# print_str(LABEL_runCheck)
	addi	$v0, $zero,4
	la	$a0, MAIN_LABEL_runCheck
	syscall

	# print_int(runCheck)
	addi	$v0, $zero,1
	la	$a0, runCheck
	lw	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,'\n'
	syscall


	# print_str(LABEL_countWords)
	addi	$v0, $zero,4
	la	$a0, MAIN_LABEL_countWords
	syscall

	# print_int(countWords)
	addi	$v0, $zero,1
	la	$a0, countWords
	lw	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,'\n'
	syscall


	# print_str(LABEL_str)
	addi	$v0, $zero,4
	la	$a0, MAIN_LABEL_str
	syscall

	# print_int(str)
	addi	$v0, $zero,4
	la	$a0, str
	syscall

	# print_chr('"')
	addi	$v0, $zero,11
	addi	$a0, $zero,'"'
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,'\n'
	syscall


	# print_str(LABEL_intArray_len)
	addi	$v0, $zero,4
	la	$a0, MAIN_LABEL_intArray_len
	syscall

	# print_int(intArray_len)
	addi	$v0, $zero,1
	la	$a0, intArray_len
	lw	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,'\n'
	syscall


	# Dump out intArray[]
	#
	# for (int i=0; i<intArray_len; i++)
	#      printf("  %d\n", intArray[i]);
	#
	# REGISTERS
	#   t0 - &intArray[0]
	#   t1 -  intArray_len
	#   t2 -  i
	#   t8 -  various temporaries

	la      $t0, intArray                 # t0 = &intArray[0]

	la      $t1, intArray_len             # t1 = &intArray_len
	lw      $t1, 0($t1)                   # t1 =  intArray_len

	addi    $t2, $zero,0                  # i = 0

MAIN_LOOP:
	slt     $t8, $t2,$t1                  # t8 = (i < intArray_len)
	beq     $t8,$zero, MAIN_LOOP_DONE     # if (i >= intArray_len) break

	# print_chr(' ') - twice
	addi    $v0, $zero,11
	addi    $a0, $zero,' '
	syscall
	syscall

	sll     $t8, $t2,2                    # t8 = i*4
	add     $t8, $t0,$t8                  # t8 = &intArray[i]

	# print_int(intArray[i])
	addi    $v0, $zero,1
	lw      $a0, 0($t8)
	syscall

	# print_chr('\n')
	addi    $v0, $zero,11
	addi    $a0, $zero,'\n'
	syscall

	addi    $t2, $t2,1                    # i++
	j       MAIN_LOOP
MAIN_LOOP_DONE:

	# print_str(TAIL_MSG)
	addi	$v0, $zero,4
	la	$a0, MAIN_TAIL_MSG
	syscall

	# sys_exit()
	addi	$v0, $zero,10
	syscall

