/*
 * velocity.c
 *
 *  Created on: Nov 13, 2018
 *      Author: Chris
 */
#include "velocity.h"
#include "system.h"
//#include "main.c"
#include <math.h>


#define PI 3.14159265

void calculateNextVelocity(float rotation, float acceleration, double *xvel, double *yvel)
{
	double radRotation = (PI/180.0)*((double)rotation);
	double tempx = *xvel;
	double tempy = *yvel;
	*xvel = tempx + ((double)acceleration)*cos(radRotation);
	*yvel = tempy + ((double)acceleration)*sin(radRotation);
	//*yvel = (*yvel) + gravity;
}

int getXVelocity(int * AES_PTR)
{
	int velocity = AES_PTR[0];
	velocity = velocity>>16;
	return velocity;
}
int getYVelocity(int * AES_PTR)
{
	int velocity = AES_PTR[0];
	velocity = velocity<<16;
	velocity = velocity>>16;

	return velocity;
}

void setXVelocity(double xvel, int * AES_PTR)//bytewise decimal
{


	short shortxvel = (int)xvel;

	int negative = 0;



	if(shortxvel < 0)
	{
		negative=1;
		shortxvel*=-1;
	}

	short thous = 0;
	if(negative)thous=10;

	shortxvel%=1000;

		short hund = shortxvel/100;
		shortxvel%=100;

		short tens = shortxvel/10;
		shortxvel%=10;

		AES_PTR[0]=(thous<<12)|(hund<<8)|(tens<<4)|shortxvel|(negative<<31);


}
void setYVelocity(double yvel, int * AES_PTR)//bytewise decimal
{

	short shortxvel = (int)yvel;

		int negative = 0;



		if(shortxvel < 0)
		{
			negative=1;
			shortxvel*=-1;
		}

		short thous = 0;
		if(negative)thous=10;
		shortxvel%=1000;

			short hund = shortxvel/100;
			shortxvel%=100;

			short tens = shortxvel/10;
			shortxvel%=10;

			AES_PTR[2]=(thous<<12)|(hund<<8)|(tens<<4)|shortxvel|(negative<<31);
}

void updatePosition(double *xposition, double *yposition, double xvelocity, double yvelocity, int *AES_PTR)
{
	//int xpos = AES_PTR[1]>>16;
	//int ypos = (AES_PTR[1]<<16)>>16;

	*xposition += xvelocity/50.0;
	*yposition += yvelocity/50.0;

	//AES_PTR[1]=AES_PTR[1]&0x0;
	int intxpos = (int)(*xposition);
	int intypos = (int)(*yposition);

	AES_PTR[1]=((intxpos)<<16)|((intypos)&0x0000ffff);
}



