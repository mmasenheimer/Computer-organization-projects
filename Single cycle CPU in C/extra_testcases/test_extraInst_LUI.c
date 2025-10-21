#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"



int main()
{
	CPUMemory cpuState;
	  memset(&cpuState, 0, sizeof(cpuState));

	// addi  $s0, $zero, -1
	// addi  $s1, $zero, -1000
	cpuState.instMemory[0x100] = LUI(S_REG(0), -1);
	cpuState.instMemory[0x101] = LUI(S_REG(1), -1000);
	cpuState.instMemory[0x102] = LUI(S_REG(2),  1234);
	cpuState.instMemory[0x103] = LUI(S_REG(3), 0x4000);

	// print_int($s0)
	cpuState.instMemory[0x104] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x105] = ADD (A_REG(0), S_REG(0), REG_ZERO);
	cpuState.instMemory[0x106] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x107] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x108] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x109] = SYSCALL();

	// print_int($s1)
	cpuState.instMemory[0x10a] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x10b] = ADD (A_REG(0), S_REG(1), REG_ZERO);
	cpuState.instMemory[0x10c] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x10d] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x10e] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x10f] = SYSCALL();

	// print_int($s2)
	cpuState.instMemory[0x110] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x111] = ADD (A_REG(0), S_REG(2), REG_ZERO);
	cpuState.instMemory[0x112] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x113] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x114] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x115] = SYSCALL();

	// print_int($s3)
	cpuState.instMemory[0x116] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x117] = ADD (A_REG(0), S_REG(3), REG_ZERO);
	cpuState.instMemory[0x118] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x119] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x11a] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x11b] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x11c] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x11d] = SYSCALL();

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


