public class Sim2_AdderX {

    public void execute() {
        boolean carryValue = false;
        boolean prevCarryValue = false;

        for (int i = 0; i < numBits; i++) {
            // Use pre-created FullAdder from constructor
            fullAdders[i].a.set(this.a[i].get());
            fullAdders[i].b.set(this.b[i].get());
            fullAdders[i].carryIn.set(carryValue);

            fullAdders[i].execute();

            sum[i].set(fullAdders[i].theSum.get());

            prevCarryValue = carryValue;
            carryValue = fullAdders[i].carryOut.get();
        }

        carryOut.set(carryValue);
        overflow.set(prevCarryValue ^ carryValue);
}

    public int numBits;

    public RussWire[] a;
    public RussWire[] b;

    public RussWire[] sum;

    public RussWire carryOut;
    public RussWire overflow;

    public Sim2_FullAdder[] fullAdders;

    public Sim2_AdderX(int numBits) {
        this.numBits = numBits;

        this.a = new RussWire[numBits];
        this.b = new RussWire[numBits];

        this.sum = new RussWire[numBits];

        this.carryOut = new RussWire();
        //carryOut.set(false);

        this.overflow = new RussWire();
        //overflow.set(false);

        this.fullAdders = new Sim2_FullAdder[numBits];

        for (int i = 0; i < numBits; i++) {
            this.a[i] = new RussWire();
            this.b[i] = new RussWire();
            this.sum[i] = new RussWire();
            this.fullAdders[i] = new Sim2_FullAdder();
        }

    }
}  
