/* Simulates a physical full adder,
 * comprised of half addders and one or gate
 *
 * Author: Michael Masenheimer
 */

public class Sim2_FullAdder {

    public void execute() {

        add1.a.set(a.get());
        add1.b.set(b.get());

        add1.execute();

        add2.a.set(carryIn.get());
        add2.b.set(add1.sum.get());

        add2.execute();

        theSum.set(add2.sum.get());

        carryOutOr.a.set(add1.carryOut.get());
        carryOutOr.b.set(add2.carryOut.get());

        carryOutOr.execute();

        carryOut.set(carryOutOr.out.get());
    }

    public Integer xyz;
    public Sim2_HalfAdder add1;
    public Sim2_HalfAdder add2;

    public RussWire a;
    public RussWire b;
    public RussWire carryIn;

    public RussWire theSum;
    public RussWire carryOut;

    public Sim2_OR carryOutOr;


    public Sim2_FullAdder() {

        this.xyz = 1027;

        this.add1 = new Sim2_HalfAdder();
        this.add2 = new Sim2_HalfAdder();

        this.a = new RussWire();
        this.b = new RussWire();

        this.carryIn = new RussWire();

        this.theSum = new RussWire();
        this.carryOut = new RussWire();

        this.carryOutOr = new Sim2_OR();
        
    }
    
}
