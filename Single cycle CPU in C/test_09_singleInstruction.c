#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"



int main()
{
	CPUMemory cpuState;
	  memset(&cpuState, 0, sizeof(cpuState));

	cpuState.instMemory[0x40] = ADD(T_REG(0), S_REG(3),S_REG(4));

	cpuState.pc = 0x0100;

	// fill in the registers and data memory with some default values
	int i;
	for (i=1; i<32; i++)
		cpuState.regs[i] = 0x01010101 * i;
	for (i=1; i<sizeof(cpuState.dataMemory); i+=4)
		cpuState.dataMemory[i/4] = 0xffff0000 + i;

	execute_singleCycleCPU( cpuState.regs,
	                        cpuState.instMemory,
	                        cpuState.dataMemory,
	                       &cpuState.pc,
	                        2);

	return 0;
}


