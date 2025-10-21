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
	cpuState.instMemory[0x100] = ADDI(S_REG(0), REG_ZERO, -1);
	cpuState.instMemory[0x101] = ADDI(S_REG(1), REG_ZERO, -1000);

	// and   $s4, $s0, $s1
	// or    $s5, $s1, $s0
	// xor   $s6, $s0, $s1
	cpuState.instMemory[0x102] = AND(S_REG(4), S_REG(0), S_REG(1));
	cpuState.instMemory[0x103] = OR (S_REG(5), S_REG(1), S_REG(0));
	cpuState.instMemory[0x104] = XOR(S_REG(6), S_REG(0), S_REG(1));

	// print_int($s4)
	cpuState.instMemory[0x105] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x106] = ADD (A_REG(0), S_REG(4), REG_ZERO);
	cpuState.instMemory[0x107] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x108] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x109] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x10a] = SYSCALL();

	// print_int($s5)
	cpuState.instMemory[0x10b] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x10c] = ADD (A_REG(0), S_REG(5), REG_ZERO);
	cpuState.instMemory[0x10d] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x10e] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x10f] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x110] = SYSCALL();

	// print_int($s6)
	cpuState.instMemory[0x111] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x112] = ADD (A_REG(0), S_REG(6), REG_ZERO);
	cpuState.instMemory[0x113] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x114] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x115] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x116] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x117] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x118] = SYSCALL();

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


