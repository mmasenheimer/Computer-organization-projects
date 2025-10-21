#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"


void dumpPCInstruction(WORD pc, WORD inst)
{
	printf("PC: 0x%04x_%04x   Instruction: 0x%04x_%04x\n",
	       (pc   >> 16) & 0xffff, pc   & 0xffff,
	       (inst >> 16) & 0xffff, inst & 0xffff);
}

void dumpFields(InstructionFields *fieldsIn)
{
	printf("  --\n");
	printf("  opcode  (6 bits)=0x%02x\n", fieldsIn->opcode);
	printf("  rs      (5 bits)=0x%02x\n", fieldsIn->rs);
	printf("  rt      (5 bits)=0x%02x\n", fieldsIn->rt);
	printf("  rd      (5 bits)=0x%02x\n", fieldsIn->rd);
	printf("  shamt   (5 bits)=0x%02x\n", fieldsIn->shamt);
	printf("  funct   (6 bits)=0x%02x\n", fieldsIn->funct);
	printf("  imm16  (16 bits)=0x     %04x\n", fieldsIn->imm16);
	printf("  imm32  (32 bits)=0x%04x_%04x\n",
	       (fieldsIn->imm32 >> 16) & 0xffff, fieldsIn->imm32   & 0xffff);
	printf("  addr   (26 bits)=0x %03x_%04x\n",
	       (fieldsIn->address >> 16) & 0xffff, fieldsIn->address & 0xffff);
}

void dumpControl(WORD rsVal, WORD rtVal, CPUControl *controlIn)
{
	printf("  --\n");
	printf("  rsVal=0x%04x_%04x\n", (rsVal>>16) & 0xffff, rsVal & 0xffff);
	printf("  rtVal=0x%04x_%04x\n", (rtVal>>16) & 0xffff, rtVal & 0xffff);
	printf("  --\n");
	printf("  ALUsrc     =%d\n", controlIn->ALUsrc);
	printf("  ALU.op     =%d\n", controlIn->ALU.op);
	printf("  ALU.bNegate=%d\n", controlIn->ALU.bNegate);
	printf("  memRead    =%d\n", controlIn->memRead);
	printf("  memWrite   =%d\n", controlIn->memWrite);
	printf("  memToReg   =%d\n", controlIn->memToReg);
	printf("  regDst     =%d\n", controlIn->regDst);
	printf("  regWrite   =%d\n", controlIn->regWrite);
	printf("  branch     =%d\n", controlIn->branch);
	printf("  jump       =%d\n", controlIn->jump);
}


void dumpControl_aluInputsOnly(InstructionFields *fieldsIn, CPUControl *controlIn)
{
	printf("  rs      (5 bits)=0x%02x\n", fieldsIn->rs);
	printf("  rt      (5 bits)=0x%02x\n", fieldsIn->rt);
	printf("  imm16  (16 bits)=0x     %04x\n", fieldsIn->imm16);
	printf("  imm32  (32 bits)=0x%04x_%04x\n",
	       (fieldsIn->imm32 >> 16) & 0xffff, fieldsIn->imm32   & 0xffff);
	printf("  ALUsrc     =%d\n", controlIn->ALUsrc);
}

void dumpControl_aluCalcOnly(InstructionFields *fieldsIn, CPUControl *controlIn)
{
	dumpControl_aluInputsOnly(fieldsIn, controlIn);
	printf("  ALU.op     =%d\n", controlIn->ALU.op);
	printf("  ALU.bNegate=%d\n", controlIn->ALU.bNegate);
}


