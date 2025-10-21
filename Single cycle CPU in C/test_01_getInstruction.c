#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"


int main()
{
	if (sizeof(WORD) != 4)
	{
		printf("ERROR ERROR ERROR: On the current machine, the size of 'WORD' is actually %d bytes, but we want it to be 4 bytes.  You may need to run your code on a CS department machine instead.\n", (int)sizeof(WORD));
		return 1;
	}


	CPUMemory state;
	  memset(&state, 0, sizeof(state));

	state.instMemory[ 13] =  ADD(S_REG(0), S_REG(1),S_REG(2));
	state.instMemory[ 16] =  SUB(S_REG(3), S_REG(4),S_REG(5));
	state.instMemory[ 17] =  ADD(S_REG(7), T_REG(0),T_REG(1));
	state.instMemory[123] = ADDI(T_REG(2), T_REG(3), -1);

	for (state.pc = 0x0000; state.pc < 0x1000; state.pc += 4)
	{
		/* save the original state, to see if the student changes it */
		CPUMemory stateOrig;
		memcpy(&stateOrig, &state, sizeof(state));

		WORD inst = getInstruction(state.pc, state.instMemory);

		if (inst != 0)
		{
			printf("Addr: 0x%04x_%04x Instruction: 0x%04x_%04x\n",
			       state.pc >> 16, state.pc & 0xffff,
			       inst     >> 16, inst     & 0xffff);
		}

		if (memcmp(&state, &stateOrig, sizeof(state)) != 0)
		{
			printf("ERROR: When the testcase called getInstruction() to read the instruction at PC=0x%08x, the 'state' struct was modified.\n", stateOrig.pc);
		}
	}

	return 0;
}

