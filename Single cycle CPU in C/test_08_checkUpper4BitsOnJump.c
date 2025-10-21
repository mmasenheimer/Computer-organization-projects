#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"



#define COUNT 10

int main()
{
	int i;

	WORD oldPC       [COUNT];
	WORD instructions[COUNT];
	int  aluZero     [COUNT];

// unused in this testcase!	WORD regs        [34];

	InstructionFields fields[COUNT*2];
	  memset(fields, 0, sizeof(fields));

	CPUControl controls[COUNT*2];
	  memset(controls, 0, sizeof(controls));

#if 0
	for (i=0; i<34; i++)
		regs[i] = 0x01010101 * i;
#endif


	/* the PC and jump address are both randomly chosen.  We also
	 * randomly choose what value of aluZero we'll deliver.
	 */
	srand(0x0c0010ff);
	for (i=0; i<COUNT; i++)
	{
		oldPC       [i] =                rand();
		instructions[i] = (0x2 << 26) | (rand() % 0x3ffffff);
		aluZero     [i] = rand() & 0x1;
	}


	/* fill in each of the control structs.  We make a duplicate of each
	 * one, which we'll use later to see if 
	 */
	for (i=0; i<COUNT; i++)
	{
		extract_instructionFields(instructions[i], &fields[i]);
		memcpy(&fields  [i+COUNT], &fields  [i], sizeof(fields[0]));

		fill_CPUControl(&fields[i], &controls[i]);
		memcpy(&controls[i+COUNT], &controls[i], sizeof(controls[0]));

		printf("i=%2d:\n", i);

		printf("  instruction = 0x%04x_%04x\n",
		       (instructions[i] >> 16) & 0xffff,
		        instructions[i]        & 0xffff);

		printf("  control:\n");
		printf("    opcode  = 0x%02x\n", fields[i].opcode);
		printf("    address = 0x %03x_%04x\n",
		       (fields[i].address >> 16) & 0xffff,
		        fields[i].address        & 0xffff);
		printf("    jump    = %d\n", controls[i].jump);
		printf("    branch  = %d\n", controls[i].branch);
		printf("\n");
	}


	/* check each of the outputs! */
	for (i=0; i<COUNT; i++)
	{
		WORD newPC = getNextPC(&fields[i], &controls[i], aluZero[i],
		                        0x00000000, 0x00000000,
		                        oldPC[i]);

		printf("i=%2d: oldPC=0x%04x_%04x (addr<<2)=0x%04x_%04x -> newPC=0x%04x_0x%04x\n",
		       i,
		       (oldPC[i]               >> 16) & 0xffff,
		        oldPC[i]                      & 0xffff,
		       ((fields[i].address<<2) >> 16) & 0xffff,
		        (fields[i].address<<2)        & 0xffff,
		       (newPC                  >> 16) & 0xffff,
		        newPC                         & 0xffff);
	}



	/* was the state struct modified? */
	if (memcmp(&controls[0], &controls[0+COUNT], sizeof(CPUControl)*COUNT) != 0)
	{
		printf("ERROR: One or more control structs was modified *OUTSIDE* of execute_CPUControl()!\n");
	}

	return 0;
}

