#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#include "nCr.h"

int main(int argc, char *argv[])
{
	struct timeval begin, end; //start of the time stuff.
	gettimeofday(&begin, NULL);

	int i = 1;

	if(strcmp(argv[1], "-h") == 0) //manual thingy
	{
		printf("Usage: formula <positive integer>\n");
	}	
	else if(argv[1] == NULL || (atoi(argv[1]) < 0))
	{
		printf(stderr, "Bad input. Try again.\n");
	}
	else
	{		
		printf("(1 + x)^%d = ", atoi(argv[1])); //opening statement.
	
		if(strcmp(argv[1], "0") == 0) //if pow is 0, returns 1.
		{
			printf("1");
		}
		int pow = atoi(argv[1]); //my input value; i.e #, '-h', whatever.
	
		if (pow <34)
		{
					printf("1 + ");
			while(i <= pow)
			{
				if(i==pow)
				{
					printf("1x^%d\n",pow); //for the last term.
				}
				else
				{
					printf("%d*x^%d + ", nCr(pow,i), i); //all other terms. 
				}
				i++;
			}
		}
		else
		{
			printf("0");
		}
	}
	gettimeofday(&end, NULL); //end of the time stuff.
	int elapsed = (end.tv_usec - begin.tv_usec);	
	printf("Time Required = %d milliseconds.\n", elapsed);
	
	return 0;
}
