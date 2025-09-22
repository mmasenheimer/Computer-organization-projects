/* Simulates a physical OR gate.
 *
 * Author: Michael Masenheimer
 */

public class Sim1_OR
{
	public void execute()
	{
		out.set(a.get() || b.get());
		// Set theout bit to whatever a OR b is
	}

	public RussWire a,b;   // inputs
	public RussWire out;   // output

	public Sim1_OR()
	{
		a   = new RussWire();
		b   = new RussWire();

		out = new RussWire();
	}
}

