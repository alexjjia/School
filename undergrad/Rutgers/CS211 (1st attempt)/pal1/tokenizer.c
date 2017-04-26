/*
 * tokenizer.c
 */
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
/*
 * Tokenizer type.  You need to fill in the type as part of your implementation.
 */

typedef enum token_type_							//gives the token a 'type', which tells me what state to put it in.
	{octalnum, decimalnum, floatnum, hexnum, badinput, whitespace, nulltype} type;
struct TokenizerT_ {
	char* currchar;
	int index;
	type tokentype;
};

typedef struct TokenizerT_ TokenizerT;//makes a TokenizerT_ struct named TokenizerT.
/*
 * TKCreate creates a new TokenizerT object for a given token stream
 * (given as a string).
 * 
 * TKCreate should copy the arguments so that it is not dependent on
 * them staying immutable after returning.  (In the future, this may change
 * to increase efficiency.)
 *
 * If the function succeeds, it returns a non-NULL TokenizerT.
 * Else it returns NULL.
 *
 */

TokenizerT *TKCreate( char * ts ) {
	TokenizerT* tempTokenizer = (TokenizerT*) malloc(sizeof(TokenizerT)); //Mallocs a temporary TokenizerT so that I can get generate an arbitrary 										       amount of space for whatever the user will be inputting.
	tempTokenizer->currchar = (char*)malloc((strlen(ts)+1)*sizeof(char));	//malloc's the char pointer that represents the user's input.
	strcpy(tempTokenizer->currchar, ts);
	tempTokenizer->index = 0;
	tempTokenizer->currchar[strlen(ts)] = '\0';					//gives the input array a default EOF value. 
	tempTokenizer->tokentype = nulltype;					//base case 'type' for the token; others include hex, oct, etc.
	return tempTokenizer;							//will return null otherwise.
}
/*
 * TKDestroy destroys a TokenizerT object.  It should free all dynamically
 * allocated memory that is part of the object being destroyed.
 *
 */

void TKDestroy( TokenizerT * tk ) {
	free(tk->currchar);
	free(tk);
}


/*
 * state_octal(int, TokenizerT*) traverses to the end of the octal string, or returns a bad input.
 * state_hex(int, TokenizerT*) traverses to the end of the hexidecimal string, or retuns a bad input.
 * state_float(int, TokenizerT*) traverses to the end of the float string, or returns a bad input.
 * */
int state_octal(int index, TokenizerT* tk)					//keeps going until it encounters a non-digit, non-octal character.
{
	if(isdigit(tk->currchar[index]))
	{
		if(tk->currchar[index] != '8' && tk->currchar[index] != '9')
		{
			return state_octal(index+1, tk);
		}
		else
		{
			tk->tokentype = badinput;
			return index;
		}
	}
	else
	{
			
			return index;
	}
}

int state_hex(int index, TokenizerT* tk)					//keeps going until it finds something that isn't 0-9,a-f, A-F.
{
	if(isxdigit(tk->currchar[index]))					//isxdigit(int) tells me if the character is a hexidecimal or not.
	{
		return state_hex(index+1, tk);
	}
	else
	{
		return index;
	}
}
int state_float(int index, TokenizerT* tk)					//prereq: previous character was a '+' or '-' sign.
{
	if(isdigit(tk->currchar[index]))
	{
		return state_float(index+1, tk);
	}
	else
	{
		tk->tokentype = floatnum;
		return index;
	}

}

/*Finite State Automata starts here.
 *state_1(int, TokenizerT*) determines if the token is a octal/hex/0/bad input.
 *state_2(int, TokenizerT)* determines if the token is a decimal/float/bad input. 
 *state_3(int, TokenizerT*) is that transitory state which figures out if the token is a decimal, or a float (that starts with a leading 0.).
 *state_3_f(int, TokenizerT*) simply determines if a '+' or '-' sign has been applied after the exponent for a potential float integer.
 *state_init(int, TokenizerT*) determines if the input is a number, or something else (which is a bad input anyways).
 * */

int state_3_f(int index, TokenizerT* tk)					//prereq: previous character was an exponent 'E' or 'e'.
{
	if(tk->currchar[index] == '+' || tk->currchar[index] == '-')		//simply checks if a positive or negative sign is added.
	{
		return state_float(index+1, tk);				//proceeds to ensure a legitimate float integer exists here.
	}
	else
	{
		tk->tokentype = badinput;
		return index;
	}			
}

int state_3(int index, TokenizerT* tk)						//prereq: previous character was a '.' 
{										//Is this token a float or a decimal? Time to find out.
	if(isdigit(tk->currchar[index]))					//keeps going until either the entire token is traversed, or bad input.
	{
		return state_3(index+1, tk);
	}
	else if(tk->currchar[index] == 'e' || tk->currchar[index] == 'E')	//time to check for a float.
	{
		return state_3_f(index+1, tk);
	}
	else if((isdigit(tk->currchar[index]) != 0))				//not an exponent sign, or a digit? must be a bad input.
	{
		tk->tokentype = badinput;
		return index;
	}
	else									//reached the end of the token without any hitch? It's a float.
	{
		tk->tokentype = floatnum;
		return index;
	}	
}

