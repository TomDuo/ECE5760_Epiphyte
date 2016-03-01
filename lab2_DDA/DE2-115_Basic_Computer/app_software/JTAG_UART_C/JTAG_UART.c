#include <string.h>
#include <stdlib.h>
#include "../../BSP/system.h"
#include <stdio.h>
#include <math.h>
#include <float.h>
#include "floating_point.h"
#include <stdint.h>
#define FLOAT2_DDA_FIXED(t) (((int32_t)((t) *(65536.0)))  & 0x03FFFF)

/* function prototypes */
void put_jtag(volatile int *, char);

/********************************************************************************
 * This program demonstrates use of the JTAG UART port in the DE2 Basic Computer
 *
 * It performs the following: 
 *  	1. sends a text string to the JTAG UART
 * 	2. reads character data from the JTAG UART
 * 	3. echos the character data back to the JTAG UART
********************************************************************************/
volatile int * dda_ptr = (int *) DDA_OPTIONS_BASE;
int main(void)
{
	/* Declare volatile pointers to I/O registers (volatile means that IO load
	   and store instructions will be used to access these pointer locations, 
	   instead of regular memory loads and stores) */
	volatile int * JTAG_UART_ptr 	= (int *) 0x10001000;	// JTAG UART address
	char select_line = 0x0;

	volatile float tempFloat; //strtod returns a double
	uint32_t dataLine;

	int data, i, n;
	int k1, k2, k13, kmid, x1, v1, x2, v2;
	char command_index = 0;
	char text_string[] = "\nInput Spring-Mass System Parameters\n> \0";
	char * command_string;//[20];
	char go_string[] = "go:";
	char stop_string[] = "st:";
	char k1_string[] = "k1:";
	char k2_string[] = "k2:";
	char kmid_string[] = "km:";
	char k13_string[] = "k3:";
	char x1_string[] = "x1:";
	char v1_string[] = "v1:";
	char x2_string[] = "x2:";
	char v2_string[] = "v2:";
  	char* pEnd;

	command_string = malloc( sizeof(char)*20);
	/* print a text string */
	for (i = 0; text_string[i] != 0; ++i)
		put_jtag (JTAG_UART_ptr, text_string[i]);
	/* read and echo characters */
	while(1)
	{
		data = *(JTAG_UART_ptr);		 		// read the JTAG_UART data register
		if (data & 0x00008000)					// check RVALID to see if there is new data
		{
			data = data & 0x000000FF;			// the data is in the least significant byte
			/* echo the character */

			// Add the data to the current command string if not return
			if ((data != '\n') && (data != '\r') && (command_index <19))
			{
				command_string[command_index] = data;
				command_index++;
			}
			// clear the command string if there is a return
			else
			{
				command_string[command_index] = '\0';
				// check for a match on any of the special strings in the command string
				if (strstr(command_string,k1_string) == command_string)
				{

					printf("\nfound k1 match\n");
					tempFloat = atof(&command_string[3]); //strtod(&command_string[3],&pEnd);
					printf("completed strtod call\n");
					//sscanf(command_string,"%f", &tempFloat);
					select_line = 0x1;

				}
				
				else if (strstr(command_string,k2_string) == command_string)
				{
					tempFloat = strtod(command_string + 3,NULL);
					select_line = 0x2;
				}
				else if (strstr(command_string,k13_string) == command_string)
				{
					tempFloat = strtod(command_string + 3,NULL);
					select_line = 0x3;
				}

				else if (strstr(command_string,kmid_string) == command_string)
				{
					tempFloat = strtod(command_string + 3,NULL);
					select_line = 0x4;

				}
				else if (strstr(command_string,x1_string) == command_string)
				{
					tempFloat = strtod(command_string + 3,NULL);
					select_line = 0x5;
				}
				else if (strstr(command_string,v1_string) == command_string)
				{
					tempFloat = strtod(command_string + 3,NULL);
				select_line = 0x6;
				}
				else if (strstr(command_string,x2_string) == command_string)
				{
					tempFloat = strtod(command_string + 3,NULL);
					select_line = 0x7;
				}
				else if (strstr(command_string,v2_string) == command_string)
				{
					tempFloat = strtod(command_string + 3,NULL);
					select_line = 0x8;
				}
				else if (strstr(command_string,go_string) == command_string)
				{
					select_line = 0x9;
				}
				else if (strstr(command_string,stop_string) == command_string)
				{
					select_line = 0xA;
				}
				else
				{
					//select_line = 0x0;
				}
				printf("about to convert to fixed\n");
				dataLine = FLOAT2_DDA_FIXED(tempFloat);
				// after reading a value, zero the index and clear the command string
				//printf("tempFloat = %f\ndataLine = ",tempFloat);
				*(dda_ptr)= (dataLine << 4) | select_line;
				command_index = 0;
				printf("converted to fixed and sent to ports\ndataLine = ");

				// print out the value sent to ports on JTAG
				for (n=17;n>=0;n--){
					if (dataLine & (1<<n))
					{
						printf("1");
					}
					else
					{
						printf("0");
					}
					if (n==16) {printf("_");}
					if (n==12) {printf(" ");}
					if (n==8) {printf(" ");}
					if (n==4) {printf(" ");}
				}
				printf("\nPort output displayed above\n");
				
				// zero the command string
				for (n=0;n<20;n++){
					command_string[n] = '\0';
				}
			}

			put_jtag (JTAG_UART_ptr, (char) data & 0xFF );
		}
	}
}

/********************************************************************************
 * Subroutine to send a character to the JTAG UART
********************************************************************************/
void put_jtag( volatile int * JTAG_UART_ptr, char c )
{
	int control;
	control = *(JTAG_UART_ptr + 1);			// read the JTAG_UART control register
	if (control & 0xFFFF0000)					// if space, then echo character, else ignore 
		*(JTAG_UART_ptr) = c;
}
