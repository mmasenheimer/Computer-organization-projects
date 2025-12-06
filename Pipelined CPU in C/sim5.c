/*
Simulates Instruction parsing and cpu control for a
pipelined cpu.

This program takes an instruction, separates each
part and executes the different simulated hardware based on that
instruction. It also checks for data hazards.

There are no outputs, as the whole program is one big conglomeration of 
bit getters, setters, and if else statements for each phase of the CPU.

Author: Michael Masenheimer
*/

// ID PHASE

#include "sim5.h"

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
    fieldsOut->imm16  = instruction & 0xFFFF;           // bits 15-0

    if (fieldsOut->imm16 & 0x8000) {
        fieldsOut->imm32 = fieldsOut->imm16 | 0xFFFF0000;
        // Extend imm16 into imm32
    } else {
        fieldsOut->imm32 = fieldsOut->imm16;
    }

    fieldsOut->address= instruction & 0x3FFFFFF;        // bits 25-0
}

/*
ID_to_IF_get_stall()

This function checks to see if we need to stall based on a set of instructions and
control bits from the pipeline registers. We first check what type of instruction it is
and then check the other phases to see if we need to stall or insert a no op.

Returns 1 or 0 depending on if we need a stall or not.

*/

int IDtoIF_get_stall(InstructionFields *fields, ID_EX *oldIdex, EX_MEM *oldMem) {

    if (fields->opcode > 63 || fields->opcode < 0) {
        // This is an invalid opcode
        return 0;
    }

    if (fields->opcode == 0 && (fields->funct > 63 || fields->funct < 0)) {
        // This is an invalid function field
        return 0;
    }

    int readsRs = 0;
    int readsRt = 0;

    if (fields->opcode == 0) {
        // R type always has rs and rt
        readsRs = 1;
        readsRt = 1;
    }

    else if (fields->opcode == 4 || fields->opcode == 5) {
        // Branch if equal and branch if not equal use rs and rt
        readsRs = 1;
        readsRt = 1;
    }

    else if (fields->opcode == 8 || fields->opcode == 9 || fields->opcode == 10 || fields->opcode == 12 || fields->opcode == 13 || fields->opcode == 35 || fields->opcode == 43) {
        // All of these instructions use the rs register
        readsRs = 1;
    }

   if (fields->opcode == 43) {
        // SW uses rt value
        readsRt = 1;
    }

    if (oldIdex->memRead == 1 && oldIdex->regWrite == 1 && fields->opcode != 43) {
        // Check for a load use hazard from ID EX stage
        int loadDestination = (oldIdex->regDst == 0) ? oldIdex->rt : oldIdex->rd;

        // I am not stalling if the instruction is s a SW because we can let data forwarding handle it

        if ((readsRs && fields->rs == loadDestination) ||
            (readsRt && fields->rt == loadDestination)) {
            return 1;
            // Need to stall if the rs field and the load destination are the same
            // (Insert a no op)
        }
    }

    if (oldMem->regWrite == 1 && oldMem->writeReg != 0) {
        // This is a check for hazards from EX/MEM stage

        int idexDestination = -1;
        // Determining what ID/EX is writing (if its writing anything
        if (oldIdex->regWrite == 1) {

            if (oldIdex->regDst == 0) {
                idexDestination = oldIdex->rt;
            }

            else {
                idexDestination = oldIdex->rd;
            }
        }

        if (oldMem->memRead == 1 && fields->opcode != 43) {
            // For LOAD instructions in the MEM phase, we want to stall if any non sw instruction reads that register
            if ((readsRs && fields->rs == oldMem->writeReg) || (readsRt && fields->rt == oldMem->writeReg)) {
                return 1;
            }
        }

        // For SW: stall if rt matches EX/MEM destination
        // BUT only if ID/EX is NOT also writing to the same register
        else if (fields->opcode == 43 && readsRt && fields->rt == oldMem->writeReg) {
            if (idexDestination != oldMem->writeReg) {
                return 1;
            }
        }
    }

    return 0;
}

int IDtoIF_get_branchControl(InstructionFields *fields, WORD rsVal, WORD rtVal) {

    if (fields->opcode == 2) {

        // This is for an absolute jump
        return 2;
    }

    if (fields->opcode == 4) {

        if (rsVal == rtVal) {
            return 1;
            // We take the branch
        }

        else {
            return 0;
            // Do not take the branch and thus advance the PC as normal
        }
    }

    if (fields->opcode == 5) {
        // This is for BNE instruction

        if (rsVal != rtVal) {
            // Branch if rs does not equal rt
            return 1;
        }

        else {
            return 0;
            // Do not take the branch and thus advance the PC as normal
        }
    }

    return 0;
    // No branch or jump

}

