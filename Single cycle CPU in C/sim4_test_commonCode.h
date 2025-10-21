#ifndef TEST_COMMONCODE_H
#define TEST_COMMONCODE_H


#include "sim4.h"



#define INST_WORDS     1024    // size of the instruction memory, in words
#define DATA_WORDS (16*1024)   // size of the data        memory, in words


typedef struct CPUMemory
{
	// INSTRUCTION & DATA MEMORY
	//
	// It is *NOT* realistic to have the instruction memory and the data
	// memory be two sepearte memories.  See "von Neumann architecture" on
	// Wikipedia to see how real computers work.  But, it simplifies the
	// code for our little toy processor to pretend that they are
	// separate.
	//
	// The instruction memory is READ ONLY.
	//
	// The data memory is read/write.

	WORD instMemory[INST_WORDS];
	WORD dataMemory[DATA_WORDS];

	// REGISTERS
	WORD pc;
	WORD regs[34];     // 32 ordinary, plus lo+hi (if you want to support them)
} CPUMemory;



/* these two functions are called by the execute-full-cycle testcases
 *
 * debug has three settings:
 *    0 - no debug
 *    1 - debug changes, but *NOT* the control bits
 *    2 - full debug
 */

int execute_singleCycleCPU(WORD *regs,
                           WORD *instMemory, WORD *dataMemory,
                           WORD *pc,
                           int debug);

int execSyscall           (WORD *regs,
                           WORD *instMemory, WORD *dataMemory,
                           WORD *pc,
                           int debug);

/* these helper functions are used for printing debug information */

void dumpPCInstruction(WORD pc, WORD inst);

void dumpFields               (InstructionFields *fieldsIn);

void dumpControl              (WORD rsVal, WORD rtVal, CPUControl *controlIn);
void dumpControl_aluInputsOnly(InstructionFields *fieldsIn, CPUControl *controlIn);
void dumpControl_aluCalcOnly  (InstructionFields *fieldsIn, CPUControl *controlIn);



/* these macros are useful for encoding instructions
 */

/* The first few are macros that allow us to generate some register
 * numbers.
 */
#define S_REG(X) ((X)+16)
#define T_REG(X) ((X) < 8 ? (X)+8 : (X)-8+24)    // t0 is 8; t8 is 24
#define A_REG(X) ((X)+4)
#define V_REG(X) ((X)+2)
#define RA_REG    31
#define SP_REG    29
#define FP_REG    30
#define REG_ZERO   0


/* The next four are macros that represent the three instruction formats.
 *
 * Note that all of the R-format instructions use R_FORMAT(); R_FORMAT_x()
 * is used only by MUL, which has a different opcode.
 */

#define R_FORMAT(funct, rs,rt,rd, shamt) R_FORMAT_x(0x00, funct, rs,rt,rd, shamt)

#define R_FORMAT_x(opcode, funct, rs,rt,rd, shamt)                         \
                                          (((opcode)            << 26)  |  \
                                          (((rs    ) &    0x1f) << 21)  |  \
                                          (((rt    ) &    0x1f) << 16)  |  \
                                          (((rd    ) &    0x1f) << 11)  |  \
                                          (((shamt ) &    0x1f) <<  6)  |  \
                                          (((funct ) &    0x3f) <<  0))

#define I_FORMAT(opcode, rs,rt, imm16)   ((((opcode) &    0x3f) << 26)  |  \
                                          (((rs    ) &    0x1f) << 21)  |  \
                                          (((rt    ) &    0x1f) << 16)  |  \
                                          (((imm16 ) & 0x0ffff) <<  0))

#define J_FORMAT(opcode, addr26)         ((((opcode) &      0x3f) << 26)  |    \
                                          (((addr26) & 0x3ffffff) <<  0))



/* these macros encode various instructions.  Each uses the format macros
 * above to actually do the encoding.
 */
#define  NOP()               0    // a 32-bit 0 constant is NOP in MIPS!

