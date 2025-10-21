/* Testcase for Sim2.
 *
 * Author: Russ Lewis
 *
 * This testcase simply connects to all of the student classes; it exists to
 * sanity-check that the types of all of the inputs/outputs are correct.
 */

public class Test_00_checkFields_sim2
{
	public static void main(String[] args)
	{
		Sim2_HalfAdder  ha   = new Sim2_HalfAdder();
		Sim2_FullAdder  fa   = new Sim2_FullAdder();

		Sim2_AdderX     adderX = new Sim2_AdderX(4);

		/* we just just check the various fields - just to see
		 * if they exist.  This is *NOT* a logical test of any
		 * of the functionality!
		 */

		ha.a.set(false);
		ha.b.set(false);
		ha.execute();
		System.out.printf("HALF ADDER: %s %s -> %s %s\n",
		                  ha.a.get(), ha.b.get(), ha.sum.get(), ha.carryOut.get());

		fa.a      .set(false);
		fa.b      .set(false);
		fa.carryIn.set(false);
		fa.execute();
		System.out.printf("FULL ADDER: %s %s %s -> %s %s\n",
		                  fa.a.get(), fa.b.get(), fa.carryIn.get(),
		                  fa.sum.get(), fa.carryOut.get());

		adderX.a[3].set(false);
		adderX.a[2].set(true);
		adderX.a[1].set(true);
		adderX.a[0].set(false);
		adderX.b[3].set(true);
		adderX.b[2].set(true);
		adderX.b[1].set(true);
		adderX.b[0].set(false);
		adderX.execute();
		System.out.printf("AdderX(4): a=0110 b=1110 -> sum=%d%d%d%d : %s %s\n",
		                  adderX.sum[3].get() ? 1:0,
		                  adderX.sum[2].get() ? 1:0,
		                  adderX.sum[1].get() ? 1:0,
		                  adderX.sum[0].get() ? 1:0,
		                  adderX.carryOut.get(),
		                  adderX.overflow.get());
	}
}

