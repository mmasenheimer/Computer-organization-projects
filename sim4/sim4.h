#ifndef __SIM3_H__INCLUDED__
#define __SIM3_H__INCLUDED__


typedef int WORD;


typedef struct InstructionFields
{
	// THESE ARE NOT ACTUALLY CONTROL BITS
	//
	// However, you have to fill them out.  Fill out *all* of these fields
	// for *all* instructions, even if it doesn't use that particular
	// field.  For instance, opcode 0 means that it is an R format
	// instruction - but you *still* must set the proper values for imm16,
	// imm32, and address.
	//
	// NOTE: imm16 is the field from the instruction,  imm32 is the
	//       sign-extended version.
	int opcode;
	int rs;
	int rt;
	int rd;
	int shamt;
	int funct;
	int imm16, imm32;
	int address;		// this is the 26 bit field from the J format
} InstructionFields;


typedef struct CPUControl
{
	// THESE ARE THE REAL CONTROL BITS
	//
	// For the ALU control bits, we will ignore the fact that the "main"
	// control produces a 2-bit value, which is combined with the funct
	// field to produce a 3-bit control (bNegate+ALUop).  We'll ignore the
	// 2-bit from the main control; we will *only* report the 3-bit
	// control that comes out of the ALU Control field.
	int ALUsrc;
	struct {
		int op;
		int bNegate;
	} ALU;

	int memRead;
	int memWrite;
	int memToReg;

	int regDst;
	int regWrite;

	int branch;
	int jump;


	// EXTRA WORDS
	//
	// You are not required to use these fields.  But if you want to
	// support other instructions, some additional control bits might be
	// necessary.  You may use these fields for anything you want; the
	// testcases will ignore them.
	WORD extra1, extra2, extra3;
} CPUControl;



typedef struct ALUResult
{
	WORD result;
	int zero;

	WORD extra;
} ALUResult;

typedef struct MemResult
{
	int readVal;
} MemResult;



WORD getInstruction(WORD curPC, WORD *instructionMemory);

void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut);

int  fill_CPUControl(InstructionFields *fields, CPUControl *controlOut);

WORD getALUinput1(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC);

WORD getALUinput2(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC);

void execute_ALU(CPUControl *controlIn,
                 WORD input1, WORD input2,
                 ALUResult  *aluResultOut);

void execute_MEM(CPUControl *controlIn,
                 ALUResult  *aluResultIn,
                 WORD        rsVal, WORD rtVal,
                 WORD       *memory,
                 MemResult  *resultOut);

WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero,
               WORD rsVal, WORD rtVal,
               WORD oldPC);

void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn,
                        ALUResult  *aluResultIn, MemResult *memResultIn,
                        WORD       *regs);



/* HELPER FUNCTIONS THAT YOU CAN CALL */

static inline WORD signExtend16to32(int val16)
{
	if (val16 & 0x8000)
		return val16 | 0xffff0000;
	else
		return val16;
}


#endif

