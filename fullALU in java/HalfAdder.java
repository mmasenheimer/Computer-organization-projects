/* Simulates a physical half adder, comprised of XOR and AND gates
 *
 * Author: Michael Masenheimer
 */

public class HalfAdder {

    public void execute() {
        sumCompute.a.set(a.get());
        sumCompute.b.set(b.get());
        // XOR gate for computing sum of the bits 

        and1.a.set(a.get());
        and1.b.set(b.get());
        // Set up the AND gate for both bits

        sumCompute.execute();
        and1.execute();

        sum.set(sumCompute.out.get());
        carryOut.set(and1.out.get());
        // Set the carryOut and sums according to the outputs
        // Of both gates
        
    }

    public RussWire a,b;

	public RussWire sum;
    public RussWire carryOut;
    // Outputs

    public Integer xb;

    public XOR sumCompute;
    public AND and1;
    // Gates

    public HalfAdder() {

        this.a = new RussWire();
        this.b = new RussWire();
        // Set up input bits

        this.sum = new RussWire();
        this.carryOut = new RussWire();
        // Sum and if there is carry out fields

        this.xb = 10;
        this.sumCompute = new XOR();
        // Gate for computing sum

        this.and1 = new AND();

    }

}