/* Simulates a physical OR gate.
 *
 * Author: Russ Lewis
 */

public class OR
{
	public void execute()
	{
		boolean a_val = a.get();
		boolean b_val = b.get();
		out.set(a_val | b_val);
	}


	// inputs
	public RussWire a,b;
	// outputs
	public RussWire out;


	public OR()
	{
		a   = new RussWire();
		b   = new RussWire();
		out = new RussWire();
	}
}

