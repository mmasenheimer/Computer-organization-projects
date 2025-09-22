/* Simulates a physical NOT gate.
 *
 * Author: Michael Maseneheimer
 */

public class Sim1_NOT
{
	public void execute()
	{
		out.set(!in.get());
		// Set whatever the in bit is after being negated
	}

	public RussWire in;    // input
	public RussWire out;   // output

	public Sim1_NOT()
	{
		in   = new RussWire();

		out = new RussWire();
	}
}

