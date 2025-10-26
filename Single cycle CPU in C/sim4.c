/*
Simulates Instruction parsing and cpu control for a single
clock cycle CPU. This is milestone 1, so later I'll be implementing
each individual CPU component.

There are no outputs, as the whole program is one big conglomeration of 
bit getters and setters

Author: Michael Masenheimer
*/

// FIELDS I'M ADDING: SLL, BNE, NOR

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

    // Starting with clean fields
    controlOut->ALUsrc = 0;
    controlOut->ALU.op = 0;
    controlOut->ALU.bNegate = 0;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 0;
    controlOut->branch = 0;
    controlOut->jump = 0;

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

        // if (fields->funct == 0) {
        //     // SLL
        //     // TODO: implement this
        // }

        
        if (fields->funct == 32 || fields->funct == 33) {
            // add or addu instruction

            controlOut->regDst   = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 2;
            controlOut->ALU.bNegate = 0;

            return 1;
        }

        if (fields->funct == 34 || fields->funct == 35) {
            // sub or subbu instruction

            controlOut->regDst   = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 2;
            controlOut->ALU.bNegate = 1;

            return 1;
        }
        
        if (fields->funct == 36) {
            // AND instruction

            controlOut->regDst   = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 0;
            controlOut->ALU.bNegate = 0;

            return 1;
        }

        if (fields->funct == 37) {
            // OR instruction

            controlOut->regDst   = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 1;
            controlOut->ALU.bNegate = 0;

            return 1;
        }

        if (fields->funct == 38) {
            // XOR instruction

            controlOut->regDst   = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 4;
            controlOut->ALU.bNegate = 0;

            return 1;
        }

        if (fields->funct == 42) {
            // SLT instruction

            controlOut->regDst   = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 3;
            controlOut->ALU.bNegate = 1;

            return 1;
        }
        return 0;
    }

    if (fields->opcode == 2) {
        // Jump code instruction
        controlOut->jump = 1;
        return 1;
    }

    if (fields->opcode == 4) {
        // BEQ instruction

        controlOut->branch = 1;
        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 1;

        return 1;
    }

    if (fields->opcode == 8 || fields->opcode == 9) {
        // addi and addiu instruction

        controlOut->regWrite = 1;
        controlOut->ALUsrc   = 1;
        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;

        return 1;

    }

    if (fields->opcode == 10) {
        // SLTI instruciton

        controlOut->regWrite = 1;
        controlOut->ALUsrc   = 1;
        controlOut->ALU.op = 3;
        controlOut->ALU.bNegate = 1;

        return 1;
    }

    if (fields->opcode == 35) {
        // LW instruction

        controlOut->regWrite = 1;
        controlOut->ALUsrc   = 1;
        controlOut->memRead  = 1;
        controlOut->memToReg = 1;
        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;

        return 1;

    }

    if (fields->opcode == 43) {
        // SW instruction

        controlOut->ALUsrc   = 1;
        controlOut->memWrite = 1;
        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;

        return 1;
    }

    return 0;
    // Catch invalid opcode
}

WORD getInstruction(WORD curPC, WORD *instructionMemory) {

    // curPC and instructionMemory are 32 bits in size
    // curPC is byte address

    int currentInstruction = curPC / 4;
    return *(instructionMemory + currentInstruction);

}

WORD getALUinput1(CPUControl *controlIn, InstructionFields *fieldsIn, WORD rsVal, WORD rtVal, WORD reg32, WORD reg33, WORD oldPC) {

    // INCLUDES:
    // CPU control bits
    // Instructionfields for the instructions (is a struct)
    // Value of rs, rt fields from the instruction fields function
    // Value of registers 33 and 34 (OPTIONAL FOR MULT)
    // Value of PC currently executing instruction(OPTIONAL FOR EXTRA FUNCTIONS)

    return rsVal;
}

