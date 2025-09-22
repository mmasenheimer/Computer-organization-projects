/* Testcase for 252 Sim 1.
 *
 * Author: Russ Lewis
 */

public class Test_03_ADD
{
	public static void main(String[] args)
	{
		Sim1_ADD p = new Sim1_ADD();

		p.a[ 0].set(true);
		p.a[ 1].set(true);
		p.a[ 2].set(true);
		p.a[ 3].set(true);
		p.a[ 4].set(false);
		p.a[ 5].set(false);
		p.a[ 6].set(true);
		p.a[ 7].set(true);
		p.a[ 8].set(true);
		p.a[ 9].set(false);
		p.a[10].set(true);
		p.a[11].set(false);
		p.a[12].set(false);
		p.a[13].set(false);
		p.a[14].set(false);
		p.a[15].set(false);
		p.a[16].set(true);
		p.a[17].set(false);
		p.a[18].set(false);
		p.a[19].set(true);
		p.a[20].set(false);
		p.a[21].set(false);
		p.a[22].set(false);
		p.a[23].set(false);
		p.a[24].set(false);
		p.a[25].set(false);
		p.a[26].set(false);
		p.a[27].set(false);
		p.a[28].set(false);
		p.a[29].set(false);
		p.a[30].set(false);
		p.a[31].set(true);

		p.b[ 0].set(false);
		p.b[ 1].set(false);
		p.b[ 2].set(true);
		p.b[ 3].set(true);
		p.b[ 4].set(false);
		p.b[ 5].set(true);
		p.b[ 6].set(false);
		p.b[ 7].set(true);
		p.b[ 8].set(false);
		p.b[ 9].set(false);
		p.b[10].set(false);
		p.b[11].set(true);
		p.b[12].set(false);
		p.b[13].set(true);
		p.b[14].set(false);
		p.b[15].set(false);
		p.b[16].set(false);
		p.b[17].set(true);
		p.b[18].set(false);
		p.b[19].set(true);
		p.b[20].set(false);
		p.b[21].set(false);
		p.b[22].set(false);
		p.b[23].set(true);
		p.b[24].set(false);
		p.b[25].set(false);
		p.b[26].set(false);
		p.b[27].set(false);
		p.b[28].set(false);
		p.b[29].set(true);
		p.b[30].set(false);
		p.b[31].set(true);

		p.execute();

		System.out.printf("  ");
		print_bits(p.a);
		System.out.print("\n");

		System.out.printf("+ ");
		print_bits(p.b);
		System.out.printf("\n");

		System.out.printf("----------------------------------\n");

		System.out.printf("  ");
		print_bits(p.sum);
		System.out.printf("\n");


		System.out.printf("\n");
		System.out.printf("  carryOut = %c\n", bit(p.carryOut.get()));

		System.out.printf("  overflow = %c\n", bit(p.overflow.get()));
	}

	public static void print_bits(RussWire[] bits)
	{
		for (int i=31; i>=0; i--)
		{
			if (bits[i].get())
				System.out.print("1");
			else
				System.out.print("0");
		}
	}

	public static char bit(boolean b)
	{
		if (b)
			return '1';
		else
			return '0';
	}
}

