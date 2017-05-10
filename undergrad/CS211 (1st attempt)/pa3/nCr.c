#include<stdio.h>


int Factorial(int n)
{
	if(n > 33)
	{
		return 0;
	}
	int sum = 1;
	int i = n;

	while(i>0)
	{
		sum*= i;
		i--;
	}
	return sum;
}

int nCr(int n, int r)
{
	int ans;
	if(r>n)
	{
	return 0;
	}
	ans = Factorial(n) / (Factorial(r)*Factorial(n-r));
	
	return ans;
}
