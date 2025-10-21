/*
Simulates Instruction parsing and cpu control for a single
clock cycle CPU. This is milestone 1, so later I'll be implementing
each individual CPU component.

There are no outputs, as the whole program is one big conglomeration of 
bit getters and setters

Author: Michael Masenheimer
*/

#include "sim4.h"

/*
extract_instructionFields()

This function parses a WORD instruction and sets the
proper CPU functions within the fieldsOut
InstrunctionFields.

It also has a bit extender for the main body of the
instruction from 16-32 bits.
*/
void extract_instructionFields(WORD instruction, InstructionFields* fieldsOut) {

    fieldsOut->opcode = (instruction >> 26) & 0x3F;     // bits 31-26
    fieldsOut->rs     = (instruction >> 21) & 0x1F;     // bits 25-21
    fieldsOut->rt     = (instruction >> 16) & 0x1F;     // bits 20-16
    fieldsOut->rd     = (instruction >> 11) & 0x1F;     // bits 15-11
    fieldsOut->shamt  = (instruction >> 6)  & 0x1F;     // bits 10-6
    fieldsOut->funct  = instruction & 0x3F;             // bits 5-0
    fieldsOut->imm16    = instruction & 0xFFFF;         // bits 15-0

    if (fieldsOut->imm16 & 0x8000) {
        fieldsOut->imm32 = fieldsOut->imm16 | 0xFFFF0000;
        // Extend imm16 into imm32
    } else {
        fieldsOut->imm32 = fieldsOut->imm16;
    }

    fieldsOut->address= instruction & 0x3FFFFFF;        // bits 25-0

}

/*
fill_CPUControl()

This function takes the fields in the InstructionFields
set by the previous function and translates them
into actual bitwise CPU control wires.

Returns nothing
*/

int fill_CPUControl(InstructionFields* fields, CPUControl* controlOut) {

    if (fields->opcode > 63 || fields->opcode < 0) {
        // Ivalid opcode
        return 0;
    }

    if (fields->opcode == 0) {
        // R type opcode

        if (fields->funct > 63 || fields->funct < 0) {
            // Invalid function code
            return 0;
        }

        /* 
        These represent common r-format fields where every r format
        instruction uses these fields as is. They may be 
        overwritten depending on the type of funct code
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
            // add or addu instruction
            controlOut->ALU.op = 2;
            controlOut->ALU.bNegate = 0;
            return 1;
        }

        if (fields->funct == 34 || fields->funct == 35) {
            // sub or subbu instruction
            controlOut->ALU.op = 2;
            controlOut->ALU.bNegate = 1;
            return 1;
        }
        
        if (fields->funct == 36) {
            // AND instruction
            controlOut->ALU.op = 0;
            controlOut->ALU.bNegate = 0;
            return 1;
        }

        if (fields->funct == 37) {
            // OR instruction
            controlOut->ALU.op = 1;
            controlOut->ALU.bNegate = 0;
            return 1;
        }

        if (fields->funct == 38) {
            // XOR instruction
            controlOut->ALU.op = 4;
            controlOut->ALU.bNegate = 0;
            return 1;
        }

        if (fields->funct == 42) {
            // SLT instruction
            controlOut->ALU.op = 3;
            controlOut->ALU.bNegate = 1;
            return 1;
        }
        return 0;
    }

    if (fields->opcode == 2) {
        // Jump code instruction
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
    instruction uses these fields as is. These might be 
    overwritten depending on the opcode
    */

    controlOut->regDst   = 0;
    controlOut->regWrite = 1;
    controlOut->ALUsrc   = 1;
    controlOut->branch   = 0;
    controlOut->jump     = 0;

    if (fields->opcode == 4) {
        // BEQ instruction
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
        // addi and addiu instruction
        controlOut->memRead = 0;
        controlOut->memWrite = 0;
        controlOut->memToReg = 0;

        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;
        return 1;

    }

    if (fields->opcode == 10) {
        // SLTI instruciton
        controlOut->memRead = 0;
        controlOut->memWrite = 0;
        controlOut->memToReg = 0;

        controlOut->ALU.op = 3;
        controlOut->ALU.bNegate = 1;
        return 1;
    }

    if (fields->opcode == 35) {
        // LW instruction
        controlOut->memRead  = 1;
        controlOut->memWrite = 0;
        controlOut->memToReg = 1;

        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;
        return 1;

    }

    if (fields->opcode == 43) {
        // SW instruction
        controlOut->memWrite = 1;
        controlOut->memRead = 0;
        controlOut->memToReg = 0;
        controlOut->regWrite = 0;

        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;
        return 1;
    }

    return 0;
    // Catch invalid opcode
}