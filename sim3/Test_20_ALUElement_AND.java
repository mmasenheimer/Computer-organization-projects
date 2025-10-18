/* Tester class for the ALU Element: tests the AND operation.  As with the
 * MUX tester classes, we'll define a helper function in the first class,
 * which is then used in several variants, to reduce duplication.
 *
 * Author: Russ Lewis
 */

public class Test_20_ALUElement_AND
{
	public static void main(String[] args)
	{
		test(0, false);
	}

	public static void test(int op, boolean bInvert)
	{
		/* we pre-create all of the objects that we'll need, in order
		 * to (hopefully) detect global variables if present.
		 *
		 * We will test all possible combinations of the input and
		 * carryIn, and less, but each testcase only does it for a
		 * single operation.
		 *
		 * Note that we'll set the LESS inputs arbitrarily (testing
		 * all possible combinations); we don't have any *real*
		 * mechanism for copying the LESS operation around.
		 */
		Sim3_ALUElement[] elems = new Sim3_ALUElement[16];
		for (int i=0; i<elems.length; i++)
			elems[i] = new Sim3_ALUElement();

		boolean c0 = ( op       & 0x1) == 1;
		boolean c1 = ((op >> 1) & 0x1) == 1;
		boolean c2 = ((op >> 2) & 0x1) == 1;

		/* the 4th bit is used for LESS; so element i has the same
		 * inputs (a,b,carryIn) as i+8
		 */

		for (int i=0; i<8; i++)
		{
			elems[ i ].aluOp[0].set(c0);
			elems[ i ].aluOp[1].set(c1);
			elems[ i ].aluOp[2].set(c2);
			elems[ i ].bInvert.set(bInvert);

			elems[i+8].aluOp[0].set(c0);
			elems[i+8].aluOp[1].set(c1);
			elems[i+8].aluOp[2].set(c2);
			elems[i+8].bInvert.set(bInvert);

			boolean    a    = ( i       & 0x1) == 1;
			boolean    b    = ((i >> 1) & 0x1) == 1;
			boolean carryIn = ((i >> 2) & 0x1) == 1;

			elems[ i ].   a   .set(   a   );
			elems[ i ].   b   .set(   b   );
			elems[ i ].carryIn.set(carryIn);

			elems[i+8].   a   .set(   a   );
			elems[i+8].   b   .set(   b   );
			elems[i+8].carryIn.set(carryIn);
		}

		/* execute all of the MUXes.  Do they all stay independent? */
		for (int i=0; i<elems.length; i++)
			elems[i].execute_pass1();

		/* set all of the less values, then run pass2() */
		for (int i=0; i<8; i++)
		{
			elems[ i ].less.set(false);
			elems[i+8].less.set(true);
		}

		for (int i=0; i<elems.length; i++)
			elems[i].execute_pass2();

		/* finally, dump state.  We'll try to avoid lots of long lines;
		 * we'll print out just enough information to make sure that the
		 * output is working.
		 */
		for (int i=0; i<elems.length; i++)
		{
			System.out.printf("%d (carry,addResult %d%d)\n",
			                  elems[i]. result  .get() ? 1:0,
			                  elems[i].carryOut .get() ? 1:0,
			                  elems[i].addResult.get() ? 1:0);
		}
	}
}