int calc_branchAddr(WORD pcAddFour, InstructionFields *fields) {

    WORD curr = fields->imm32 << 2;
    // Calculate the offset (sign extended)

    return pcAddFour + curr;
    // Return the branch address

}

int calc_jumpAddr(WORD pcAddFour, InstructionFields *fields) {

    WORD curr = fields->address << 2;
    // Shift address by 2 

    WORD upper = pcAddFour & 0xF0000000;
    // Grab the upper 4 bits

    return upper | curr;
}

int execute_ID(int IDstall, InstructionFields *fields, WORD pcAddFour, WORD rsVal, WORD rtVal, ID_EX *controlOut) {

    if (IDstall == 1) {

        controlOut->ALUsrc = 0;
        controlOut->ALU.op = 0;
        controlOut->ALU.bNegate = 0;
        controlOut->memRead = 0;
        controlOut->memWrite = 0;
        controlOut->memToReg = 0;
        controlOut->regDst = 0;
        controlOut->regWrite = 0;
        
        controlOut->rs = 0;
        controlOut->rt = 0;
        controlOut->rd = 0;
        controlOut->rsVal = 0;
        controlOut->rtVal = 0;
        controlOut->imm16 = 0;
        controlOut->imm32 = 0;
        controlOut->extra1 = 0;
        controlOut->extra2 = 0;
        controlOut->extra3 = 0;

        return 1;
    }

    controlOut->rs = fields->rs;
    controlOut->rt = fields->rt;
    controlOut->rd = fields->rd;
    controlOut->rsVal = rsVal;
    controlOut->rtVal = rtVal;
    controlOut->imm16 = fields->imm16;
    controlOut->imm32 = fields->imm32;
    // These items are the register  information

    controlOut->ALUsrc = 0;
    controlOut->ALU.op = 0;
    controlOut->ALU.bNegate = 0;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 0;
    controlOut->extra1 = 0;
    controlOut->extra2 = 0;
    controlOut->extra3 = 0;

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

        if (fields->funct == 0) {
            // SLL

            controlOut->regDst = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 5;

            return 1;
        }
        
        if (fields->funct == 32 || fields->funct == 33) {
            // add or addu instruction

            controlOut->regDst = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 2;
            controlOut->ALU.bNegate = 0;

            return 1;
        }

        if (fields->funct == 34 || fields->funct == 35) {
            // sub or subbu instruction

            controlOut->regDst = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 2;
            controlOut->ALU.bNegate = 1;

            return 1;
        }
        
        if (fields->funct == 36) {
            // AND instruction

            controlOut->regDst = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 0;
            controlOut->ALU.bNegate = 0;

            return 1;
        }

        if (fields->funct == 37) {
            // OR instruction

            controlOut->regDst = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 1;
            controlOut->ALU.bNegate = 0;

            return 1;
        }

        if (fields->funct == 38) {
            // XOR instruction

            controlOut->regDst = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 4;
            controlOut->ALU.bNegate = 0;

            return 1;
        }

        if (fields->funct == 39) {
            // NOR instruction

            controlOut->regDst = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 6;

            return 1;
        }

        if (fields->funct == 42) {
            // SLT instruction

            controlOut->regDst = 1;
            controlOut->regWrite = 1;
            controlOut->ALU.op = 3;
            controlOut->ALU.bNegate = 1;

            return 1;
        }
        return 0;
    }

    if (fields->opcode == 2) {
        // Jump code 
        controlOut->rs = 0;
        controlOut->rt = 0;
        controlOut->rd = 0;
        controlOut->rsVal = 0;
        controlOut->rtVal = 0;

        return 1;
    }

    if (fields->opcode == 4) {
        // BEQ instruction
        controlOut->rs = 0;
        controlOut->rt = 0;
        controlOut->rd = 0;
        controlOut->rsVal = 0;
        controlOut->rtVal = 0;

        return 1;
    }

    if (fields->opcode == 5) {
        // BNE instruction
        controlOut->rs = 0;
        controlOut->rt = 0;
        controlOut->rd = 0;
        controlOut->rsVal = 0;
        controlOut->rtVal = 0;

        return 1;
    }

    if (fields->opcode == 8 || fields->opcode == 9) {
        // addi and addiu instruction

        controlOut->regWrite = 1;
        controlOut->ALUsrc = 1;
        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;
        controlOut->regDst = 0;

        return 1;
    }

    if (fields->opcode == 10) {
        // SLTI instruciton

        controlOut->regWrite = 1;
        controlOut->ALUsrc = 1;
        controlOut->regDst = 0;
        controlOut->ALU.op = 3;
        controlOut->ALU.bNegate = 1;

        return 1;
    }

    if (fields->opcode == 12) {
        // ANDI instruction

        controlOut->regWrite = 1;
        controlOut->ALUsrc = 2;
        controlOut->regDst = 0;
        controlOut->ALU.op = 0;
        controlOut->ALU.bNegate = 0;

        return 1;
    }

    if (fields->opcode == 13) {
        // ORI instruction

        controlOut->regWrite = 1;
        controlOut->regDst = 0;
        controlOut->ALUsrc = 2;
        controlOut->ALU.op = 1;
        controlOut->ALU.bNegate = 0;
    
        return 1;
    }

    if (fields->opcode == 15) {
        // LUI instruction

        controlOut->regWrite = 1;
        controlOut->ALUsrc = 2;
        controlOut->regDst = 0;
        controlOut->ALU.op = 7;
        controlOut->ALU.bNegate = 0;

        return 1;
    }

    if (fields->opcode == 35) {
        // LW instruction

        controlOut->regWrite = 1;
        controlOut->regDst = 0;
        controlOut->ALUsrc = 1;
        controlOut->memRead = 1;
        controlOut->memToReg = 1;
        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;

        return 1;
    }

    if (fields->opcode == 43) {
        // SW instruction

        controlOut->ALUsrc = 1;
        controlOut->memWrite = 1;
        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 0;

        return 1;
    }

    return 0;
    // Catch invalid opcode
}