#define  ADD(rd, rs,rt)      R_FORMAT(32, rs,rt,rd, 0)
#define  ADDU(rd, rs,rt)     R_FORMAT(33, rs,rt,rd, 0)
#define  SUB(rd, rs,rt)      R_FORMAT(34, rs,rt,rd, 0)
#define  SUBU(rd, rs,rt)     R_FORMAT(35, rs,rt,rd, 0)
#define ADDI(rt, rs,imm16)   I_FORMAT( 8, rs,rt,imm16)
#define ADDIU(rt, rs,imm16)  I_FORMAT( 9, rs,rt,imm16)

#define  MUL(rd, rs,rt)      R_FORMAT_x(0x1c,  2, rs,rt,rd, 0)
#define  MULT(rs,rt)         R_FORMAT  (      24, rs,rt, 0,0)
#define  MULTU(rs,rt)        R_FORMAT  (      25, rs,rt, 0,0)
#define  DIV(rs,rt)          R_FORMAT  (      26, rs,rt, 0,0)
#define  DIVU(rs,rt)         R_FORMAT  (      27, rs,rt, 0,0)

#define  MFHI(rd)            R_FORMAT(16, 0,0, rd, 0)
#define  MFLO(rd)            R_FORMAT(18, 0,0, rd, 0)

#define  AND(rd, rs,rt)      R_FORMAT(36, rs,rt,rd, 0)
#define   OR(rd, rs,rt)      R_FORMAT(37, rs,rt,rd, 0)
#define  XOR(rd, rs,rt)      R_FORMAT(38, rs,rt,rd, 0)
#define  NOR(rd, rs,rt)      R_FORMAT(39, rs,rt,rd, 0)
#define ANDI(rt, rs,imm16)   I_FORMAT(12, rs,rt,imm16)
#define  ORI(rt, rs,imm16)   I_FORMAT(13, rs,rt,imm16)
#define XORI(rt, rs,imm16)   I_FORMAT(14, rs,rt,imm16)

#define  LUI(rt, imm16)      I_FORMAT(15,  0,rt,imm16)

#define   SLT(rd, rs,rt)     R_FORMAT(42, rs,rt,rd, 0)
#define  SLTU(rd, rs,rt)     R_FORMAT(43, rs,rt,rd, 0)
#define  SLTI(rt, rs,imm16)  I_FORMAT(10, rs,rt,imm16)
#define SLTIU(rt, rs,imm16)  I_FORMAT(11, rs,rt,imm16)

#define  SLL(rd, rt,shamt)   R_FORMAT( 0,  0,rt,rd, shamt)
#define  SRL(rd, rt,shamt)   R_FORMAT( 2,  0,rt,rd, shamt)
#define  SRA(rd, rt,shamt)   R_FORMAT( 3,  0,rt,rd, shamt)
#define SLLV(rd, rt,rs)      R_FORMAT( 4, rs,rt,rd, 0)
#define SRLV(rd, rt,rs)      R_FORMAT( 6, rs,rt,rd, 0)
#define SRAV(rd, rt,rs)      R_FORMAT( 7, rs,rt,rd, 0)

#define LW(rt, rs,imm16)     I_FORMAT(35, rs,rt,imm16)
#define SW(rt, rs,imm16)     I_FORMAT(43, rs,rt,imm16)

#define LB(rt, rs,imm16)     I_FORMAT(32, rs,rt,imm16)
#define SB(rt, rs,imm16)     I_FORMAT(40, rs,rt,imm16)

#define BEQ(rs,rt, imm16)    I_FORMAT(4,  rs,rt,imm16)
#define BNE(rs,rt, imm16)    I_FORMAT(5,  rs,rt,imm16)
#define   J(address)         J_FORMAT(2,  address)

#define JAL(address)         J_FORMAT(3,  address)
#define  JR(rs)              R_FORMAT(8,  rs, 0,0,0)

#define SYSCALL()            R_FORMAT(12, 0,0,0, 0)


#endif

