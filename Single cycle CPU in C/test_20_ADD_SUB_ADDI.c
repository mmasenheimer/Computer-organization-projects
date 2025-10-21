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

	// add   $s4, $s0, $s1
	// sub   $s5, $s1, $s0
	// addi  $s6, $s0, 0xcc55
	// addi  $s7, $s1, 0x1200
	cpuState.instMemory[0x102] = ADD (S_REG(4), S_REG(0), S_REG(1));
	cpuState.instMemory[0x103] = SUB (S_REG(5), S_REG(1), S_REG(0));
	cpuState.instMemory[0x104] = ADDI(S_REG(6), S_REG(0), 0xcc55);
	cpuState.instMemory[0x105] = ADDI(S_REG(7), S_REG(1), 0x1234);

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

	// print_int($s6)
	cpuState.instMemory[0x112] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x113] = ADD (A_REG(0), S_REG(6), REG_ZERO);
	cpuState.instMemory[0x114] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x115] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x116] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x117] = SYSCALL();

	// print_int($s7)
	cpuState.instMemory[0x118] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x119] = ADD (A_REG(0), S_REG(7), REG_ZERO);
	cpuState.instMemory[0x11a] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x11b] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x11c] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x11d] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x11e] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x11f] = SYSCALL();

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


