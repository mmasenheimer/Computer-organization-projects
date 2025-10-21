#ifndef _SIM1_H__INCLUDED_
#define _SIM1_H__INCLUDED_


/* Defines the prototype for execute_add(), along with the data structure used
 * as its parameter.
 *
 * Author: Russ Lewis
 */


typedef struct Sim1Data
{
	// inputs
	int a,b;
	int isSubtraction;

	// primary output
	int sum;

	// output flags
	int aNonNeg, bNonNeg, sumNonNeg;
	int carryOut, overflow;
} Sim1Data;


void execute_add(Sim1Data *obj);


#endif

