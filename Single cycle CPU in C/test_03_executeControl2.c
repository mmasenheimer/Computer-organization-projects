#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"


int main()
{
	CPUMemory state;
	  memset(&state, 0, sizeof(state));

	state.instMemory[  0] =  ADDU( 1,  0, 2);
	state.instMemory[  1] =  SUBU( 3,  4, 5);
	state.instMemory[  2] = ADDIU( 6,  7,0x1234);
	state.instMemory[  3] =   AND( 9, 10,11);
	state.instMemory[  4] =    OR(12, 13,14);
	state.instMemory[  5] =   XOR(15, 16,17);
//	state.instMemory[  6] =   ORI(18, 19,0x9abc);
	state.instMemory[  7] =   SLT(21, 22,23);
	state.instMemory[  8] =  SLTI(24, 25,-1);
	state.instMemory[  9] =    LW(26,  0,104);
	state.instMemory[ 10] =    SW(29,  0,108);
	state.instMemory[ 11] =   BEQ(1,0, 0x0104);
	state.instMemory[ 12] =     J(0x01234567);
	state.instMemory[ 13] =     J(0x03ffffff);

	for (state.pc = 0x0000; state.pc < 0x1000; state.pc += 4)
	{
		/* save the original state, to see if the student changes it */
		CPUMemory stateOrig;
		memcpy(&stateOrig, &state, sizeof(state));

		WORD inst = getInstruction(state.pc, state.instMemory);

		if (inst != 0)
		{
			InstructionFields fields;
			CPUControl        control;
			  memset(&fields,  0, sizeof(fields));
			  memset(&control, 0, sizeof(control));

			extract_instructionFields(inst, &fields);

			WORD rsVal = stateOrig.regs[fields.rs];
			WORD rtVal = stateOrig.regs[fields.rt];

			fill_CPUControl       (&fields, &control);

			dumpPCInstruction(state.pc, inst);
			dumpFields (&fields);
			dumpControl(rsVal,rtVal, &control);
			printf("\n");
		}

		

		/* was the state struct modified? */
		if (memcmp(&state, &stateOrig, sizeof(state)) != 0)
		{
			printf("ERROR: When the testcase called getInstruction() or executeControl() at PC=0x%08x, the 'state' struct was modified.\n", stateOrig.pc);
		}
	}

	return 0;
}

