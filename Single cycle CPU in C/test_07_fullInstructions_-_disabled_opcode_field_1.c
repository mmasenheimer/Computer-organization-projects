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

	// syscall 10 (exit)
	state.instMemory[  4] =  ADDI(V_REG(0), REG_ZERO,10);
	state.instMemory[  5] = SYSCALL();

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

