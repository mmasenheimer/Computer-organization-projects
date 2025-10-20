#include "sim4.h"

void extract_instructionFields(WORD instruction, InstructionFields* fieldsOut) {

    fieldsOut->opcode = (instruction >> 26) & 0x3F;     // 31-26
    fieldsOut->rs     = (instruction >> 21) & 0x1F;     // 25-21
    fieldsOut->rt     = (instruction >> 16) & 0x1F;     // 20-16
    fieldsOut->rd     = (instruction >> 11) & 0x1F;     // 15-11
    fieldsOut->shamt  = (instruction >> 6)  & 0x1F;     // 10-6
    fieldsOut->funct  = instruction & 0x3F;             // 5-0
    fieldsOut->imm16    = instruction & 0xFFFF;           // 15-0

    if (fieldsOut->imm16 & 0x8000) {
        fieldsOut->imm32 = fieldsOut->imm16 | 0xFFFF0000;
    } else {
        fieldsOut->imm32 = fieldsOut->imm16;
    }

    fieldsOut->address= instruction & 0x3FFFFFF;        // 25-0

}

int fill_CPUControl(InstructionFields* fields, CPUControl* controlOut) {

    if (fields->opcode > 63 || fields->opcode < 0) {
        // Ivalid opcode
        return 0;
    }

    if (fields->opcode == 0) {
        // R type

        if (fields->funct > 63 || fields->funct < 0) {
            // Bad function code
            return 0;
        }

        /* 
        These represent common r-format fields where every r format
        instruction uses these fields as is
        */
        controlOut->regDst   = 1;
        controlOut->regWrite = 1;
        controlOut->ALUsrc   = 0;
        controlOut->memRead  = 0;
        controlOut->memWrite = 0;
        controlOut->memToReg = 0;
        controlOut->branch   = 0;
        controlOut->jump     = 0;
        
        if (fields->funct == 32 || fields->funct == 33) {
            // add or addu
            controlOut->ALU.op = 2;
            controlOut->ALU.bNegate = 0;
            return 1;
        }

        if (fields->funct == 34 || fields->funct == 35) {
            // sub or subbu
            controlOut->ALU.op = 2;
            controlOut->ALU.bNegate = 1;
            return 1;
        }
        
        if (fields->funct == 36) {
            // AND
            controlOut->ALU.op = 0;
            controlOut->ALU.bNegate = 0;
            return 1;
        }

        if (fields->funct == 37) {
            // OR
            controlOut->ALU.op = 1;
            controlOut->ALU.bNegate = 0;
            return 1;
        }

        if (fields->funct == 38) {
            // XOR
            controlOut->ALU.op = 4;
            controlOut->ALU.bNegate = 0;
            return 1;
        }

        if (fields->funct == 42) {
            // SLT
            controlOut->ALU.op = 3;
            controlOut->ALU.bNegate = 1;
            return 1;
        }
        return 0;
    }

    if (fields->opcode == 2) {
        // Jump code
        controlOut->regDst   = 0;
        controlOut->regWrite = 0;
        controlOut->ALUsrc   = 0;
        controlOut->ALU.op = 0;
        controlOut->jump = 1;
        controlOut->branch = 0;
        controlOut->memToReg = 0;
        controlOut->ALU.bNegate = 0;
        controlOut->memRead  = 0;
        controlOut->memWrite = 0;
        return 1;
    }

    /* 
    These represent common i-format fields where every i format
    instruction uses these fields as is
    */
    controlOut->regDst   = 0;
    controlOut->regWrite = 1;
    controlOut->ALUsrc   = 1;
    controlOut->branch   = 0;
    controlOut->jump     = 0;


    if (fields->opcode == 4) {
        // BEQ
        controlOut->memRead = 0;
        controlOut->memWrite = 0;
        controlOut->memToReg = 0;
        controlOut->ALUsrc   = 0;
        controlOut->regWrite = 0;

        controlOut->branch = 1;

        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 1;
        return 1;
    }

    if (fields->opcode == 8 || fields->opcode == 9) {
        // addi and addiu
        controlOut->memRead = 0;
        controlOut->memWrite = 0;
        controlOut->memToReg = 0;

        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;
        return 1;

    }

    if (fields->opcode == 10) {
        // SLTI
        controlOut->memRead = 0;
        controlOut->memWrite = 0;
        controlOut->memToReg = 0;

        controlOut->ALU.op = 3;
        controlOut->ALU.bNegate = 1;
        return 1;
    }

    if (fields->opcode == 35) {
        // LW
        controlOut->memRead  = 1;
        controlOut->memWrite = 0;
        controlOut->memToReg = 1;

        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;
        return 1;

    }

    if (fields->opcode == 43) {
        // SW
        controlOut->memWrite = 1;
        controlOut->memRead = 0;
        controlOut->memToReg = 0;
        controlOut->regWrite = 0;

        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;
        return 1;
    }

    return 0;
}