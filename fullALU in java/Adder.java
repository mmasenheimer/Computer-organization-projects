/* Simulates a physical full adder,
 * comprised of half addders and one or gate
 *
 * Author: Michael Masenheimer
 */

public class Adder {

    public void execute() {

        add1.a.set(a.get());
        add1.b.set(b.get());
        // Set up the first half adder

        add1.execute();

        add2.a.set(carryIn.get());
        add2.b.set(add1.sum.get());
        // Set up the second half adder

        add2.execute();

        sum.set(add2.sum.get());
        // Get the sum from the second half addder

        carryOutOr.a.set(add1.carryOut.get());
        carryOutOr.b.set(add2.carryOut.get());
        // Set up the or gate for the carry out

        carryOutOr.execute();

        carryOut.set(carryOutOr.out.get());
        // The actual output of the full adder is the or
        // of both half adder carry out outputs
    }

    public Integer xyz;
    public HalfAdder add1;
    public HalfAdder add2;
    // Half adders

    public RussWire a;
    public RussWire b;
    public RussWire carryIn;
    // Inputs

    public RussWire sum;
    public RussWire carryOut;
    // Outputs

    public OR carryOutOr;
    // Or gate for carryOut


    public Adder() {

        this.xyz = 1027;

        this.add1 = new HalfAdder();
        this.add2 = new HalfAdder();
        // Create new halfadder objects

        this.a = new RussWire();
        this.b = new RussWire();

        this.carryIn = new RussWire();

        this.sum = new RussWire();
        this.carryOut = new RussWire();

        this.carryOutOr = new OR();
        
    }
    
}
