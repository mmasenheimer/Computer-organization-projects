/* Simulates a physical XOR gate, but does so through composition
 * (breaking it down into NOT/AND/OR gates).
 *
 * Author: Russell Lewis
 */

public class XOR
{
	public void execute()
	{
		/* ----- IMPORTANT NOTE 1: -----
		 *
		 * Notice that I created all of the sub-components inside the
		 * constructor.  This represents that there are physical
		 * transistors, making up the actual circuitry of this device.
		 * When we make one of these devices, we get all of the little
		 * sub-pieces.
		 *
		 * execute() represents a SINGLE CLOCK TICK, and so you MUST
		 * NOT create any AND/OR/NOT gates here.  That would be like
		 * creating new hardware, out of nothing, over and over as the
		 * computer runs.
		 */


		/* the first step is to copy the XOR inputs into their
		 * respective inputs.
		 */
		not_a.in.set(a.get());
		not_b.in.set(b.get());

		/* we now execute both of the NOT gates.  Each one should
		 * write a value to their output.
		 */
		not_a.execute();
		not_b.execute();


		/* ----- IMPORTANT NOTE 2: -----
		 *
		 * We need to perform NOT twice in this component - since XOR
		 * uses the NOT value of each of the inputs a,b.  But we MUST
		 * NOT use the same object twice!  Instead, we use two
		 * different NOT objects.
		 *
		 * In a program, this is of course a silly design.  But
		 * remember that we are trying to simulate hardware here - and
		 * each component (such as a NOT gate) can only generate one
		 * result per clock tick.  So if we want to negate two different
		 * signals for the same calculation, we need two differnt gates.
		 */


		/* we now connect various wires to each AND gate.  Each AND
		 * checks for "this value is true, the other is false"; it does
		 * this by doing the AND of one of the inputs, and the NOT of
		 * the other.
		 *
		 * Note that it's perfectly OK to connect the same input to
		 * two different devices - we just run wires to two different
		 * physical places.
		 */
		and1.a.set(a.get());
		and1.b.set(not_b.out.get());

		and2.a.set(not_a.out.get());
		and2.b.set(b.get());

		/* we execute the two AND gates *AFTER* their inputs are
		 * in place.
		 */
		and1.execute();
		and2.execute();


		/* the value of XOR is "this and not that, or not this and that" -
		 * or, more formally,
		 *      (A and ~B) or (~A and B)
		 * So our last step is to OR the result of the two AND gates
		 * together.  Its output is the output from our XOR gate.
		 */
		or.a.set(and1.out.get());
		or.b.set(and2.out.get());
		or.execute();
		out.set(or.out.get());
	}



	public RussWire a,b;   // inputs
	public RussWire out;   // output

	private NOT not_a, not_b;
	private AND and1, and2;
	private OR  or;

	public XOR()
	{
		a   = new RussWire();
		b   = new RussWire();
		out = new RussWire();

		not_a = new NOT();
		not_b = new NOT();

		and1 = new AND();
		and2 = new AND();

		or = new OR();
	}
}