WORD getALUinput2(CPUControl *controlIn, InstructionFields *fieldsIn, WORD rsVal, WORD rtVal, WORD reg32, WORD reg33, WORD oldPC) {

    // INCLUDES:
    // CPU control bits
    // Instructionfields for the instructions (is a struct)
    // Value of rs, rt fields from the instruction fields function
    // Value of registers 33 and 34 (OPTIONAL FOR MULT)
    // Value of PC currently executing instruction(OPTIONAL FOR EXTRA FUNCTIONS)

    if (controlIn->ALUsrc == 1) {
        return fieldsIn->imm32;
    }

    return rtVal;
}

void execute_ALU(CPUControl *controlIn, WORD input1, WORD input2, ALUResult *aluResultOut) {

    //INPUTS:
    // ControlIn is the alu control wires
    // input 1-
    // input2
    // ALURESULT-

    switch (controlIn->ALU.op) {

    // Case AND
    case 0:
        aluResultOut->result = input1 & input2;
        break;

    // Case OR  
    case 1:
        aluResultOut->result = input1 | input2;
        break;

    // Case ADD
    case 2:  
        switch(controlIn->ALU.bNegate) {

            // Case TRUE ADD
            case 0:
                aluResultOut->result = input1 + input2;
                break;
            
                
            // Case SUBTRACT
            case 1:
                aluResultOut->result = input1 - input2;
                break;
        }

        break;

    // Case LESS
    case 3:
        aluResultOut->result = input1 < input2;
        break;

    // Case XOR
    case 4:
        aluResultOut->result = input1 ^ input2;
        break;
    
    // Unrecognized ALU operation
    default:
        break;
    }

    if (aluResultOut->result == 0) {
        aluResultOut->zero = 1;
    }
   
    else {
        aluResultOut->zero = 0;
    }
}

void execute_MEM(CPUControl *controlIn, ALUResult *aluResultIn, WORD rsVal, WORD rtVal, WORD *memory, MemResult  *resultOut) {

    // INPUTS
    // controlIN-CPU control struct
    // aluResultsIn- results of the alu operation
    // RS, RT values set in the instruction decoding
    // *memory is an array of WORDS, representing data memory
    // result out * if we read a value from memory, then this fields must have the value
    //
    // If we write, or do nothing, set this to zero

    // If we read from memory or not

    resultOut->readVal = 0;

    switch (controlIn->memRead) {
        // Case READ 
        case 1:
            WORD memAddress = aluResultIn->result;
            resultOut->readVal = *(memory + memAddress / 4);
            break;
        
        // If it's not 1 or 0? It should be but
        // this is a safecheck
        default:
            break;
    }

    switch (controlIn->memWrite) {       
        // WRITE
        case 1:

            *(memory + aluResultIn->result / 4) = rtVal;
            break;

        // If it's also not 1 or 0, which
        // it should be anyways
        default:
            break;
    }
}

WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero, WORD rsVal, WORD rtVal, WORD oldPC) {
    
    WORD newPC = oldPC + 4;

    // Check if it's a branch instruction
    if (controlIn->branch == 1) {
        // BEQ - only take branch if ALU result was zero
        if (aluZero == 1) {
            newPC = oldPC + 4 + (fields->imm32 << 2);
        }
    }
    // Check if it's a jump instruction
    else if (controlIn->jump == 1) {
        // J instruction
        newPC = (oldPC & 0xF0000000) | (fields->address << 2);
    }

    return newPC;
}

void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn, ALUResult  *aluResultIn, MemResult *memResultIn, WORD *regs) {

    // INPUTS:
    // fields of the instruction
    // Control bits of the instruction
    // Results from the ALU and memory
    // Pointer to the current set of registers, which may have to write to

    if (controlIn->regWrite == 0) {
        return;
    }

    int writeReg;
    WORD writeVal;

    // if we don't want to write, do nothing

    // reg dst represents the target register
    // memtowrite represents the value to write

    if (controlIn->regDst == 0) {
        // I-type instruction, the target is rt
        writeReg = fields->rt;
    }
    else {
        // R-type instruction, the target is rd
        writeReg = fields->rd;
    }
    if (controlIn->memToReg == 0) {
        writeVal = aluResultIn->result;
    }
    else {
        writeVal = memResultIn->readVal;
    }
    regs[writeReg] = writeVal;
    return;
}