// EX PHASE ////////////////////////////////////////////////////////////////////////////////////////////

/*
getInstruction(curPC, *InstructionFields)

This function takes in the current pc counter and returns
the memory asssociated with the instruction

Returns the instruction associated with the instruction pointer
*/

WORD getInstruction(WORD curPC, WORD *instructionMemory) {
    // curPC is byte address

    int currentInstruction = curPC / 4;
    return *(instructionMemory + currentInstruction);
}

WORD EX_getALUinput1(ID_EX *idEx, EX_MEM *exMem, MEM_WB *memWb) {

    WORD firstInput = idEx->rsVal;

    if (exMem->regWrite == 1 && exMem->writeReg == idEx->rs) {

        // Checking for forwarding: if ex/mem register will write to a register, and the
        // destination register matches the src register
        // and the destination register is not 0
        firstInput = exMem->aluResult;

        // We'll use data forwarding here from EX/MEM
    }

    else if (memWb->regWrite == 1 && memWb->writeReg == idEx->rs) {


        if (memWb->memToReg == 1) {
            
            firstInput = memWb->memResult;
        }

        else {
            firstInput = memWb->aluResult;
        }
    }

    return firstInput;
}

WORD EX_getALUinput2(ID_EX *idEx, EX_MEM *exMem, MEM_WB *memWb) {

    WORD secondInput;

    if (idEx->ALUsrc == 0) {

        secondInput = idEx->rtVal;
        // rtVal is the default value for the second input

        if (exMem->regWrite == 1 && exMem->writeReg == idEx->rt) {
            // I'm checking for forwarding from EX/MEM stage

            secondInput = exMem->aluResult;
            // We forward the ALU result from the EXMEM register 
        }

        else if (memWb->regWrite == 1 && memWb->writeReg == idEx->rt) {
            // CHeck for forwarding from the MEM/WB register

            if (memWb->memToReg == 1) {
                // Must have been one of the load instructions so we'll use the memory result
                secondInput = memWb->memResult;
            }

            else {
                secondInput = memWb->aluResult;
                // Otherwise just use the ALY result
            }
        }
    }

    else if (idEx->ALUsrc == 1) {
        // Used by ADDI(U), SLTI, LW, and SW

        secondInput = idEx->imm32;
        // Use the sign exxtended imm 16 value
    }

    else if (idEx->ALUsrc == 2) {
        // Used by ANDI, ORI, LUI

        secondInput = idEx->imm16;
        // Want to use the zero extended immediate value
    }
    
    else {
        secondInput = 0;
        // I don't think this should happen if the instruction is valid,
        // But i need to have an else block to catch anything else
    }

    return secondInput;
}

