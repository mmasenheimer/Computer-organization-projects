/* Simulates a physical AND gate.
 *
 * Author: Russ Lewis
 *
 * Unlike AND, which perform the logical calculation directly, this class uses
 * composition.  I provide it as an example for students, to see how to build
 * more complex pieces from simple elements.
 */

public class NAND_example
{
	public NAND_example()
	{
		a   = new RussWire();
		b   = new RussWire();

		out = new RussWire();

		and = new AND();
		not = new NOT();
	}

	// inputs
	public RussWire a,b;
	// outputs
	public RussWire out;

	// internal components
	public AND and;
	public NOT not;

	void execute()
	{
		// copy our inputs to the inputs of the AND gate
		and.a.set(a.get());
		and.b.set(b.get());

		// make the AND gate calculate the result
		and.execute();

		// copy the output from the AND gate to the input of
		// the NOT gate
		not.in.set(and.out.get());

		// execute the NOT gate
		not.execute();

		// copy the output bit
		out.set(not.out.get());
	}
}

