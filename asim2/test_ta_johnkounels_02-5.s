
# test_02.s
#
# A testcase for Asm 2.

.data

.globl fib
fib:
.word    0

.globl square
square:
.word    0

.globl square_fill
square_fill:
.byte    ')'

.globl square_size
square_size:
.word    9

.globl runCheck
runCheck:
.word     0

.globl intArray
intArray:
.word 1
.word 1
.word 1
.word 1

.globl intArray_len
intArray_len:
.word 4

.globl countWords
countWords:
.word   0

.globl str
str:
.asciiz " red\nrum "

.globl revString
revString:
.word     1




# ----------- main() -----------
.text


.globl    main
main:
# call the student code
jal    studentMain

addi   $v0, $zero, 4
la     $a0, str
syscall                          # printf("%s", str);

addi   $v0, $zero, 11
addi   $a0, $zero, '\n'
syscall                          # print_char('\n');

addi   $v0, $zero, 11
addi   $a0, $zero, '\n'
syscall                          # print_char('\n');



# sys_exit()
addi    $v0, $zero,10
syscall
