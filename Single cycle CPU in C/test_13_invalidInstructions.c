#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"


int main()
{
	int i;

#define COUNT 4
	WORD badInstructions[COUNT];

	WORD regs[34];
	for (i=0; i<34; i++)
		regs[i] = 0x01010101 * i;

	badInstructions[0] = J_FORMAT(24, 0x3ffffff);
	badInstructions[1] = I_FORMAT(60, 31,21, 0xabcd);
	badInstructions[2] = R_FORMAT(14, 1,2,3, 19);
	badInstructions[3] = R_FORMAT(47, 31,31,31, 31);

	for (i=0; i<COUNT; i++)
	{
		InstructionFields fields;
		CPUControl        control;
		  memset(&fields,  0, sizeof(fields));
		  memset(&control, 0, sizeof(control));

		extract_instructionFields(badInstructions[i], &fields);

		WORD rsVal = regs[fields.rs];
		WORD rtVal = regs[fields.rt];

		int ok = fill_CPUControl(&fields, &control);

		printf("Bad Instruction: 0x%04x_%04x\n",
		       (badInstructions[i] >> 16) & 0xffff,
		        badInstructions[i]        & 0xffff);

		dumpFields(&fields);

		printf("  --\n");

		if (ok == 0)
			printf("  fill_CPUControl() returned 0, as expected.\n");
		else
			printf("*** fill_CPUControl() returned nonzero, even though the instruction was invalid! ***\n");

		dumpControl(rsVal,rtVal, &control);

		printf("\n");
	}

	return 0;
}

