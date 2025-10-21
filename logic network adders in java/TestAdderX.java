public class TestAdderX {
    public static void main(String[] args) {
        runTest(4, 3, 5);    // 0011 + 0101 = 1000
        runTest(4, 7, 8);    // 0111 + 1000 = 1111
        runTest(4, 7, 1);    // 0111 + 0001 = 1000 (overflow in 4-bit signed)
        runTest(4, 15, 1);   // 1111 + 0001 = 0000 carry out
        runTest(8, 120, 10); // bigger width: 120+10=130
    }

    private static void runTest(int width, int valA, int valB) {
        Sim2_AdderX adder = new Sim2_AdderX(width);

        // load inputs
        setBits(adder.a, valA);
        setBits(adder.b, valB);

        // run adder
        adder.execute();

        // collect result
        int result = getBits(adder.sum);
        System.out.println("A=" + valA + " B=" + valB + " => Sum=" + result +
                           " carryOut=" + adder.carryOut.get() +
                           " overflow=" + adder.overflow.get());
    }

    private static void setBits(RussWire[] wires, int value) {
        for (int i = 0; i < wires.length; i++) {
            wires[i].set(((value >> i) & 1) == 1);
        }
    }

    private static int getBits(RussWire[] wires) {
        int value = 0;
        for (int i = 0; i < wires.length; i++) {
            if (wires[i].get()) {
                value |= (1 << i);
            }
        }
        return value;
    }
}