int state_2(int index, TokenizerT* tk)						//prereq: first character was a digit from 1 to 9.
{
	if(isdigit(tk->currchar[index]))					//keeps going until a non digit, or end of token occurs.
	{
		return state_2(index+1, tk);
	}
	else if(tk->currchar[index] == 'e' || tk->currchar[index] == 'E')	//check for float.
	{
		return state_3_f(index+1, tk);
	}
	else if(tk->currchar[index] == '.')					//check with state_3 to ensure a decimal or float.
	{
		return state_3(index+1, tk);
	}
	else									//it's definitely a decimal integer.
	{
		tk->tokentype = decimalnum;
		return index;
	}
}


int state_1(int index, TokenizerT* tk)						//prereq: first character was a '0'.
{
	if(tk->currchar[index] != '8' && tk->currchar[index] != '9')		//Now it's either an octal, a hex, or a bad input.
	{
		if(tk->currchar[index] == 'X' || tk ->currchar[index] == 'x')	//Now it's a hexadecimal, or a bad input.
		{
			tk->tokentype = hexnum;
			return state_hex(index+1, tk);
		}
		else if(tk->currchar[index] == '.')				//Check with state_3 to be specify either a decimal or a float.
		{
			return state_3(index+1, tk);
		}
		else								//Now it's an octal; a digit 0-7.
		{		
			tk->tokentype = octalnum;
			return state_octal(index+1, tk); 
		}			 	
	}
	else								//if a non octal digit, it's considered a bad input (see tokenizer.pdf)
	{								
	tk->tokentype = badinput;
	return index+1;
	}
}

int state_init(int index, TokenizerT* tk)
{
		if(isdigit(tk->currchar[index]))
		{
			if(tk->currchar[index] == '0')				//begin checking if it's a octal/hex/decimal/float
			{
				return state_1(index+1, tk);
			}
			else							//numbers 1-9 mean either an integer, float, decimal or badinput.
			{
				return state_2(index+1, tk);
			}
		}
		if(isspace(tk->currchar[index]))				//essentially ignores all ' ', '\t', '\v', '\n', '\r', and '\f'.
		{
			return state_init(index+1, tk);
		}
		else
		{
			return index+1;
		}
}
/*
 * TKGetNextToken returns the next token from the token stream as a
 * character string.  Space for the returned token should be dynamically
 * allocated.  The caller is responsible for freeing the space once it is
 * no longer needed.
 *
 * If the function succeeds, it returns a C string (delimited by '\0')
 * containing the token.  Else it returns 0.
 */

char *TKGetNextToken( TokenizerT * tk ) {
	if(tk->currchar[tk->index] != '\0')
	{
		char* token = (char*)malloc((strlen(tk->currchar)+1)*sizeof(char));	//generates a token for me to get separate values for.
		int currindex = state_init(tk->index, tk);				//tells us where we are in the original string.
		if(currindex <0)							//takes care of bad inputs like '09'
		{
	//		currindex = tk->index+1;
		}
		currindex = currindex - tk->index;					//updates currindex.
		strncpy(token, tk->currchar+tk->index, currindex);			//copies the main string up to the next token, onto token.
		tk->index += currindex;							//updates index.
		token[currindex] = '\0';						//resets the token for the next call (see main func)
		return token;	
	}
	else										//flag for reaching the end of the string.
	{
		return 0;
	}
}

/*
 * main will have a string argument (in argv[1]).
 * The string argument contains the tokens.
 * Print out the tokens in the second string in left-to-right order.
 * Each token should be printed on a separate line.
 */

int main(int argc, char **argv)
{
	TokenizerT* str = TKCreate(argv[1]);
	char* token = (char*)malloc((strlen(str->currchar)+1)*sizeof(char));
	while(1)										//Runs until it reaches the end of the input.
	{	
		token = TKGetNextToken(str);
		if(token ==0)
		{	break;	}
		switch(str->tokentype)								//Individual cases for each 'type', accompanied
		{										//with a nice printf.
			case octalnum:
			{
				printf("\noctal %s\n", token);
				break;
			}
			case hexnum:
			{
				printf("\nhexadecimal %s\n", token);
				break;
			}
			case decimalnum:
			{
				printf("\ndecimal %s\n", token);
				break;
			}
			case floatnum:
			{
				printf("\nfloat %s\n", token);
				break;
			}
			default:
			{
				printf("\nbad input [0x%02x]\n ", token);
				break;
			}
		}
	}

	free(token);
	TKDestroy(str);
 	
	return 0;
}
