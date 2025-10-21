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

	
	// addi	$v0, $zero, 1		# print_int(1234) - twice
	// addi $a0, $zero, 1234
	// syscall
	// syscall
	//
	// addi	$v0, $zero, 1		# print_int(5678)
	// addi $a0, $zero, 5678
	// syscall
	//
	// addi	$v0, $zero, 11		# print_char('\n')
	// addi $a0, $zero, 0xa
	// syscall
	//
	// addi	$v0, $zero, 4
	// addi $a0, $zero, 0x1000	# print_str("TEST STRING\n")
	// syscall
	//
	// addi	$v0, $zero, 10		# sys_exit
	// syscall

	cpuState.pc = 0x0100;

	cpuState.instMemory[0x40] = ADDI(V_REG(0), REG_ZERO,1);
	cpuState.instMemory[0x41] = ADDI(A_REG(0), REG_ZERO,1234);
	cpuState.instMemory[0x42] = SYSCALL();
	cpuState.instMemory[0x43] = SYSCALL();

	cpuState.instMemory[0x44] = ADDI(V_REG(0), REG_ZERO,1);
	cpuState.instMemory[0x45] = ADDI(A_REG(0), REG_ZERO,5678);
	cpuState.instMemory[0x46] = SYSCALL();

	cpuState.instMemory[0x47] = ADDI(V_REG(0), REG_ZERO,11);
	cpuState.instMemory[0x48] = ADDI(A_REG(0), REG_ZERO,0xa);
	cpuState.instMemory[0x49] = SYSCALL();

	cpuState.instMemory[0x4a] = ADDI(V_REG(0), REG_ZERO,4);
	cpuState.instMemory[0x4b] = ADDI(A_REG(0), REG_ZERO,0x1000);
	cpuState.instMemory[0x4c] = SYSCALL();

	cpuState.instMemory[0x4d] = ADDI(V_REG(0), REG_ZERO,10);
	cpuState.instMemory[0x4e] = SYSCALL();

	/* set up the string in the data memory */
#define CHARS_TO_WORD(a,b,c,d) (((d) << 24) |   \
                                ((c) << 16) |   \
                                ((b) <<  8) |   \
                                 (a)       )
	cpuState.dataMemory[0x400] = CHARS_TO_WORD('T','E','S','T');
	cpuState.dataMemory[0x401] = CHARS_TO_WORD(' ','S','T','R');
	cpuState.dataMemory[0x402] = CHARS_TO_WORD('I','N','G','\n');
	cpuState.dataMemory[0x403] = CHARS_TO_WORD('\0', 0,0,0);


	// we break out when execute_singleCycleCPU() returns nonzero.
	while (1)
	{
		int rc = execute_singleCycleCPU( cpuState.regs,
		                                 cpuState.instMemory,
		                                 cpuState.dataMemory,
		                                &cpuState.pc,
		                                 0);

		if (rc)
			break;
	}

	return 0;
}