int execute_singleCycleCPU(WORD *regs,
                           WORD *instMemory, WORD *dataMemory,
                           WORD *pc,
                           int debug)
{
	int i;

	/* these are several variables which are used in the actual logic of
	 * the code below.
	 */
	WORD              inst;
	InstructionFields fields;
	WORD              rsVal, rtVal, reg32, reg33;
	CPUControl        control;
	WORD              aluInput1, aluInput2;
	ALUResult         aluResult;
	MemResult         memResult;
	  memset(&fields,    0, sizeof(fields));
	  memset(&control,   0, sizeof(control));
	  memset(&aluResult, 0, sizeof(aluResult));
	  memset(&memResult, 0, sizeof(memResult));

	/* set this to nonzero to indicate that the program should end */
	int fail = 0;


	/* we make duplicates all 4 of the structs (the parameter, plus the
	 * three result structs) so that we can later compare them.  The
	 * result structs should be *ENTIRELY* unmodified, since they are set
	 * up once, and then never changed.  The 'state' variable should
	 * change, but only in a few places.
	 */
        WORD              pc_save;
	WORD            regs_save[34];
	WORD         dataMem_save[DATA_WORDS];

        InstructionFields fields_save;
	CPUControl       control_save;
	ALUResult      aluResult_save;
	MemResult      memResult_save;

	pc_save = *pc;
	memcpy(   regs_save, regs,       sizeof(   regs_save));
	memcpy(dataMem_save, dataMemory, sizeof(dataMem_save));


	// STEP 1: read the instruction from memory
	inst = getInstruction(*pc, instMemory);

	// is this a system call?  For those, we simply skip over the student
	// implementation.
	if (inst == SYSCALL())
	{
		if (debug > 0) printf("[systemCall]");

		*pc += 4;
		return execSyscall(regs, instMemory, dataMemory, pc, debug);
	}


	// STEP 2: decode the instruction
	extract_instructionFields(inst, &fields);
	memcpy(&fields_save,  &fields,  sizeof(fields));

	rsVal = regs[fields.rs];
	rtVal = regs[fields.rt];
	reg32 = regs[32];
	reg33 = regs[33];

	int ok = fill_CPUControl(&fields, &control);
	memcpy(&control_save, &control, sizeof(control));

	if (debug > 0)
	{
		printf("Opcode: 0x%02x   at 0x%04x_%04x\n",
		        fields.opcode,
		       ((*pc) >> 16) & 0xffff, (*pc) & 0xffff);

		if (fields.opcode == 0)
			printf("  funct: 0x%02x\n", fields.funct);
	}

	if (ok == 0)
	{
		printf("fill_CPUControl() returned 0\n");
		return 1;
	}

	if (debug >= 2)
	{
		dumpFields (&fields);
		dumpControl(rsVal,rtVal, &control);
	}


	// remove these fields, so that they cannot be used by student code
	// in later steps.
	fields     .opcode = -1;
	fields_save.opcode = -1;
	fields     .funct  = -1;
	fields_save.funct  = -1;


	// STEP 3: If this isn't a syscall, then do our normal calculations.
	// What do we drive into the ALU?
	aluInput1 = getALUinput1(&control,&fields, rsVal,rtVal,
	                          reg32,reg33, pc_save);
	aluInput2 = getALUinput2(&control,&fields, rsVal,rtVal,
	                          reg32,reg33, pc_save);

	execute_ALU(&control,
	             aluInput1, aluInput2,
	            &aluResult);
	memcpy(&aluResult_save, &aluResult, sizeof(aluResult));

	if (debug >= 2)
	{
		printf("  --\n");
		printf("  ALU.result=0x%04x_%04x\n",
		       (aluResult.result >> 16) & 0xffff,
		        aluResult.result        & 0xffff);
		printf("  ALU.zero  =%d\n", aluResult.zero);
	}



	// STEP 4: handle the memory operations (if any)
	execute_MEM(&control, &aluResult,
	            rsVal,rtVal,
	            dataMemory,
	            &memResult);
	memcpy(&memResult_save, &memResult, sizeof(memResult));

	if (debug >= 2)
	{
		printf("  --\n");
		printf("  memResult.readVal=0x%04x_%04x\n",
		       (memResult.readVal >> 16) & 0xffff,
		        memResult.readVal        & 0xffff);
		printf("  --\n");
	}


	// STEP 5: update the PC
	*pc = getNextPC(&fields, &control, aluResult.zero, rsVal,rtVal, *pc);
	if (*pc == pc_save)
	{
		printf("ERROR: The PC did not change!\n");
		fail = 1;
	}

	if (((*pc) & 0x3) != 0)
	{
		printf("ERROR: The new Program Counter 0x%04x_%04x is not a multiple of 4!\n",
		       ((*pc) >> 16) & 0xffff, (*pc) & 0xffff);
		return 1;
	}


	// STEP 6: update registers
	execute_updateRegs(&fields, &control, &aluResult, &memResult, regs);


	// AFTER THE INSTRUCTION: COMPARE THE VARIOUS STRUCTS

	/* control should not have changed - except that we won't compare
	 * the 'extra' fields
	 */
	if (memcmp(&fields_save, &fields, sizeof(fields)) != 0)
	{
		printf("ERROR: The Instruction Fields struct changed somewhere in the testcase, after the original call to extract_instructionFields().\n");
	}

	if (memcmp(&control_save, &control, sizeof(control)-3*sizeof(WORD)) != 0)
	{
		printf("ERROR: The Control struct changed somewhere in the testcase, after the original call to fill_CPUControl().\n");
	}

	if (memcmp(&aluResult_save, &aluResult, sizeof(aluResult)) != 0)
	{
		printf("ERROR: The ALUResult struct changed somewhere in the testcase, after the original call to execute_ALU().\n");
	}

	if (memcmp(&memResult_save, &memResult, sizeof(memResult)) != 0)
	{
		printf("ERROR: The MemResult struct changed somewhere in the testcase, after the original call to execute_MEM().\n");
	}


	/* help students debug spurious changes to $zero.  This would have
	 * helped me debug my own code, if it had existed!   - Russ
	 */
	if (regs[0] != 0)
		printf("ERROR: The $zero register was changed to 0x%08x\n", regs[0]);


	/* changes to the CPUMemory struct are not errors.  At least, not
	 * necessarily
	 */
	if (debug > 0)
	printf("  PC was: 0x%04x_%04x is: 0x%04x_%04x\n",
	       (pc_save >> 16) & 0xffff, pc_save & 0xffff,
	       ((*pc)   >> 16) & 0xffff, (*pc)   & 0xffff);

	if (debug > 0)
	for (i=0; i<34; i++)
	if (regs_save[i] != regs[i])
	{
		printf("  reg[%2d] was: 0x%04x_%04x is 0x%04x_%04x\n",
		       i,
		       (regs_save[i] >> 16) & 0xffff, regs_save[i] & 0xffff,
		       (regs     [i] >> 16) & 0xffff, regs     [i] & 0xffff);
	}

	if (debug > 0)
	for (i=0; i<sizeof(dataMem_save)/sizeof(dataMem_save[0]); i++)
	if (dataMem_save[i] != dataMemory[i])
	{
		printf("  mem[%2d] was: 0x%04x_%04x is 0x%04x_%04x\n",
		       i,
		       (dataMem_save[i] >> 16) & 0xffff, dataMem_save[i] & 0xffff,
		       (dataMemory  [i] >> 16) & 0xffff, dataMemory  [i] & 0xffff);
	}

	if (debug > 0)
		printf("\n");

	return fail;
}



int execSyscall(WORD *regs,
                WORD *instMemory, WORD *dataMemory,
                WORD *pc,
                int debug)
{
	WORD v0 = regs[2];
	WORD a0 = regs[4];

	// syscall 10: exit
	if (v0 == 10)
	{
		printf("--- syscall 10 executed: Normal termination of the assembly language program.\n");
		return 1;
	}


	// syscall 1: print_int
	if (v0 == 1)
		printf("%d", a0);

	// syscall 11: print_char
	else if (v0 == 11)
		printf("%c", a0);


	// syscall 4: print_str
	else if (v0 == 4)
		printf("%s", ((char*)dataMemory)+a0);


	// unrecognized syscall
	else
		printf("--- ERROR: Unrecognized syscall $v0=%d\n", v0);

	return 0;
}


