/*
 * velocity.h
 *
 *  Created on: Nov 13, 2018
 *      Author: Chris
 */

#ifndef VELOCITY_H_
#define VELOCITY_H_

void calculateNextVelocity(float rotation, float acceleration, double *xvel, double *yvel);

int getXVelocity(int * AES_PTR);
int getYVelocity(int * AES_PTR);

void setXVelocity(double xvel, int * AES_PTR);
void setYVelocity(double yvel, int * AES_PTR);

void updatePosition(double *xposition, double *yposition, double xvelocity, double yvelocity, int *AES_PTR);

#endif /* VELOCITY_H_ */
