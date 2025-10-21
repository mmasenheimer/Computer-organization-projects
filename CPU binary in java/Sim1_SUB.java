/* Simulates a physical device that performs (signed) subtraction on
 * a 32-bit input.
 *
 * Author: Michael Masenheimer
 */

public class Sim1_SUB
// Subtract class for two arrays of RussWire objects
{
	public void execute()
	{
		
        for (int i = 0; i < 32; i++) {
            twosComp.in[i].set(b[i].get());
            // Take the 2s complement first
        }

        twosComp.execute();
        
        for (int i = 0; i < 32; i++) {
            adder.a[i].set(a[i].get()); 
            adder.b[i].set(twosComp.out[i].get()); 
            // Grab the original number (a)
            // Get the 2s complement of b, (negative b)
        }
        
        adder.execute();
        // a and (not b)
        
        for (int i = 0; i < 32; i++) {
            sum[i].set(adder.sum[i].get());
            // Copy the result into the final sum
		
		}
	
	}

	// --------------------
	// Don't change the following standard variables...
	// --------------------

	// inputs
	public RussWire[] a,b;

	// output
	public RussWire[] sum;

	private Sim1_2sComplement twosComp;
	// Convert b to negative b

    private Sim1_ADD adder;
	// Then we add: a and (-b)

	public Sim1_SUB()
	{
		a = new RussWire[32];
        b = new RussWire[32]; 
        sum = new RussWire[32];
        
        for (int i = 0; i < 32; i++) {
            a[i] = new RussWire();
            b[i] = new RussWire();
            sum[i] = new RussWire();
        }
    
        twosComp = new Sim1_2sComplement();
        adder = new Sim1_ADD();
		
	}
}