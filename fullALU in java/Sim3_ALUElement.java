/*
 * Sim3_ALUElement class
 * 
 * This class represents one ALU element which has inputs a, b which are
 * bits and RussWire[] aluOp which represents the alu operation in a three bit array.
 * and bInvert.
 * 
 * The outputs include the result of the alu
 * 
 * Author: Michael Masenheimer
 * 
 */

public class Sim3_ALUElement {

    public void execute_pass1() {

        aluAdder.carryIn.set(carryIn.get());

        aluAdder.a.set(a.get());

        notGate.in.set(b.get());
        notGate.execute();
        // Set the not gate

        bInvertMux.a.set(b.get());
        bInvertMux.b.set(notGate.out.get());
        bInvertMux.controlBit.set(bInvert.get());
        // Set the b invert mux 

        bInvertMux.execute();
        
        aluAdder.b.set(bInvertMux.out.get());

        aluAdder.execute();

        carryOut.set(aluAdder.carryOut.get());
        addResult.set(aluAdder.sum.get());
        // Set the adder

        passOneResults[2].set(aluAdder.sum.get());

        andGate.a.set(a.get());
        andGate.b.set(bInvertMux.out.get());
        // Set the and gate

        andGate.execute();
        passOneResults[0].set(andGate.out.get());

        orGate.a.set(a.get());
        orGate.b.set(bInvertMux.out.get());
        // Set the or gate

        orGate.execute();
        passOneResults[1].set(orGate.out.get());

        xorGate.a.set(a.get());
        xorGate.b.set(bInvertMux.out.get());
        // Set the xor gate

        xorGate.execute();
        passOneResults[4].set(xorGate.out.get());

        passOneResults[5].set(false);
        passOneResults[6].set(false);
        passOneResults[7].set(false);
        // These values won't be used

    }

    public void execute_pass2() {
    
        for (int i = 0; i < aluOp.length; i++) {
            theMux.control[i].set(aluOp[i].get());
            // Set the control 
        }

        for (int i = 0; i < passOneResults.length; i++) {
            theMux.in[i].set(passOneResults[i].get());
        }

        theMux.execute();
        result.set(theMux.out.get());
        
    }

    public RussWire bInvert;

    public RussWire carryIn;

    public RussWire a, b;
    public RussWire[] aluOp;
    public RussWire less;
    public RussWire[] passOneResults;

    public RussWire result;
    public RussWire addResult;
    public RussWire carryOut;
    public Adder aluAdder;
    public Sim3_MUX_8by1 theMux;
    public AND andGate;
    public OR orGate;
    public XOR xorGate;
    public Sim3_MUX_2by1 bInvertMux;
    public NOT notGate;

    public Sim3_ALUElement() {
    
        this.result = new RussWire();
        this.addResult = new RussWire();
        this.carryOut = new RussWire();
        this.bInvert = new RussWire();
        this.bInvertMux = new Sim3_MUX_2by1();
        this.notGate = new NOT();
        this.passOneResults = new RussWire[8];
        this.carryIn = new RussWire();
        // Make new RussWires for inputs outputs

        for (int i = 0; i < 3; i++) {
            passOneResults[i] = new RussWire();
            // Add wires for passone results
        }

        for (int i = 4; i < 8; i++) {
            passOneResults[i] = new RussWire();
            // Add new wires for the passone results
        }

        this.less = new RussWire();
        passOneResults[3] = less;
 
        this.a = new RussWire();
        this.b = new RussWire();
        this.aluAdder = new Adder();

        this.aluOp = new RussWire[3];
        for (int i = 0; i < 3; i++) {
            aluOp[i] = new RussWire();
        }

        this.theMux = new Sim3_MUX_8by1();
        this.andGate = new AND();
        this.orGate = new OR();
        this.xorGate = new XOR();

    }

}
