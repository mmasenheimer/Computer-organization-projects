/* RussWire class
 *
 * Reprements a "wire" in the simulation.  It can only be set once - which
 * represents connecting that wire to some sort of "driver".  It can be read
 * many times (though only after it has been set).
 *
 * (If you attempt to read the value before it is set, it throws
 * IllegalArgumentException.)
 *
 * UPDATED: Added the 'clockTick()' feature, which is used for simulations
 *          which need to support multiple clock cycles.
 *
 * Author: Russell Lewis
 */

public class RussWire
{
	private boolean isSet;
	private boolean val;

	public void set(boolean val)
	{
		if (this.isSet)
			throw new IllegalArgumentException("A RussWire was set multiple times.");

		this.val   = val;
		this.isSet = true;
	}

	public boolean get()
	{
		if (this.isSet == false)
			throw new IllegalArgumentException("A RussWire was read before it had been set.");
		return this.val;
	}



	public String toString()
	{
		if (this.isSet == false)
			throw new IllegalArgumentException("A RussWire was read before it had been set.");

		if (this.get())
			return "true";
		else
			return "false";
	}


	public RussWire()
	{
		this.isSet = false;

		this.next = RussWire.globalList;
		RussWire.globalList = this;
	}
	public static void clockTick()
	{
		RussWire cur = globalList;
		while (cur != null)
		{
			cur.isSet = false;
			cur = cur.next;
		}
	}


	/* This exists to support the clockTick() functionality above; when
	 * a clock tick happens, we forget all of the values on all of the
	 * RussWire objects.  It's a global list of all RussWire's that were
	 * ever created.
	 *
	 * This global list, of course, means that it is IMPOSSIBLE to garbage
	 * collect any RussWire after it's been created.  This might be a
	 * problem in a more "official" system, but it's perfectly ok in 252
	 * Simulation projects, because in that case, the students are
	 * supposed to create these objects *ONCE* (when the various parts are
	 * created), and then never create anything again later.
	 */
	static RussWire globalList = null;
	RussWire next;
}

