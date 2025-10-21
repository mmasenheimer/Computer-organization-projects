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

	// addi  $s4, $zero, 0xaa
	// addi  $s5, $zero, 0xbb
	// addi  $s6, $zero, 0xcc
	// addi  $s7, $zero, 0xdd
	cpuState.instMemory[0x104] = ADDI(S_REG(4), REG_ZERO, 0xaa);
	cpuState.instMemory[0x105] = ADDI(S_REG(5), REG_ZERO, 0xbb);
	cpuState.instMemory[0x106] = ADDI(S_REG(6), REG_ZERO, 0xcc);
	cpuState.instMemory[0x107] = ADDI(S_REG(7), REG_ZERO, 0xdd);

	// sb   $s4, 0($s0)
	// sb   $s5, 1($s1)
	// sb   $s6, 2($s2)
	// sb   $s7, 3($s3)
	cpuState.instMemory[0x108] = SB(S_REG(4), S_REG(0), 0);
	cpuState.instMemory[0x109] = SB(S_REG(5), S_REG(1), 1);
	cpuState.instMemory[0x10a] = SB(S_REG(6), S_REG(2), 2);
	cpuState.instMemory[0x10b] = SB(S_REG(7), S_REG(3), 3);

	// lw   $t0, 0x00($zero)
	// lw   $t1, 0x04($zero)
	// lw   $t2, 0x10($zero)
	// lw   $t3, 0x14($zero)
	// lw   $t4, 0x20($zero)
	// lw   $t5, 0x24($zero)
	// lw   $t6, 0x30($zero)
	// lw   $t7, 0x34($zero)
	cpuState.instMemory[0x10c] = LW(T_REG(0), REG_ZERO, 0x00);
	cpuState.instMemory[0x10d] = LW(T_REG(1), REG_ZERO, 0x04);
	cpuState.instMemory[0x10e] = LW(T_REG(2), REG_ZERO, 0x10);
	cpuState.instMemory[0x10f] = LW(T_REG(3), REG_ZERO, 0x14);
	cpuState.instMemory[0x110] = LW(T_REG(4), REG_ZERO, 0x20);
	cpuState.instMemory[0x111] = LW(T_REG(5), REG_ZERO, 0x24);
	cpuState.instMemory[0x112] = LW(T_REG(6), REG_ZERO, 0x30);
	cpuState.instMemory[0x113] = LW(T_REG(7), REG_ZERO, 0x34);

	// print_int($t0)
	cpuState.instMemory[0x114] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x115] = ADD (A_REG(0), T_REG(0), REG_ZERO);
	cpuState.instMemory[0x116] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x117] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x118] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x119] = SYSCALL();

	// print_int($t1)
	cpuState.instMemory[0x11a] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x11b] = ADD (A_REG(0), T_REG(1), REG_ZERO);
	cpuState.instMemory[0x11c] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x11d] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x11e] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x11f] = SYSCALL();

	// print_int($t2)
	cpuState.instMemory[0x120] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x121] = ADD (A_REG(0), T_REG(2), REG_ZERO);
	cpuState.instMemory[0x122] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x123] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x124] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x125] = SYSCALL();

	// print_int($t3)
	cpuState.instMemory[0x126] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x127] = ADD (A_REG(0), T_REG(3), REG_ZERO);
	cpuState.instMemory[0x128] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x129] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x12a] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x12b] = SYSCALL();

	// print_int($t4)
	cpuState.instMemory[0x12c] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x12d] = ADD (A_REG(0), T_REG(4), REG_ZERO);
	cpuState.instMemory[0x12e] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x12f] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x130] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x131] = SYSCALL();

	// print_int($t5)
	cpuState.instMemory[0x132] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x133] = ADD (A_REG(0), T_REG(5), REG_ZERO);
	cpuState.instMemory[0x134] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x135] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x136] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x137] = SYSCALL();

	// print_int($t6)
	cpuState.instMemory[0x138] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x139] = ADD (A_REG(0), T_REG(6), REG_ZERO);
	cpuState.instMemory[0x13a] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x13b] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x13c] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x13d] = SYSCALL();

	// print_int($t7)
	cpuState.instMemory[0x13e] = ADDI(V_REG(0), REG_ZERO, 1);
	cpuState.instMemory[0x13f] = ADD (A_REG(0), T_REG(7), REG_ZERO);
	cpuState.instMemory[0x140] = SYSCALL();

	// print_char('\n')
	cpuState.instMemory[0x141] = ADDI(V_REG(0), REG_ZERO, 11);
	cpuState.instMemory[0x142] = ADDI(A_REG(0), REG_ZERO, 0xa);
	cpuState.instMemory[0x143] = SYSCALL();

	// sys_exit()
	cpuState.instMemory[0x144] = ADDI(V_REG(0), REG_ZERO, 10);
	cpuState.instMemory[0x145] = SYSCALL();

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


