#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"



int main()
{
	CPUMemory cpuState;
	  memset(&cpuState, 0, sizeof(cpuState));

	// addi  $s0, $zero, 0x00
	// addi  $s1, $zero, 0x11
	// addi  $s2, $zero, 0x22
	// addi  $s3, $zero, 0x33
	cpuState.instMemory[0x100] = ADDI(S_REG(0), REG_ZERO, 0x00);
	cpuState.instMemory[0x101] = ADDI(S_REG(1), REG_ZERO, 0x11);
	cpuState.instMemory[0x102] = ADDI(S_REG(2), REG_ZERO, 0x22);
	cpuState.instMemory[0x103] = ADDI(S_REG(3), REG_ZERO, 0x33);

	// lb   $t4, 0($s0)
	// lb   $t5, 1($s1)
	// lb   $s2, 2($s2)
	// lb   $s3, 3($s3)
	cpuState.instMemory[0x104] = LB(T_REG(4), S_REG(0), 0);
	cpuState.instMemory[0x105] = LB(T_REG(5), S_REG(1), 1);
	cpuState.instMemory[0x106] = LB(S_REG(2), S_REG(2), 2);
	cpuState.instMemory[0x107] = LB(S_REG(3), S_REG(3), 3);

	// print_int($s0)
	cpuState.instMemory[0x108] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x109] = ADD (A_REG(0), S_REG(0), REG_ZERO);
	cpuState.instMemory[0x10a] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x10b] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x10c] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x10d] = SYSCALL();

	// print_int($s1)
	cpuState.instMemory[0x10e] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x10f] = ADD (A_REG(0), S_REG(1), REG_ZERO);
	cpuState.instMemory[0x110] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x111] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x112] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x113] = SYSCALL();

	// print_int($s2)
	cpuState.instMemory[0x114] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x115] = ADD (A_REG(0), S_REG(2), REG_ZERO);
	cpuState.instMemory[0x116] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x117] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x118] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x119] = SYSCALL();

	// print_int($s3)
	cpuState.instMemory[0x11a] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x11b] = ADD (A_REG(0), S_REG(3), REG_ZERO);
	cpuState.instMemory[0x11c] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x11d] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x11e] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x11f] = SYSCALL();

	// print_int($t4)
	cpuState.instMemory[0x120] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x121] = ADD (A_REG(0), T_REG(4), REG_ZERO);
	cpuState.instMemory[0x122] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x123] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x124] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x125] = SYSCALL();

	// print_int($t5)
	cpuState.instMemory[0x126] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x127] = ADD (A_REG(0), T_REG(5), REG_ZERO);
	cpuState.instMemory[0x128] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x129] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x12a] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x12b] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x12c] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x12d] = SYSCALL();

	cpuState.pc = 0x0400;

	// fill in the registers and data memory with 
	int i;
	for (i=1; i<34; i++)
		cpuState.regs[i] = 0x01010101 * i;
	for (i=0; i<sizeof(cpuState.dataMemory); i++)
		((char*)cpuState.dataMemory)[i] = ((~i) & 0x0ff);

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


