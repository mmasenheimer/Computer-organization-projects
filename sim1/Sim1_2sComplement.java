/* Simulates a physical device that performs 2's complement on a 32-bit input.
 *
 * Author: Michael Masenheimer
 */

public class Sim1_2sComplement
{
	public void execute()
	{

		// Inverting each bit, this is the first step in 2s complement
		for (int i = 0; i < 32; i++) {
			notGates[i].in.set(in[i].get());
			notGates[i].execute();
			// Use the not gate on the current bit
		}

		for (int i = 0; i < 32; i++) {
			adder.a[i].set(notGates[i].out.get());
			// This sets the first input to the adder,
		}

		adder.b[0].set(true);
		// Need to add 1 to the least significant bit
		for (int i = 1; i < 32; i++) {
			adder.b[i].set(false);
			// This for loop sets up a 32 bit number with the least
			// Significant bit flippedd to 1
		}

		adder.execute();
		// Execute the add
		for (int i = 0; i < 32; i++) {
			out[i].set(adder.sum[i].get());
			// Adding the sum to our final output
		}
	}

	// you shouldn't change these standard variables...
	public RussWire[] in;
	public RussWire[] out;

	private Sim1_NOT[] notGates;
	// I need 32 NOT gates

    private Sim1_ADD adder;

	public Sim1_2sComplement()
	{
		in = new RussWire[32];
        out = new RussWire[32];
        
        for (int i = 0; i < 32; i++) {
            in[i] = new RussWire();
            out[i] = new RussWire();
        }

		notGates = new Sim1_NOT[32];
        for (int i = 0; i < 32; i++) {
            notGates[i] = new Sim1_NOT();
        }
        
        adder = new Sim1_ADD();
	}
}

