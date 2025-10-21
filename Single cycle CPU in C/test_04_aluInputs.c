#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"


int main()
{
	CPUMemory state;
	  memset(&state, 0, sizeof(state));

	/* this contains all of the instructions from tests 02 and 03 */
	state.instMemory[  0] =  ADD(S_REG(0), S_REG(1),S_REG(2));
	state.instMemory[  1] =  SUB(S_REG(3), S_REG(4),S_REG(5));
	state.instMemory[  2] = ADDI(T_REG(2), T_REG(3), -1);
	state.instMemory[  3] = ADDI(T_REG(4), T_REG(5), 16);
	state.instMemory[  4] =  ADDU( 1,  0, 2);
	state.instMemory[  5] =  SUBU( 3,  4, 5);
	state.instMemory[  6] = ADDIU( 6,  7,0x1234);
	state.instMemory[  7] =   AND( 9, 10,11);
	state.instMemory[  8] =    OR(12, 13,14);
	state.instMemory[  9] =   XOR(15, 16,17);
//	state.instMemory[ 10] =   ORI(18, 19,0x9abc);
	state.instMemory[ 11] =   SLT(21, 22,23);
	state.instMemory[ 12] =  SLTI(24, 25,-1);
	state.instMemory[ 13] =    LW(26,  0,104);
	state.instMemory[ 14] =    SW(29,  0,108);
	state.instMemory[ 15] =   BEQ(1,0, 0x0104);
	state.instMemory[ 16] =     J(0x01234567);
	state.instMemory[ 17] =     J(0x03ffffff);

	/* fill in all of the registers, so that we can figure out if we're
	 * reading the right values.
	 */
	int i;
	for (i=0; i<32; i++)
		state.regs[i] = 0x01010101 * i;

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

			WORD rsVal = state.regs[fields.rs];
			WORD rtVal = state.regs[fields.rt];
			WORD reg32 = state.regs[32];
			WORD reg33 = state.regs[33];

			int ok = fill_CPUControl(&fields, &control);

			if (ok == 0)
			{
				printf("execute_CPUControl() returned 0 with opcode=0x%02x funct=0x%02x at PC 0x%04x_%04x\n",
				       fields.opcode, fields.funct,
				       (state.pc >> 16) & 0xffff, state.pc & 0xffff);
				continue;
			}


			// the instruction looks OK.  Print the rest of the
			// information to the user.
			dumpPCInstruction(state.pc, inst);
			dumpControl_aluInputsOnly(&fields, &control);

			WORD alu1 = getALUinput1(&control, &fields, rsVal,rtVal, reg32,reg33, state.pc);
			WORD alu2 = getALUinput2(&control, &fields, rsVal,rtVal, reg32,reg33, state.pc);

			printf("  ALU input1: 0x%04x_%04x\n",
			       (alu1 >> 16) & 0xffff, alu1 & 0xffff);
			printf("  ALU input2: 0x%04x_%04x\n",
			       (alu2 >> 16) & 0xffff, alu2 & 0xffff);
			printf("\n");
		}

		

		/* was the state struct modified? */
		if (memcmp(&state, &stateOrig, sizeof(state)) != 0)
		{
			printf("ERROR: At PC=0x%08x, the 'state' struct was modified.\n", stateOrig.pc);
		}
	}

	return 0;
}

