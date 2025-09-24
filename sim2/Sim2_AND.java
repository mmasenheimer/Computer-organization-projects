/* Simulates a physical AND gate.
 *
 * Author: Michael Masenheimer
 */

public class Sim2_AND
{
	public void execute()
	{
		out.set(a.get() && b.get());
		// Set whatever the a bit and the b bit is after &&

	}

	public RussWire a,b;   // inputs
	public RussWire out;   // output

	public Sim2_AND()
	{
		a   = new RussWire();
		b   = new RussWire();

		out = new RussWire();

	}

}