/*
 *********************************************
 *  314 Principles of Programming Languages  *
 *  Spring 2017                              *
 *  Author: Ulrich Kremer                    *
 *  Student Version                          *
 *********************************************
 */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "InstrUtils.h"
#include "Utils.h"


typedef struct list_node {
	int regNum;
	int isSet; //1 is true, 0 is false. Only applies for the offset.
	struct list_node *next;
} node;

static void addToList(node *list, int num)
{
	while(list->next != NULL)
	{
		list = list->next;
	}
	list->next = (node*)malloc(sizeof(node));
	list = list->next;
	list->regNum = num;
	list->next = NULL;
}
static void addToOffset(node *list, int num)
{
	while(list->next != NULL)
	{
		list = list->next;
	}
	list->next = (node*)malloc(sizeof(node));
	list = list->next;
	list->regNum = num;
	list->next = NULL;
}
static void setOffset(node *list, int key, int num)
{
	while(list != NULL)
	{
		if(list->regNum = key){
			list->isSet = num;
		}
		list=list->next;
	}
}
//returns 1 if true, 0 if false.
static int listContains(node *list, int num)
{
	while(list != NULL)
	{
		if(list->regNum == num)
		{
			return 1;
		}
		list = list->next;
	}
	return 0; //will only run if num is not found.
}
static int getOffset(node *list, int key)
{
	while(list != NULL)
	{
		if(list->regNum = key)
		{
			return list->isSet;
		}
		list=list->next;
	}
}
static void printAll(node *list)
{
	//list=list->next;
	while(list!=NULL)
	{
		printf("list: %d\n", list->regNum);
		list = list->next;
	}
}
//actual optimization algorithm is here.
static void optimize(Instruction *head, int offset)
{
	node *crit_reg = (node*)malloc(sizeof(node)); //initialize a LL that contains our important register numbers.
	node *offset_list = (node*)malloc(sizeof(node));
	addToOffset(offset_list, offset); //for the initial offset.
	head = head->prev; //to offset the fact that current head had an OUTPUTAI, and thus critical = 1.	
	while(head!= NULL)
	{	
		if(head->critical != 1) {
			//do the actual case checking.
			switch(head->opcode) {
			
			case STOREAI:

				if(listContains(offset_list, head->field3) == 1/* && getOffset(offset_list, head->field3) == 0*/)
				{
					head->critical = 1;	
					addToList(crit_reg, head->field1);
				} 
			break;
		
			case MUL:
			
				if(listContains(crit_reg, head->field3) == 1)
				{
					head->critical = 1;
					addToList(crit_reg, head->field1);
					addToList(crit_reg, head->field2);
				}
			break;
		
			case DIV:

				if(listContains(crit_reg, head->field3) == 1)
				{
					head->critical = 1;
					addToList(crit_reg, head->field1);
					addToList(crit_reg, head->field2);
				}
			break;
		
			case ADD:

				if(listContains(crit_reg, head->field3) == 1)
				{
					head->critical = 1;
					addToList(crit_reg, head->field1);
					addToList(crit_reg, head->field2);
				}
			break;
	
			case SUB:

				if(listContains(crit_reg, head->field3) == 1)
				{
					head->critical = 1;
					addToList(crit_reg, head->field1);
					addToList(crit_reg, head->field2);
				}
			break;

			case LOADAI:

				if(listContains(crit_reg, head->field3) == 1)
				{
					head->critical = 1;
					addToOffset(offset_list, head->field2);
				}
			break;
			
			case LOADI:
				if(listContains(crit_reg, head->field2) == 1)
				{
					head->critical = 1;
				}
			break;
			
			default:
				break; //..I should've covered everything, so this should never run.
			}	
		}
//		printf("head info: field1 - %d field2 - %d field3 -%d crit - %d\n", head->field1, head->field2, head->field3, head->critical);
//					printAll(crit_reg);
//					printf("OFFSET ");
//					printAll(offset_list);
		head = head->prev;
	}
}

int main()
{
	//PROCEDURE:
	//	Loop through DLL.
	//		if(outputAI is encountered, make a temp copy of the head) {
	//				set offset var = head->field2
	//				call optimize(temp_head, offset)
	//		}
	//	head= head->next;
	//		
	Instruction *head, *real_head, *temp_head; 
	int offset;

	head = ReadInstructionList(stdin);
	if (!head) { //edge case NULL checker.
		WARNING("No instructions\n");
		exit(EXIT_FAILURE);
	}
	real_head->opcode= head->opcode; //need this to actually output my stuff.
	real_head->field1= head->field1;
	real_head->field2= head->field2;
	real_head->field3= head->field3;
	real_head->prev= head->prev;
	real_head->next= head->next;
	real_head->critical= head->critical;

	while(head!= NULL)
	{
		if(head->opcode == LOADI && head->field1 == 1024)
		{
			PrintInstruction(stdout, real_head);
		}
		else if(head->opcode == OUTPUTAI)
		{
			head->critical = 1;
			offset = head->field2;	
			temp_head = head;
			optimize(temp_head, offset); //begin the (albeit super-inefficient) backwards iteration!

		}
		

//	printf("head: , %d, %d, %d, %d\n", head->field1, head->field2, head->field3, head->critical);
		head = head->next;
	}
	if (real_head) //does the actual iteration here. 
		PrintInstructionList(stdout, real_head);
	
	return EXIT_SUCCESS;
}

