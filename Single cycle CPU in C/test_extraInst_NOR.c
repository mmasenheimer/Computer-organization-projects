#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"



int main()
{
	CPUMemory cpuState;
	  memset(&cpuState, 0, sizeof(cpuState));

	// addi  $s0, $zero, 17
	// addi  $s1, $zero, 0x1234
	// addi  $s2, $zero, 48
	// addi  $s3, $zero, 0x5678
	cpuState.instMemory[0x100] = ADDI(S_REG(0), REG_ZERO, 17);
	cpuState.instMemory[0x101] = ADDI(S_REG(1), REG_ZERO, 0x1234);
	cpuState.instMemory[0x102] = ADDI(S_REG(2), REG_ZERO, -1);
	cpuState.instMemory[0x103] = ADDI(S_REG(3), REG_ZERO, 0x5678);

	// nor  $s4, $s0, $s2
	// nor  $s5, $s1, $s3
	cpuState.instMemory[0x104] = NOR(S_REG(4), S_REG(0), S_REG(2));
	cpuState.instMemory[0x105] = NOR(S_REG(5), S_REG(1), S_REG(3));

	// print_int($s4)
	cpuState.instMemory[0x106] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x107] = ADD (A_REG(0), S_REG(4), REG_ZERO);
	cpuState.instMemory[0x108] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x109] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x10a] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x10b] = SYSCALL();

	// print_int($s5)
	cpuState.instMemory[0x10c] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x10d] = ADD (A_REG(0), S_REG(5), REG_ZERO);
	cpuState.instMemory[0x10e] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x10f] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x110] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x111] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x112] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x113] = SYSCALL();

	cpuState.pc = 0x0400;

	// fill in the registers and data memory with 
	int i;
	for (i=1; i<34; i++)
		cpuState.regs[i] = 0x01010101 * i;
	for (i=1; i<sizeof(cpuState.dataMemory); i+=4)
		cpuState.dataMemory[i/4] = 0xffff0000 + i;

	while (1)
	{
		int rc = execute_singleCycleCPU( cpuState.regs,
		                                 cpuState.instMemory, cpuState.dataMemory,
		                                &cpuState.pc, 0);
		if (rc)
			break;
	}

	return 0;
}


