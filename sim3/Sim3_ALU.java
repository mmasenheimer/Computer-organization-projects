/* Sim3_ALU class
 *
 * Represents a full ALU, comprised of 32 or more individual ALU elements.
 * Each individual ALU units includes an AND, OR, ADD, XOR and LESS setting.
 * 
 * The outputs are the result of the ALU action on numbers A and B.
 * 
 * The class takes in an ALU operation, setting each ALU element to that operation,
 * bNegate indicating if we need to do subtraction, as well as the number of bits
 * which is an integer representing the number of the bits in the A and B inputs.
 *
 * Author: Michael Masenheimer
 */

public class Sim3_ALU {

    public void execute() {

    for (int i = 0; i < numberBits; i++) {
        // Set all of the bits
        
        for (int j = 0; j < 3; j++) {
            alus[i].aluOp[j].set(aluOp[j].get());
            // Set the alu operation for all of the alus
        }

        alus[i].bInvert.set(bNegate.get());
        // Set the bInvert for each alu

        alus[i].b.set(b[i].get());
        alus[i].a.set(a[i].get());
        // Set both the a and b values for each alu

    }

    alus[0].carryIn.set(bNegate.get());
    alus[0].execute_pass1();
    // For the first alu element, set the carryIn and execute pass1

    for (int i = 1; i < numberBits; i++) {
        // For each of the other ALUs, we'll set the ripple carryouts
            alus[i].carryIn.set(alus[i-1].carryOut.get());
            alus[i].less.set(false);
            alus[i].execute_pass1();
            // Set the less and execute pass 1 for each alu
    }

    alus[0].less.set(alus[numberBits-1].addResult.get());
    // Pass through to alu 0 with the output of the pervoius alu

    for (int i = 0; i < numberBits; i++) {

        alus[i].execute_pass2();
        result[i].set(alus[i].result.get());
        // Execute ALU pass 2 and get the result
    }
    
}

    public RussWire[] aluOp;
    public RussWire bNegate;

    public RussWire[] a;
    public RussWire[] b;
    // a and b are both arrays of size X

    public RussWire[] result;

    public Sim3_ALUElement[] alus;

    public int numberBits;

    // numberBits an int of size x

    public Sim3_ALU(int numBits) {

        this.numberBits = numBits;

        aluOp = new RussWire[3];

        for (int i = 0; i < 3; i++) {
            aluOp[i] = new RussWire();
            // create new wires for the input ALU op bits
        }

        bNegate = new RussWire();

        a = new RussWire[numBits];
        b = new RussWire[numBits];
        result = new RussWire[numBits];

        alus = new Sim3_ALUElement[numBits];

        for (int i = 0; i < numBits; i++) {
            // Create new wires for the inputs, results, and create 
            // x amount of alus
            a[i] = new RussWire();
            b[i] = new RussWire();
            result[i] = new RussWire();
            alus[i] = new Sim3_ALUElement();

        }

    }

}
