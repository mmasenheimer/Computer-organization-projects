#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"



int main()
{
	CPUMemory cpuState;
	  memset(&cpuState, 0, sizeof(cpuState));

	int i;

	// addi $s0, $zero, 5
	// addi $s1, $zero, 7
	cpuState.instMemory[0x100] = ADDI(S_REG(0), REG_ZERO, 5);
	cpuState.instMemory[0x101] = ADDI(S_REG(1), REG_ZERO, 7);

	// addi     $s2, $zero, 12345678  (pseduoinstruction)
	//     addi $s2, $zero, 0xbc
	//     addi $s2, $s2,$s2 (16 times)    - workaround for sll 16
	//     addi $s2, $s2, 0x614e
	// addi     $s3, $zero, 100000001 (pseduoinstruction)
	//     addi $s3, $zero, 0x5f6
	//     addi $s3, $s3,$s3 (16 times)    - workaround for sll 16
	//     addi $s3, $s3, 0xe101
	cpuState.instMemory[0x102] = ADDI(S_REG(2), REG_ZERO, 0xbc);
	for(i=0; i<16; i++)
		cpuState.instMemory[0x103+i] = ADD(S_REG(2), S_REG(2),S_REG(2));
	cpuState.instMemory[0x113] = ADDI(S_REG(2), S_REG(2), 0x614e);

	cpuState.instMemory[0x114] = ADDI(S_REG(3), REG_ZERO, 0x5f6);
	for(i=0; i<16; i++)
		cpuState.instMemory[0x115+i] = ADD(S_REG(3), S_REG(3),S_REG(3));
	cpuState.instMemory[0x125] = ADDI(S_REG(3), S_REG(3), 0xe101);

	// print_int($s0)
	cpuState.instMemory[0x126] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x127] = ADD (A_REG(0), S_REG(0), REG_ZERO);
	cpuState.instMemory[0x128] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x129] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x12a] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x12b] = SYSCALL();

	// print_int($s1)
	cpuState.instMemory[0x12c] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x12d] = ADD (A_REG(0), S_REG(1), REG_ZERO);
	cpuState.instMemory[0x12e] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x12f] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x130] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x131] = SYSCALL();

	// print_int($s2)
	cpuState.instMemory[0x132] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x133] = ADD (A_REG(0), S_REG(2), REG_ZERO);
	cpuState.instMemory[0x134] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x135] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x136] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x137] = SYSCALL();

	// print_int($s3)
	cpuState.instMemory[0x138] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x139] = ADD (A_REG(0), S_REG(3), REG_ZERO);
	cpuState.instMemory[0x13a] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x13b] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x13c] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x13d] = SYSCALL();

	// mult  $s0,$s1
	// mfhi  $t0
	cpuState.instMemory[0x13e] = MULT(S_REG(0),S_REG(1));
	cpuState.instMemory[0x13f] = MFLO(T_REG(0));

	// mult  $s2,$s3
	// mfhi  $t1
	cpuState.instMemory[0x140] = MULT(S_REG(2),S_REG(3));
	cpuState.instMemory[0x141] = MFLO(T_REG(1));

	// print_int($t0)
	cpuState.instMemory[0x142] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x143] = ADD (A_REG(0), T_REG(0), REG_ZERO);
	cpuState.instMemory[0x144] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x145] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x146] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x147] = SYSCALL();

	// print_int($t1)
	cpuState.instMemory[0x148] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x149] = ADD (A_REG(0), T_REG(1), REG_ZERO);
	cpuState.instMemory[0x14a] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x14b] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x14c] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x14d] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x14e] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x14f] = SYSCALL();

	cpuState.pc = 0x0400;

	// fill in the registers and data memory with 
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


