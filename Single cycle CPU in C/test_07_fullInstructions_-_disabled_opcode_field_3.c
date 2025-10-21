#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"


int main()
{
	CPUMemory state;
	  memset(&state, 0, sizeof(state));

	/* this contains all of the instructions from tests 02 and 03 */
	state.instMemory[  0] =    OR(12, 13,14);
	state.instMemory[  1] =   XOR(15, 16,17);
	state.instMemory[  2] =   SLT(21, 22,23);
	state.instMemory[  3] =  SLTI(24, 25,-1);
	state.instMemory[  4] =    LW(26,  0,104);
	state.instMemory[  5] =    SW(29,  0,108);

	// this branch should be taken
	state.instMemory[  6] =   BEQ(T_REG(2), T_REG(2), 1);

	// this instruction should not run, ever
	state.instMemory[  7] =  ADD(S_REG(0), S_REG(1),S_REG(2));

	// this is the destination of the BEQ above

	// this branch should *NOT* be taken
	state.instMemory[  8] =   BEQ(T_REG(2), REG_ZERO, -10);

	// syscall 10 (exit)
	state.instMemory[  9] =  ADDI(V_REG(0), REG_ZERO,10);
	state.instMemory[ 10] = SYSCALL();

	/* fill in all of the registers, so that we can figure out if we're
	 * reading the right values.
	 */
	int i;
	for (i=0; i<32; i++)
		state.regs[i] = 0x01010101 * i;

	/* fill in the memory slots, similarly.
	 *
	 * NOTE: I used to use 0x00010001*i as the constant here, but that
	 *       sometimes lead to weird situations where a student would
	 *       read the wrong address but then mistakenly see the correct
	 *       value.  This version is less error-prone.
	 */
	for (i=0; i<sizeof(state.dataMemory); i+=4)
		state.dataMemory[i/4] = 0xffff0000 + i;


	// we break out when execute_singleCycleCPU() returns nonzero.
	while (1)
	{
		int rc = execute_singleCycleCPU( state.regs,
		                                 state.instMemory,
		                                 state.dataMemory,
		                                &state.pc,
		                                 3);

		if (rc)
			break;
	}

	return 0;
}

