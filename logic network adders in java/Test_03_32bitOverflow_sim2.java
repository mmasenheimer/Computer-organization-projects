public class Test_03_32bitOverflow_sim2 {
    public static void main(String[] args) {
        String numA = "11111011011100000101111100100010";
        String numB = "10000000000000011001101010101110";
        System.out.println("  " + numA + "\n+ " + numB);
        for(int i = 0; i < numA.length() + 3; i++) {
            System.out.print("-");
        }
        RussWire[] a = new RussWire[numA.length()];
        RussWire[] b = new RussWire[numA.length()];
        Sim2_AdderX adder = new Sim2_AdderX(numA.length());

        for(int i = 0; i < numA.length(); i++) {
            a[i] = new RussWire();
            boolean aBool = numA.substring(numA.length()-i-1,numA.length()-i
                            ).equals("1");
            a[i].set(aBool);
            b[i] = new RussWire();
            boolean bBool = numB.substring(numB.length()-i-1,numB.length()-i
                            ).equals("1");
            b[i].set(bBool);
        }

        adder.a = a;
        adder.b = b;
        adder.execute();
        System.out.print("\n  ");
        for(int i = numA.length()-1; i >= 0; i--) {
            int currentBit = adder.sum[i].get() ? 1 : 0;
            System.out.print(currentBit);
        }
        System.out.println();
        System.out.println("Carry Out: " + (adder.carryOut.get()));
        System.out.println("Overflow:  " + (adder.overflow.get()));
    }
}
