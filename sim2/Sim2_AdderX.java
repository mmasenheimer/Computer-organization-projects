/*
 * Simulates a "Ripple adder" where we might need n full adders
 * to add numbers together bitwise. 
 * 
 * Author: Michael Masenheimer
 */

public class Sim2_AdderX {

    public void execute() {
        boolean carryValue = false;
        boolean prevCarryValue = false;

        for (int i = 0; i < numBits; i++) {

            fullAdders[i].a.set(this.a[i].get());
            fullAdders[i].b.set(this.b[i].get());
            // Use pre-created FullAdder from constructor

            fullAdders[i].carryIn.set(carryValue);
            fullAdders[i].execute();
            // Set the carryIn for each input bit in the array

            sum[i].set(fullAdders[i].sum.get());

            prevCarryValue = carryValue;
            carryValue = fullAdders[i].carryOut.get();
            // Reset the prev carry value and the current carry value

        }

        carryOut.set(carryValue);
        overflow.set(prevCarryValue ^ carryValue);
        // Set the carry out and overflow,
        // if the prev carry value is different from the current
        // carry calue, there is overflow
}

    public int numBits;

    public RussWire[] a;
    public RussWire[] b;
    // Inputs, a and b are numbers represented by arrays
    // of RussWire objects

    public RussWire[] sum;
    public RussWire carryOut;
    public RussWire overflow;
    // Outputs, where sum is a new bitwise number
    // by adding the previous numbers

    public Sim2_FullAdder[] fullAdders;
    // Array of fulladders to be used for each bit

    public Sim2_AdderX(int numBits) {
        this.numBits = numBits;

        this.a = new RussWire[numBits];
        this.b = new RussWire[numBits];
        // Create new RussWire arrays to represent the objects

        this.sum = new RussWire[numBits];

        this.carryOut = new RussWire();
        this.overflow = new RussWire();
        // Create new wires for carryOut and overflow

        this.fullAdders = new Sim2_FullAdder[numBits];

        for (int i = 0; i < numBits; i++) {
            this.a[i] = new RussWire();
            this.b[i] = new RussWire();
            // Initialize a new array of wires for inputs

            this.sum[i] = new RussWire();
            // Sum output wire

            this.fullAdders[i] = new Sim2_FullAdder();
            // This is an array of adders that is
            // instantiated to be length n, where n is the number
            // of input bits, equivalent to the input array of bits
        }

    }
}  
