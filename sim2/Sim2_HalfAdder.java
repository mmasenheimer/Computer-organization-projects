/* Simulates a physical half adder, comprised of XOR and AND gates
 *
 * Author: Michael Masenheimer
 */


public class Sim2_HalfAdder {

    public void execute() {
        sumCompute.a.set(a.get());
        sumCompute.b.set(b.get());
        // Set up the 

        and1.a.set(a.get());
        and1.b.set(b.get());

        sumCompute.execute();
        and1.execute();

        sum.set(sumCompute.out.get());

        carryOut.set(and1.out.get());
        
    }

    public RussWire a,b;
	public RussWire sum;
    public RussWire carryOut;
    public Integer xb;
    public Sim2_XOR sumCompute;
    public Sim2_AND and1;

    public Sim2_HalfAdder() {

        this.a = new RussWire();
        this.b = new RussWire();

        this.sum = new RussWire();
        this.carryOut = new RussWire();

        this.xb = 10;
        this.sumCompute = new Sim2_XOR();

        this.and1 = new Sim2_AND();

    }

}