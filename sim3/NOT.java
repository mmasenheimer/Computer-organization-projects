/* Simulates a physical NOT gate.
 *
 * Author: Russ Lewis
 */

public class NOT
{
	public void execute()
	{
		out.set( ! in.get());
	}


	// inputs
	public RussWire in;
	// outputs
	public RussWire out;


	public NOT()
	{
		// the constructor for an object has to create all of the
		// RussWire objects to represent the inputs and outputs
		// of the object.
		in  = new RussWire();
		out = new RussWire();
	}
}

