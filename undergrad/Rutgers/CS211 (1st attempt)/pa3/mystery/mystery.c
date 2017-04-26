#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int add(int num)
{
return 0;
}

int dothething(int num)
{
	if(num == 0)
	{
		return 0;
	}
	if(num == 1 || num == 2)
	{
		return 1;
	}	
	else
	{
		return (dothething(num)+ dothething(num-1));

	}
}

int main(int argc, char* argv[])
{
	int num = atoi(argv[1]);
	if(atoi(argv[1]) >=0)
	{
		printf("%d\n", dothething(num));
	}
	else
	{
		fprintf(stderr, "Error. Invalid input.");
	}
	return 0;
}
