
#include <stdio.h>
#include <memory.h>

#include "sim1.h"



void printf_binary(char *prefix, int val);

int main()
{
	// sanity check that the sizes of the types are correct
	if (sizeof(int) != 4)
		printf("ERROR: sizeof(int) is %d, but it ought to be 4!\n", (int)sizeof(int));


	Sim1Data data;
	  memset(&data, 0, sizeof(data));

	data.a =   23571113;
	data.b = 0x23571113;
	data.isSubtraction = 1;

	execute_add(&data);

	printf("Decimal:\n");
	printf("    %11d\n", data.a);
	printf("  - %11d\n", data.b);
	printf(" --------------\n");
	printf("    %11d\n", data.sum);
	printf("  aNonNeg=%d, bNonNeg=%d, sumNonNeg=%d\n", data.aNonNeg, data.bNonNeg, data.sumNonNeg);
	printf("  carryOut=%d\n", data.carryOut);
	printf("  overflow=%d\n", data.overflow);
	printf("\n");

	printf       ("Binary:\n");
	printf_binary("    ", data.a);
	printf_binary("  - ", data.b);
	printf       (" -------------------------------------------\n");
	printf_binary("    ", data.sum);

	return 0;
}

void printf_binary(char *prefix, int val)
{
	int i;

	printf("%s", prefix);

	for (i=31; i>=0; i--)
	{
		printf("%d", (val >> i) & 0x1);

		if (i%4 == 0 && i != 0)
			printf(" ");
	}

	printf("\n");
}

