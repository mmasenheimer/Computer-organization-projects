/*
 * Sim3_MUX_8by1
 * 
 * Represents an 8-to-1 multiplexer using three control bits.
 * Outputs one of eight inputs based on the control combination.
 *
 * Author: Michael Masenheimer
 */

public class Sim3_MUX_8by1 {

    public void execute() {

        not1.execute();
        not2.execute();
        not3.execute();
        // Invert control bits


        boolean andOne   = not3.out.get() && not2.out.get() && not1.out.get() && inOne.get();
        boolean andTwo   = not3.out.get() && not2.out.get() && controlOne.get() && inTwo.get();
        boolean andThree = not3.out.get() && controlTwo.get() && not1.out.get() && inThree.get();
        boolean andFour  = not3.out.get() && controlTwo.get() && controlOne.get() && inFour.get();
        boolean andFive  = controlThree.get() && not2.out.get() && not1.out.get() && inFive.get();
        boolean andSix   = controlThree.get() && not2.out.get() && controlOne.get() && inSix.get();
        boolean andSeven = controlThree.get() && controlTwo.get() && not1.out.get() && inSeven.get();
        boolean andEight = controlThree.get() && controlTwo.get() && controlOne.get() && inEight.get();

        boolean output = andOne || andTwo || andThree || andFour || andFive || andSix || andSeven || andEight;
        out.set(output);
        // Combine all AND results
    }

    public RussWire[] control;
    public RussWire[] in;
    public RussWire out;

    public NOT not1, not2, not3;
    // NOT gates for inverted control bits

    public RussWire controlOne, controlTwo, controlThree;
    public RussWire inOne, inTwo, inThree, inFour, inFive, inSix, inSeven, inEight;

    public Sim3_MUX_8by1() {
        control = new RussWire[3];
        in = new RussWire[8];

        for (int i = 0; i < 8; i++)
            in[i] = new RussWire();

        for (int i = 0; i < 3; i++)
            control[i] = new RussWire();

        inOne = in[0];
        inTwo = in[1];
        inThree = in[2];
        inFour = in[3];
        inFive = in[4];
        inSix = in[5];
        inSeven = in[6];
        inEight = in[7];

        controlOne = control[0];
        controlTwo = control[1];
        controlThree = control[2];

        not1 = new NOT();
        not2 = new NOT();
        not3 = new NOT();

        not1.in = control[0];
        not2.in = control[1];
        not3.in = control[2];

        out = new RussWire();
    }
}
