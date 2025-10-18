/*
 * Sim3_MUX_2by1
 * 
 * Represents a 2-to-1 multiplexer. 
 * Selects between inputs 'a' and 'b' based on controlBit.
 * If controlBit = 0 → output = a
 * If controlBit = 1 → output = b
 * 
 * Author: Michael Masenheimer
 */

public class Sim3_MUX_2by1 {

    public void execute() {

        notControl.execute();

        // Compute both terms and combine
        boolean term1 = notControl.out.get() && a.get();
        boolean term2 = controlBit.get() && b.get();

        out.set(term1 || term2);
    }

    public Sim3_MUX_2by1() {
    
        a = new RussWire();
        b = new RussWire();
        controlBit = new RussWire();
        out = new RussWire();

        // Initialize NOT gate for control inversion
        notControl = new NOT();
        notControl.in = controlBit;
    }

    public RussWire a, b;  
    public RussWire controlBit;
    public NOT notControl;       
    public RussWire out;          
}

