#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"



int main()
{
	CPUMemory cpuState;
	  memset(&cpuState, 0, sizeof(cpuState));

	// addi  $s0, $zero, 123
	// addi  $s1, $zero, 456
	cpuState.instMemory[0x100] = ADDI(S_REG(0), REG_ZERO, 123);
	cpuState.instMemory[0x101] = ADDI(S_REG(1), REG_ZERO, 456);

	// bne   $s0, $s1, BNE_OK
	cpuState.instMemory[0x102] = BNE(S_REG(0), S_REG(1), 8);

	// print_int(-1)
		// if the student code gets here, then it has a BUG!
	cpuState.instMemory[0x103] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x104] = ADDI(A_REG(0), REG_ZERO, -1);
	cpuState.instMemory[0x105] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x106] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x107] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x108] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x109] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x10a] = SYSCALL();

	// BNE_OK:
	// beq   $s0, $s1, BNE_OK_BEQ_BAD
	cpuState.instMemory[0x10b] = BEQ(S_REG(0), S_REG(1), 8);

	// print_int(0)
		// if the student code gets here, then it WORKS!
	cpuState.instMemory[0x10c] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x10d] = ADDI(A_REG(0), REG_ZERO, 0);
	cpuState.instMemory[0x10e] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x10f] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x110] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x111] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x112] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x113] = SYSCALL();

	// BNE_OK_BEQ_BAD:
	// print_int(12345)
		// if the student code gets here, then it has a BUG!
	cpuState.instMemory[0x114] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x115] = ADDI(A_REG(0), REG_ZERO, 12345);
	cpuState.instMemory[0x116] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x117] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x118] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x119] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x11a] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x11b] = SYSCALL();

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


