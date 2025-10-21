#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"



int main()
{
	CPUMemory cpuState;
	  memset(&cpuState, 0, sizeof(cpuState));

	// Encode constants into registers
	// addi  $s2, $zero, 12
	// addi  $s3, $zero, 1
	cpuState.instMemory[0x0fe] = ADDI(S_REG(2), REG_ZERO, 12);
	cpuState.instMemory[0x0ff] = ADDI(S_REG(3), REG_ZERO, 1);

	// addi  $s0, $zero, -12345
	// addi  $s1, $zero, 1000
	cpuState.instMemory[0x100] = ADDI(S_REG(0), REG_ZERO, -12345);
	cpuState.instMemory[0x101] = ADDI(S_REG(1), REG_ZERO, 1000);

	// srlv $s4, $s0, $s2
	// srlv $s5, $s1, $s3
	cpuState.instMemory[0x102] = SRLV(S_REG(4), S_REG(0), S_REG(2));
	cpuState.instMemory[0x103] = SRLV(S_REG(5), S_REG(1), S_REG(3));

	// print_int($s4)
	cpuState.instMemory[0x104] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x105] = ADD (A_REG(0), S_REG(4), REG_ZERO);
	cpuState.instMemory[0x106] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x107] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x108] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x109] = SYSCALL();

	// print_int($s5)
	cpuState.instMemory[0x10a] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x10b] = ADD (A_REG(0), S_REG(5), REG_ZERO);
	cpuState.instMemory[0x10c] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x10d] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x10e] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x10f] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x110] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x111] = SYSCALL();

	cpuState.pc = 0x03f8;

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


