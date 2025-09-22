/* Simulates a physical device that performs (signed) addition on
 * a 32-bit input.
 *
 * Author: Michael Masenheimer
 */

public class Sim1_ADD
{
	public void execute()
	// evaluation of two array inups of RussWires
	{

		boolean carryIn = false;
		// Init carryIn which constitutes if there is a number to be carried over
		
		for (int i = 0; i < 32; i++) {
			// Looping through all of the bits
	
			boolean bitA = a[i].get();
			boolean bitB = b[i].get();
			// Grab each of the individual bits

			boolean sumBits = bitA ^ bitB ^ carryIn;
			// Using XOR for both the bits and carry in which determiness the sum of the individual column
			sum[i].set(sumBits);

			boolean newCarry = (bitA && bitB) || (carryIn && (bitA ^ bitB));
			// This determines 

			carryIn = newCarry;
			// This is a flag for if there is carry over into the next column

		}
		carryOut.set(carryIn);
		// Will be true if there exists a carry over bit more than the most significant bit

		boolean aSign = a[31].get();
		boolean bSign = b[31].get(); 
		boolean sumSign = sum[31].get();
		// Adder arrays

		boolean overflowCondition = (aSign == bSign) && (aSign != sumSign);
		// Calculating all of the possible conditions involved in an overflow case
		overflow.set(overflowCondition);
	}

	// ------ 
	// It should not be necessary to change anything below this line,
	// although I'm not making a formal requirement that you cannot.
	// ------ 

	// inputs
	public RussWire[] a,b;
	// RussWire a, b represents an array of RussWire objects

	// outputs
	public RussWire[] sum;
	public RussWire   carryOut, overflow;

	public Sim1_ADD()
	{
		/* Instructor's Note:
		 *
		 * In Java, to allocate an array of objects, you need two
		 * steps: you first allocate the array (which is full of null
		 * references), and then a loop which allocates a whole bunch
		 * of individual objects (one at a time), and stores those
		 * objects into the slots of the array.
		 */

		a   = new RussWire[32];
		b   = new RussWire[32];
		sum = new RussWire[32];

		for (int i=0; i<32; i++)
		{
			a  [i] = new RussWire();
			b  [i] = new RussWire();
			sum[i] = new RussWire();
		}

		carryOut = new RussWire();
		overflow = new RussWire();
	}
}