void execute_EX(ID_EX *controlIn, WORD input1, WORD input2, EX_MEM *new_exMem) {

    WORD aluResult;

    switch (controlIn->ALU.op) {

    // Case AND
    case 0:
        aluResult = input1 & input2;
        break;

    // Case OR  
    case 1:
        aluResult = input1 | input2;
        break;

    // Case ADD
    case 2:  
        switch(controlIn->ALU.bNegate) {

            // Case TRUE ADD
            case 0:
                aluResult = input1 + input2;
                break;
                
            // Case SUBTRACT
            case 1:
                aluResult = input1 - input2;
                break;
        }

        break;

    // Case LESS (Set less than)
    case 3:
        
        if (input1 < input2) {
            aluResult = 1;
        }

        else {
            aluResult = 0;
        }

        break;

    // Case XOR
    case 4:
        aluResult = input1 ^ input2;
        break;
    
    // Case SHIFT LEFT
    case 5:
        aluResult = controlIn->rtVal << controlIn->imm16;
        // Use shamt fromt the instruction
        break;
    
    // Case NOR
    case 6:
        aluResult = ~(input1 | input2);
        break;

    // CASE LUI
    case 7:
        aluResult = input2 << 16;
        break;

    // Unrecognized ALU operation (This shouldn't happen)
    default:
        aluResult = 0;
        break;
    }

    new_exMem->aluResult = aluResult;

    // Determining which register to write to
    if (controlIn->regDst == 0) {
        // I type instruction
        new_exMem->writeReg = controlIn->rt;
    }

    else {
        // R type instruction
        new_exMem->writeReg = controlIn->rd;
    }

    new_exMem->memRead = controlIn->memRead;
    new_exMem->memWrite = controlIn->memWrite;
    new_exMem->memToReg = controlIn->memToReg;
    new_exMem->regWrite = controlIn->regWrite;
    // Copy the control signals to EXMEM register

    new_exMem->rt = controlIn->rt;
    new_exMem->rtVal = controlIn->rtVal;
    // copy rt values for potential forwarding

}

// MEM ////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
execute_MEM(*controlIn, *aluResultsIn, rsVal, rtVal, *memory, *resultOut)

This function executes the memory, depending on the memread or
memwrite value. It either reads from or writes to the memory, whuich
is represented by a word array. *memory points to the address of
the start of the array.

Returns: Nothing, but sets the memory result value, saving and reading
accordingly.
*/

void execute_MEM(EX_MEM *in, MEM_WB *originalWb, WORD *mem, MEM_WB *newWb) {

    WORD writeData = in->rtVal;
    // This is the value we might write to memory if needed

    
    if (originalWb->regWrite == 1 && originalWb->writeReg != 0 && originalWb->writeReg == in->rt) {
        // First check for SW data forwarding from the MEM/WB pipeline register

        if (originalWb->memToReg == 1) {

            writeData = originalWb->memResult;
            // The instruction must have been a load so use the memory result
        }

        else {
            writeData = originalWb->aluResult;
            // Otherwise we use the ALU result
        }
    }

    if (in->memRead == 1) {
        // Handling LW instruction for memory read
        WORD memAddress = in->aluResult;
        newWb->memResult = *(mem + memAddress / 4);
    }

    else {
        newWb->memResult = 0;
    }

    if (in->memWrite == 1) {
        // Handling memory WRITE
        WORD memAddress = in->aluResult;
        *(mem + memAddress / 4) = writeData;
    }

    newWb->memToReg = in->memToReg;
    newWb->aluResult = in->aluResult;
    newWb->writeReg = in->writeReg;
    newWb->regWrite = in->regWrite;
    // Copying the control signals to the MEM/WB register for the last stage
    
}

// WB /////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
execute_updateRegs(*fields, *controlIN, *aluResultsIn, *memResultIn, *regs)

This function updates the registers (if needed) that were involved in the
instruction operation.

Returns: Nothing, just sets the registers

*/
void execute_WB(MEM_WB *in, WORD *regs) {

    if (in->regWrite == 0) {
        // Don't write to a register if regWrite is 0
        return;
    }

    if (in->writeReg == 0) {
        // Don't write to register 0
        return;
    }

    WORD writeVal;

    // What value to write to where
    if (in->memToReg == 0) {
        // Use ALU result
        writeVal = in->aluResult;
    } else {
        // Use memory result (This is used for load-type instructions)
        writeVal = in->memResult;
    }

    regs[in->writeReg] = writeVal;
    // Write the balue to the register
}