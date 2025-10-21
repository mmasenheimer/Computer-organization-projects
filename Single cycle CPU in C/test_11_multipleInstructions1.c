#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"



int main()
{
	CPUMemory cpuState;
	  memset(&cpuState, 0, sizeof(cpuState));

	// fill in the registers and data memory with some default values
	int i;
	for (i=1; i<32; i++)
		cpuState.regs[i] = 0x01010101 * i;
	for (i=1; i<sizeof(cpuState.dataMemory); i+=4)
		cpuState.dataMemory[i/4] = 0xffff0000 + i;


	// num   = 10;
	// count = 5;
	// step  = 3;
	// for (int i=0; i<count; i++)
	// {
	//	num += step;
	//	printf("%d\n", num);
	// }
	//
	// ---------------------
	//
	//	addi	$t0, $zero, 0		# i     = 0
	//	addi	$t1, $zero, 10		# num   = 10
	//	addi	$t2, $zero, 5		# count = 5
	//	addi	$t4, $zero, 3		# step  = 3
	//	
	// RANGE_LOOP:
	//	slt	$t3, $t0, $t2
	//	beq	$t3, $zero, RANGE_LOOP_END
	//
	//	add	$t1, $t1, $t4		# num += step
	//
	//	addi	$v0, $zero, 1		# print_int(num)
	//	addi	$a0, $t1, $zero
	//	syscall
	//
	//	addi	$v0, $zero, 11		# print_char('\n')
	//	addi	$a0, $zero, 0xa
	//	syscall
	//
	//	addi	$t0, $t0, 1		# i++
	//	j	RANGE_LOOP
	//
	// RANGE_LOOP_END:
	//	addi	$v0, $zero, 10		# sys_exit
	//	syscall
	
	cpuState.pc = 0x000;

	// init
	cpuState.instMemory[ 0] = ADDI(T_REG(0), REG_ZERO,0);
	cpuState.instMemory[ 1] = ADDI(T_REG(1), REG_ZERO,10);
	cpuState.instMemory[ 2] = ADDI(T_REG(2), REG_ZERO,5);
	cpuState.instMemory[ 3] = ADDI(T_REG(4), REG_ZERO,3);

	// RANGE_LOOP:
	cpuState.instMemory[ 4] = SLT(T_REG(3), T_REG(0),T_REG(2));
	cpuState.instMemory[ 5] = BEQ(T_REG(3),REG_ZERO, 9);

	// num += step
	cpuState.instMemory[ 6] = ADD(T_REG(1), T_REG(1),T_REG(4));

	// print_int(num)
	cpuState.instMemory[ 7] = ADDI(V_REG(0), REG_ZERO,1);
	cpuState.instMemory[ 8] = ADD (A_REG(0), T_REG(1), REG_ZERO);
	cpuState.instMemory[ 9] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[10] = ADDI(V_REG(0), REG_ZERO,11);
	cpuState.instMemory[11] = ADDI(A_REG(0), REG_ZERO,0xa);
	cpuState.instMemory[12] = SYSCALL();

	// i++
	cpuState.instMemory[13] = ADDI(T_REG(0), T_REG(0),1);

	// j RANGE_LOOP
	cpuState.instMemory[14] = J(4);

	// RANGE_LOOP_END
	cpuState.instMemory[15] = ADDI(V_REG(0), REG_ZERO,10);
	cpuState.instMemory[16] = SYSCALL();


	// we break out when execute_singleCycleCPU() returns nonzero.
	while (1)
	{
		int rc = execute_singleCycleCPU( cpuState.regs,
		                                 cpuState.instMemory,
		                                 cpuState.dataMemory,
		                                &cpuState.pc,
		                                 2);

		if (rc)
			break;
	}

	return 0;
}


