#include <stdio.h>
#include <memory.h>

#include "sim4.h"
#include "sim4_test_commonCode.h"


int main()
{
	CPUMemory state;
	  memset(&state, 0, sizeof(state));

	state.instMemory[  0] =  ADD(S_REG(0), S_REG(1),S_REG(2));
	state.instMemory[  1] =  SUB(S_REG(3), S_REG(4),S_REG(5));
	state.instMemory[256] = ADDI(T_REG(2), T_REG(3), -1);
	state.instMemory[512] = ADDI(T_REG(4), T_REG(5), 16);

	int i;
	for (i=0; i<0x400; i++)
	{
		WORD inst = state.instMemory[i];

		if (inst != 0)
		{
			InstructionFields fields;
			CPUControl        control;
			  memset(&fields,  0, sizeof(fields));
			  memset(&control, 0, sizeof(control));

			extract_instructionFields(inst, &fields);
			fill_CPUControl(&fields, &control);

			printf("Instruction: 0x%04x_%04x\n",
			       (inst >> 16) & 0xffff, inst & 0xffff);

			printf("  --\n");
			printf("  opcode  (6 bits)=0x%02x\n", fields.opcode);
			printf("  rs      (5 bits)=0x%02x\n", fields.rs);
			printf("  rt      (5 bits)=0x%02x\n", fields.rt);
			printf("  rd      (5 bits)=0x%02x\n", fields.rd);
			printf("  shamt   (5 bits)=0x%02x\n", fields.shamt);
			printf("  funct   (6 bits)=0x%02x\n", fields.funct);
			printf("  imm16  (16 bits)=0x     %04x\n", fields.imm16);
			printf("  imm32  (32 bits)=0x%04x_%04x\n",
			       (fields.imm32 >> 16) & 0xffff, fields.imm32   & 0xffff);
			printf("  addr   (26 bits)=0x %03x_%04x\n",
			       (fields.address >> 16) & 0xffff, fields.address & 0xffff);
			printf("  --\n");
			printf("  ALUsrc     =%d\n", control.ALUsrc);
			printf("  ALU.op     =%d\n", control.ALU.op);
			printf("  ALU.bNegate=%d\n", control.ALU.bNegate);
			printf("  memRead    =%d\n", control.memRead);
			printf("  memWrite   =%d\n", control.memWrite);
			printf("  memToReg   =%d\n", control.memToReg);
			printf("  regDst     =%d\n", control.regDst);
			printf("  regWrite   =%d\n", control.regWrite);
			printf("  branch     =%d\n", control.branch);
			printf("  jump       =%d\n", control.jump);
			printf("\n");
		}
	}

	return 0;
}



/* --- stub functions --- */

WORD getInstruction(WORD curPC, WORD *instructionMemory)
{
	return -1;
}

WORD getALUinput1(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC)
{
	return -1;
}

WORD getALUinput2(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC)
{
	return -1;
}

void execute_ALU(CPUControl *controlIn,
                 WORD input1, WORD input2,
                 ALUResult  *aluResultOut)
{
}

void execute_MEM(CPUControl *controlIn,
                 ALUResult  *aluResultIn,
                 WORD        rsVal, WORD rtVal,
                 WORD       *memory,
                 MemResult  *resultOut)
{
}

WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero,
               WORD rsVal, WORD rtVal,
               WORD oldPC)
{
	return 0;
}

void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn,
                        ALUResult  *aluResultIn, MemResult *memResultIn,
                        WORD       *regs)
{
}



