/*---------------------------------------------------------------------------
  --      main.c                                                    	   --
  --      Christine Chen                                                   --
  --      Ref. DE2-115 Demonstrations by Terasic Technologies Inc.         --
  --      Fall 2014                                                        --
  --                                                                       --
  --      For use with ECE 298 Experiment 7                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <io.h>
#include <fcntl.h>

#include "system.h"
#include "alt_types.h"
#include <unistd.h>  // usleep 
#include "sys/alt_irq.h"
#include "io_handler.h"

#include "cy7c67200.h"
#include "usb.h"
#include "lcp_cmd.h"
#include "lcp_data.h"

#include "velocity.h"
#include <math.h>

#include <time.h>
#include <stdlib.h>


//----------------------------------------------------------------------------------------//
//
//                                Main function
//
//----------------------------------------------------------------------------------------//

void generateMoon(short *moon);
void generateStars(short *starsx, short *starsy, short *moon);
short detectCollision(double x, double y, float rotation, short *moon, double speedsquared);
void setFuel(short fuel);
void setAltitude(double xpos, double ypos, short *moon);
void setScore(short score);

volatile unsigned int * AES_PTR = (unsigned int *) 0x00000040;
double xvelocity=0, yvelocity=0;
//volatile unsigned char * keycode_base123 = KEYCODE_BASE;

//volatile unsigned char *keycode_base = KEYCODE_CODE;
// 1 - x ship position(top 16), y ship position(bottom 16)
// 0 - x ship velocity (bytewise decimal form)
// 2 - y ship velocity (bytewise decimal form)
// 12 - Score (bytewise decimal form)
// 3 - Fuel (bytewise decimal form)
// 4 - serial level drawing
// 5 - serial ship sprite
// 6 - game state - 0 = title screen, 1 - playing, 2 - crashwait, 3 - landwait, 4 - end game wait
// 7 - map heightlevel setter
// 8 - map heightlevel address (0-639, 640 means do not set)
// 9 - rotation
// 10 - thrust// 1 = yes, 0 = no
// 11 - altitude - y distance to moon in bytewise decimal
// 13 - stars iterator
// 14 - stars x
// 15 - stars y


int main(void)
{
	IO_init();

	/*while(1)
	{
		IO_write(HPI_MAILBOX,COMM_EXEC_INT);
		printf("[ERROR]:routine mailbox data is %x\n",IO_read(HPI_MAILBOX));
		//UsbWrite(0xc008,0x000f);
		//UsbRead(0xc008);
		usleep(10*10000);
	}*/

	unsigned char keycode_base123[6];

	alt_u16 intStat;
	alt_u16 usb_ctl_val;
	static alt_u16 ctl_reg = 0;
	static alt_u16 no_device = 0;
	alt_u16 fs_device = 0;
	int keycode = 0;
	alt_u8 toggle = 0;
	alt_u8 data_size;
	alt_u8 hot_plug_count;
	alt_u16 code;

	printf("USB keyboard setup...\n\n");

	//----------------------------------------SIE1 initial---------------------------------------------------//
	USB_HOT_PLUG:
	UsbSoftReset();

	// STEP 1a:
	UsbWrite (HPI_SIE1_MSG_ADR, 0);
	UsbWrite (HOST1_STAT_REG, 0xFFFF);

	/* Set HUSB_pEOT time */
	UsbWrite(HUSB_pEOT, 600); // adjust the according to your USB device speed

	usb_ctl_val = SOFEOP1_TO_CPU_EN | RESUME1_TO_HPI_EN;// | SOFEOP1_TO_HPI_EN;
	UsbWrite(HPI_IRQ_ROUTING_REG, usb_ctl_val);

	intStat = A_CHG_IRQ_EN | SOF_EOP_IRQ_EN ;
	UsbWrite(HOST1_IRQ_EN_REG, intStat);
	// STEP 1a end

	// STEP 1b begin
	UsbWrite(COMM_R0,0x0000);//reset time
	UsbWrite(COMM_R1,0x0000);  //port number
	UsbWrite(COMM_R2,0x0000);  //r1
	UsbWrite(COMM_R3,0x0000);  //r1
	UsbWrite(COMM_R4,0x0000);  //r1
	UsbWrite(COMM_R5,0x0000);  //r1
	UsbWrite(COMM_R6,0x0000);  //r1
	UsbWrite(COMM_R7,0x0000);  //r1
	UsbWrite(COMM_R8,0x0000);  //r1
	UsbWrite(COMM_R9,0x0000);  //r1
	UsbWrite(COMM_R10,0x0000);  //r1
	UsbWrite(COMM_R11,0x0000);  //r1
	UsbWrite(COMM_R12,0x0000);  //r1
	UsbWrite(COMM_R13,0x0000);  //r1
	UsbWrite(COMM_INT_NUM,HUSB_SIE1_INIT_INT); //HUSB_SIE1_INIT_INT
	IO_write(HPI_MAILBOX,COMM_EXEC_INT);

	while (!(IO_read(HPI_STATUS) & 0xFFFF) )  //read sie1 msg register
	{
	}
	while (IO_read(HPI_MAILBOX) != COMM_ACK)
	{
		printf("[ERROR]:routine mailbox data is %x\n",IO_read(HPI_MAILBOX));
		goto USB_HOT_PLUG;
	}
	// STEP 1b end

	printf("STEP 1 Complete");
	// STEP 2 begin
	UsbWrite(COMM_INT_NUM,HUSB_RESET_INT); //husb reset
	UsbWrite(COMM_R0,0x003c);//reset time
	UsbWrite(COMM_R1,0x0000);  //port number
	UsbWrite(COMM_R2,0x0000);  //r1
	UsbWrite(COMM_R3,0x0000);  //r1
	UsbWrite(COMM_R4,0x0000);  //r1
	UsbWrite(COMM_R5,0x0000);  //r1
	UsbWrite(COMM_R6,0x0000);  //r1
	UsbWrite(COMM_R7,0x0000);  //r1
	UsbWrite(COMM_R8,0x0000);  //r1
	UsbWrite(COMM_R9,0x0000);  //r1
	UsbWrite(COMM_R10,0x0000);  //r1
	UsbWrite(COMM_R11,0x0000);  //r1
	UsbWrite(COMM_R12,0x0000);  //r1
	UsbWrite(COMM_R13,0x0000);  //r1

	IO_write(HPI_MAILBOX,COMM_EXEC_INT);

	while (IO_read(HPI_MAILBOX) != COMM_ACK)
	{
		printf("[ERROR]:routine mailbox data is %x\n",IO_read(HPI_MAILBOX));
		goto USB_HOT_PLUG;
	}
	// STEP 2 end

	ctl_reg = USB1_CTL_REG;
	no_device = (A_DP_STAT | A_DM_STAT);
	fs_device = A_DP_STAT;
	usb_ctl_val = UsbRead(ctl_reg);

	if (!(usb_ctl_val & no_device))
	{
		for(hot_plug_count = 0 ; hot_plug_count < 5 ; hot_plug_count++)
		{
			usleep(5*1000);
			usb_ctl_val = UsbRead(ctl_reg);
			if(usb_ctl_val & no_device) break;
		}
		if(!(usb_ctl_val & no_device))
		{
			printf("\n[INFO]: no device is present in SIE1!\n");
			printf("[INFO]: please insert a USB keyboard in SIE1!\n");
			while (!(usb_ctl_val & no_device))
			{
				usb_ctl_val = UsbRead(ctl_reg);
				if(usb_ctl_val & no_device)
					goto USB_HOT_PLUG;

				usleep(2000);
			}
		}
	}
	else
	{
		/* check for low speed or full speed by reading D+ and D- lines */
		if (usb_ctl_val & fs_device)
		{
			printf("[INFO]: full speed device\n");
		}
		else
		{
			printf("[INFO]: low speed device\n");
		}
	}



	// STEP 3 begin
	//------------------------------------------------------set address -----------------------------------------------------------------
	UsbSetAddress();

	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
	{
		UsbSetAddress();
		usleep(10*1000);
	}

	UsbWaitTDListDone();

	IO_write(HPI_ADDR,0x0506); // i
	printf("[ENUM PROCESS]:step 3 TD Status Byte is %x\n",IO_read(HPI_DATA));

	IO_write(HPI_ADDR,0x0508); // n
	usb_ctl_val = IO_read(HPI_DATA);
	printf("[ENUM PROCESS]:step 3 TD Control Byte is %x\n",usb_ctl_val);
	while (usb_ctl_val != 0x03) // retries occurred
	{
		usb_ctl_val = UsbGetRetryCnt();

		goto USB_HOT_PLUG;
	}

	printf("------------[ENUM PROCESS]:set address done!---------------\n");

	// STEP 4 begin
	//-------------------------------get device descriptor-1 -----------------------------------//
	// TASK: Call the appropriate function for this step.
	UsbGetDeviceDesc1(); 	// Get Device Descriptor -1

	//usleep(10*1000);
	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
	{
		// TASK: Call the appropriate function again if it wasn't processed successfully.
		UsbGetDeviceDesc1();
		usleep(10*1000);
	}

	UsbWaitTDListDone();

	IO_write(HPI_ADDR,0x0506);
	printf("[ENUM PROCESS]:step 4 TD Status Byte is %x\n",IO_read(HPI_DATA));

	IO_write(HPI_ADDR,0x0508);
	usb_ctl_val = IO_read(HPI_DATA);
	printf("[ENUM PROCESS]:step 4 TD Control Byte is %x\n",usb_ctl_val);
	while (usb_ctl_val != 0x03)
	{
		usb_ctl_val = UsbGetRetryCnt();
	}

	printf("---------------[ENUM PROCESS]:get device descriptor-1 done!-----------------\n");


	//--------------------------------get device descriptor-2---------------------------------------------//
	//get device descriptor
	// TASK: Call the appropriate function for this step.
	UsbGetDeviceDesc2(); 	// Get Device Descriptor -2

	//if no message
	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
	{
		//resend the get device descriptor
		//get device descriptor
		// TASK: Call the appropriate function again if it wasn't processed successfully.
		UsbGetDeviceDesc2();
		usleep(10*1000);
	}

	UsbWaitTDListDone();

	IO_write(HPI_ADDR,0x0506);
	printf("[ENUM PROCESS]:step 4 TD Status Byte is %x\n",IO_read(HPI_DATA));

	IO_write(HPI_ADDR,0x0508);
	usb_ctl_val = IO_read(HPI_DATA);
	printf("[ENUM PROCESS]:step 4 TD Control Byte is %x\n",usb_ctl_val);
	while (usb_ctl_val != 0x03)
	{
		usb_ctl_val = UsbGetRetryCnt();
	}

	printf("------------[ENUM PROCESS]:get device descriptor-2 done!--------------\n");


	// STEP 5 begin
	//-----------------------------------get configuration descriptor -1 ----------------------------------//
	// TASK: Call the appropriate function for this step.
	UsbGetConfigDesc1(); 	// Get Configuration Descriptor -1

	//if no message
	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
	{
		//resend the get device descriptor
		//get device descriptor

		// TASK: Call the appropriate function again if it wasn't processed successfully.
		UsbGetConfigDesc1();
		usleep(10*1000);
	}

	UsbWaitTDListDone();

	IO_write(HPI_ADDR,0x0506);
	printf("[ENUM PROCESS]:step 5 TD Status Byte is %x\n",IO_read(HPI_DATA));

	IO_write(HPI_ADDR,0x0508);
	usb_ctl_val = IO_read(HPI_DATA);
	printf("[ENUM PROCESS]:step 5 TD Control Byte is %x\n",usb_ctl_val);
	while (usb_ctl_val != 0x03)
	{
		usb_ctl_val = UsbGetRetryCnt();
	}
	printf("------------[ENUM PROCESS]:get configuration descriptor-1 pass------------\n");

	// STEP 6 begin
	//-----------------------------------get configuration descriptor-2------------------------------------//
	//get device descriptor
	// TASK: Call the appropriate function for this step.
	UsbGetConfigDesc2(); 	// Get Configuration Descriptor -2

	usleep(100*1000);
	//if no message
	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
	{
		// TASK: Call the appropriate function again if it wasn't processed successfully.
		UsbGetConfigDesc2();
		usleep(10*1000);
	}

	UsbWaitTDListDone();

	IO_write(HPI_ADDR,0x0506);
	printf("[ENUM PROCESS]:step 6 TD Status Byte is %x\n",IO_read(HPI_DATA));

	IO_write(HPI_ADDR,0x0508);
	usb_ctl_val = IO_read(HPI_DATA);
	printf("[ENUM PROCESS]:step 6 TD Control Byte is %x\n",usb_ctl_val);
	while (usb_ctl_val != 0x03)
	{
		usb_ctl_val = UsbGetRetryCnt();
	}


	printf("-----------[ENUM PROCESS]:get configuration descriptor-2 done!------------\n");


	// ---------------------------------get device info---------------------------------------------//

	// TASK: Write the address to read from the memory for byte 7 of the interface descriptor to HPI_ADDR.
	IO_write(HPI_ADDR,0x056c);
	code = IO_read(HPI_DATA);
	code = code & 0x003;
	printf("\ncode = %x\n", code);

	if (code == 0x01)
	{
		printf("\n[INFO]:check TD rec data7 \n[INFO]:Keyboard Detected!!!\n\n");
	}
	else
	{
		printf("\n[INFO]:Keyboard Not Detected!!! \n\n");
	}

	// TASK: Write the address to read from the memory for the endpoint descriptor to HPI_ADDR.

	IO_write(HPI_ADDR,0x0576);
	IO_write(HPI_DATA,0x073F);
	IO_write(HPI_DATA,0x8105);
	IO_write(HPI_DATA,0x0003);
	IO_write(HPI_DATA,0x0008);
	IO_write(HPI_DATA,0xAC0A);
	UsbWrite(HUSB_SIE1_pCurrentTDPtr,0x0576); //HUSB_SIE1_pCurrentTDPtr

	//data_size = (IO_read(HPI_DATA)>>8)&0x0ff;
	//data_size = 0x08;//(IO_read(HPI_DATA))&0x0ff;
	//UsbPrintMem();
	IO_write(HPI_ADDR,0x057c);
	data_size = (IO_read(HPI_DATA))&0x0ff;
	printf("[ENUM PROCESS]:data packet size is %d\n",data_size);
	// STEP 7 begin
	//------------------------------------set configuration -----------------------------------------//
	// TASK: Call the appropriate function for this step.
	UsbSetConfig();		// Set Configuration

	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
	{
		// TASK: Call the appropriate function again if it wasn't processed successfully.
		UsbSetConfig();		// Set Configuration
		usleep(10*1000);
	}

	UsbWaitTDListDone();

	IO_write(HPI_ADDR,0x0506);
	printf("[ENUM PROCESS]:step 7 TD Status Byte is %x\n",IO_read(HPI_DATA));

	IO_write(HPI_ADDR,0x0508);
	usb_ctl_val = IO_read(HPI_DATA);
	printf("[ENUM PROCESS]:step 7 TD Control Byte is %x\n",usb_ctl_val);
	while (usb_ctl_val != 0x03)
	{
		usb_ctl_val = UsbGetRetryCnt();
	}

	printf("------------[ENUM PROCESS]:set configuration done!-------------------\n");

	//----------------------------------------------class request out ------------------------------------------//
	// TASK: Call the appropriate function for this step.
	UsbClassRequest();

	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
	{
		// TASK: Call the appropriate function again if it wasn't processed successfully.
		UsbClassRequest();
		usleep(10*1000);
	}

	UsbWaitTDListDone();

	IO_write(HPI_ADDR,0x0506);
	printf("[ENUM PROCESS]:step 8 TD Status Byte is %x\n",IO_read(HPI_DATA));

	IO_write(HPI_ADDR,0x0508);
	usb_ctl_val = IO_read(HPI_DATA);
	printf("[ENUM PROCESS]:step 8 TD Control Byte is %x\n",usb_ctl_val);
	while (usb_ctl_val != 0x03)
	{
		usb_ctl_val = UsbGetRetryCnt();
	}


	printf("------------[ENUM PROCESS]:class request out done!-------------------\n");

	// STEP 8 begin
	//----------------------------------get descriptor(class 0x21 = HID) request out --------------------------------//
	// TASK: Call the appropriate function for this step.
	UsbGetHidDesc();

	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
	{
		// TASK: Call the appropriate function again if it wasn't processed successfully.
		UsbGetHidDesc();
		usleep(10*1000);
	}

	UsbWaitTDListDone();

	IO_write(HPI_ADDR,0x0506);
	printf("[ENUM PROCESS]:step 8 TD Status Byte is %x\n",IO_read(HPI_DATA));

	IO_write(HPI_ADDR,0x0508);
	usb_ctl_val = IO_read(HPI_DATA);
	printf("[ENUM PROCESS]:step 8 TD Control Byte is %x\n",usb_ctl_val);
	while (usb_ctl_val != 0x03)
	{
		usb_ctl_val = UsbGetRetryCnt();
	}

	printf("------------[ENUM PROCESS]:get descriptor (class 0x21) done!-------------------\n");

	// STEP 9 begin
	//-------------------------------get descriptor (class 0x22 = report)-------------------------------------------//
	// TASK: Call the appropriate function for this step.
	UsbGetReportDesc();
	//if no message
	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
	{
		// TASK: Call the appropriate function again if it wasn't processed successfully.
		UsbGetReportDesc();
		usleep(10*1000);
	}

	UsbWaitTDListDone();

	IO_write(HPI_ADDR,0x0506);
	printf("[ENUM PROCESS]: step 9 TD Status Byte is %x\n",IO_read(HPI_DATA));

	IO_write(HPI_ADDR,0x0508);
	usb_ctl_val = IO_read(HPI_DATA);
	printf("[ENUM PROCESS]: step 9 TD Control Byte is %x\n",usb_ctl_val);
	while (usb_ctl_val != 0x03)
	{
		usb_ctl_val = UsbGetRetryCnt();
	}

	printf("---------------[ENUM PROCESS]:get descriptor (class 0x22) done!----------------\n");

	printf("here1");

	//-----------------------------------get keycode value------------------------------------------------//
	usleep(10000);


	short gamestate = 0;
	AES_PTR[6]=0;

	short fuel = 1000;
	setFuel(fuel);

	short score = 0;

	float rotation = -90;
	float acceleration = 1.5;
	float gravity =.3;

	double xposition=200;
	double yposition=200;

	unsigned int gamecount = 0;
	float rotateamount = 4;

	for(unsigned i = 0; i <= 16; i++)
		AES_PTR[i]=0;
	//AES_PTR[6]=1;

	short moon[640];
	short starsx[30];
	short starsy[30];

	srand(2);
	generateMoon(&moon[0]);

	unsigned i;

	for(i=0; i < 640; i++)
	{
		AES_PTR[8]=i;
		AES_PTR[7]=moon[i];
	}
	AES_PTR[8]=640;

	generateStars(&starsx[0], &starsy[0], &moon[0]);

	for(i=0; i < 30; i++)
	{
		AES_PTR[13]=i;
		AES_PTR[14]=starsx[i];
		AES_PTR[15]=starsy[i];
	}
	AES_PTR[13]=30;

	while(1)
	{
		//updatePosition(xvelocity, yvelocity, (int *)AES_PTR);

		toggle++;
		IO_write(HPI_ADDR,0x0500); //the start address
		//data phase IN-1
		IO_write(HPI_DATA,0x051c); //500

		IO_write(HPI_DATA,0x000f & data_size);//2 data length

		IO_write(HPI_DATA,0x0291);//4 //endpoint 1
		if(toggle%2)
		{
			IO_write(HPI_DATA,0x0001);//6 //data 1
		}
		else
		{
			IO_write(HPI_DATA,0x0041);//6 //data 1
		}
		IO_write(HPI_DATA,0x0013);//8
		IO_write(HPI_DATA,0x0000);//a
		UsbWrite(HUSB_SIE1_pCurrentTDPtr,0x0500); //HUSB_SIE1_pCurrentTDPtr
		
		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
		{
			IO_write(HPI_ADDR,0x0500); //the start address
			//data phase IN-1
			IO_write(HPI_DATA,0x051c); //500

			IO_write(HPI_DATA,0x000f & data_size);//2 data length

			IO_write(HPI_DATA,0x0291);//4 //endpoint 1
			if(toggle%2)
			{
				IO_write(HPI_DATA,0x0001);//6 //data 1
			}
			else
			{
				IO_write(HPI_DATA,0x0041);//6 //data 1
			}
			IO_write(HPI_DATA,0x0013);//8
			IO_write(HPI_DATA,0x0000);//
			UsbWrite(HUSB_SIE1_pCurrentTDPtr,0x0500); //HUSB_SIE1_pCurrentTDPtr
			usleep(10*1000);
		}//end while

		usb_ctl_val = UsbWaitTDListDone();

		// The first two keycodes are stored in 0x051E. Other keycodes are in 
		// subsequent addresses.
		//printf("here2");


		keycode = UsbRead(0x051e);
		//printf("\nfirst two keycode values are %04x\n",keycode);
		// We only need the first keycode, which is at the lower byte of keycode.
		// Send the keycode to hardware via PIO.
		keycode_base123[2] = keycode & 0x00ff;
		keycode_base123[3] = (keycode & 0xff00)>>8;

		usleep(200);//usleep(5000);
		usb_ctl_val = UsbRead(ctl_reg);

		if(!(usb_ctl_val & no_device))
		{
			//USB hot plug routine
			for(hot_plug_count = 0 ; hot_plug_count < 7 ; hot_plug_count++)
			{
				usleep(5*1000);
				usb_ctl_val = UsbRead(ctl_reg);
				if(usb_ctl_val & no_device) break;
			}
			if(!(usb_ctl_val & no_device))
			{
				printf("\n[INFO]: the keyboard has been removed!!! \n");
				printf("[INFO]: please insert again!!! \n");
			}
		}

		//printf("here1");

		while (!(usb_ctl_val & no_device))
		{

			usb_ctl_val = UsbRead(ctl_reg);
			usleep(5*1000);
			usb_ctl_val = UsbRead(ctl_reg);
			usleep(5*1000);
			usb_ctl_val = UsbRead(ctl_reg);
			usleep(5*1000);

			if(usb_ctl_val & no_device)
				goto USB_HOT_PLUG;

			usleep(200);
		}

		//printf("here2");

		gamecount++;

		//AES_PTR[1]=0x50;

		if(gamecount==1)//GAME LOOP
		{

			if(gamestate==1)//playing game state
			{

				//printf("\nspeed x %d", xvelocity);
				//printf("\nspeed y %x", yvelocity);

				AES_PTR[10]=0;
				unsigned keyindex;
				for(keyindex = 2; keyindex < 4; keyindex++)
				{
					//printf("\nkeycode value index %d is %x\n", keyindex, keycode_base123[keyindex]);
					//printf("\nx speed = %d    y speed = %d", getXVelocity((int *)AES_PTR), getYVelocity((int *)AES_PTR));
					if(keycode_base123[keyindex] == 0x50)//right key
					{
						rotation-=rotateamount;
						if(rotation < -180) rotation = -180;
					}
					if(keycode_base123[keyindex] == 0x4f)//left key
					{
						rotation+=rotateamount;
						if(rotation > 0) rotation = 0;
					}
					if(keycode_base123[keyindex] == 0x52 && fuel != 0)//up key
					{
						AES_PTR[10]=1;
						fuel--;
						setFuel(fuel);

						//calculateNextVelocity(rotation, acceleration, &xvelocity, &yvelocity);

						calculateNextVelocity(rotation, acceleration, &xvelocity, &yvelocity);



						//printf("\nx vel = %x    y vel = %x", xvelocity, yvelocity);

						//setXVelocity(xvelocity, (int *)AES_PTR);
						//setYVelocity(yvelocity, (int *)AES_PTR);
					}
					/*if(keycode_base123[keyindex] == 0x51)//down key, reset
					{
						xposition=200;
						yposition=200;
						xvelocity=0;
						yvelocity=0;
						rotation=-90;
					}*/
				}

				yvelocity+=gravity;

				//if(yposition > 480) yposition-=480;//screen wrapping
				//if(yposition < 0) yposition+=480; //no more y screen wrapping

				if(xposition > 640) xposition-=640;
				if(xposition < 0) xposition+=640;

				updatePosition(&xposition, &yposition, xvelocity, yvelocity, (int *)AES_PTR);

				AES_PTR[9]=((int)rotation)*-1;
				//printf("%d rot\n", ((int)rotation)*-1);

				double speedsquared = xvelocity*xvelocity + yvelocity*yvelocity;

				short collision = detectCollision(xposition, yposition, rotation, &moon[0], speedsquared);

				if(collision == 1)//crashed
				{
					gamestate=2;
					AES_PTR[6]=2;
				}
				else if(collision >= 2)//landed
				{
					gamestate=3;
					AES_PTR[6]=3;

					score+=(collision-1)*100;
					setScore(score);
				}

				setXVelocity(xvelocity, (int *)AES_PTR);
				setYVelocity(yvelocity, (int *)AES_PTR);

				setAltitude(xposition, yposition, &moon[0]);

			}
			else if (gamestate==0)//title screen
			{
				unsigned keyindex;
				for(keyindex = 2; keyindex < 4; keyindex++)
					if(keycode_base123[keyindex] == 40)//enter
					{
						gamestate = 1;
						AES_PTR[6] = 1;

						fuel = 1000;
						setFuel(fuel);

						score = 0;
						setScore(score);

						for(int i = 0; i < 20000; i++);//wait

						xposition=200;
						yposition=100;
						xvelocity=30;
						yvelocity=0;
						rotation=0;
					}
			}
			else if(gamestate==2 || gamestate == 3)//crashwait
			{
				for(int i = 0; i < 50000; i++);//wait
				if(fuel==0)
				{
					gamestate=4;
					AES_PTR[6]=4;
				}
				else
				{
					fuel/=2;
					setFuel(fuel);

					gamestate=1;
					AES_PTR[6]=1;

					srand((int)xposition^(int)yposition);
					generateMoon(&moon[0]);

						unsigned i;

						for(i=0; i < 640; i++)
						{
							AES_PTR[8]=i;
							AES_PTR[7]=moon[i];
						}
						AES_PTR[8]=640;


						generateStars(&starsx[0], &starsy[0], &moon[0]);

							for(i=0; i < 30; i++)
							{
								AES_PTR[13]=i;
								AES_PTR[14]=starsx[i];
								AES_PTR[15]=starsy[i];
							}
							AES_PTR[13]=30;

					xposition=200;
					yposition=100;
					xvelocity=30;
					yvelocity=0;
					rotation=0;
				}

			}
			else if(gamestate==4)//end screen
			{




				for(int i = 0; i < 800000; i++);//wait
				gamestate=0;//back to title screen
				AES_PTR[6]=0;
				score=0;
				setScore(score);


			}

			/*yvelocity+=gravity;

			if(yposition > 480) yposition-=480;
			if(yposition < 0) yposition+=480;

			if(xposition > 640) xposition-=640;
			if(xposition < 0) xposition+=640;

			updatePosition(&xposition, &yposition, xvelocity, yvelocity, (int *)AES_PTR);*/



			gamecount=0;
		}





	}//end while

	return 0;
}

void generateMoon(short *moon)
{
	char done = 0;


		short lastheight=350, lastx=0;
		short lastslope=0;

		while(done==0)
		{
			printf("%d\n", lastx);


			char landingtype;

			short slope;
			short length;
			short landing = rand()%8;
			if(landing == 0 && lastslope!=0)
			{
				landingtype=rand()%4 + 1;
				if(landingtype==1)
				{
					length=30;
				}
				if(landingtype==2)
				{
					length=23;
				}
				if(landingtype==3)
				{
					length=18;
				}
				if(landingtype==4)
				{
					length=13;
				}
				slope=0;
			}
			else
			{

				do
				{
					slope += rand()%7 - 3;
					if(slope > 9)slope=-1;
					if(slope < -9)slope=1;
				} while(slope==0);


				length = rand()%8 + 4;


			}
			printf("slope %d\n", slope);
			printf("length %d\n", length);

			if(lastheight + (length+1)*slope < 280)
			{
				continue;
			}
			if(lastheight + (length+1)*slope > 470)
			{
				continue;
			}

			if(slope==0)lastheight--;

			int initlastx = lastx;
			printf("%d length", length);
			for(; lastx < initlastx+length; lastx++)
			{

				if(lastx==640)
				{
					done=1;
					break;
				}


				lastheight+=slope;
				moon[lastx]=lastheight;

				lastslope=slope;

				if(slope==0)
				{
					if(lastx==initlastx)
					{
						if(landingtype==1)moon[lastx]=moon[lastx]|0x1000;
						if(landingtype==2)moon[lastx]=moon[lastx]|0x2000;
						if(landingtype==3)moon[lastx]=moon[lastx]|0x3000;
						if(landingtype==4)moon[lastx]=moon[lastx]|0x4000;
					}

					moon[lastx]=moon[lastx]|0x0400;//neg1
				}


			}
			if(lastx==640)
			{
				done=1;
			}
		}
}

short detectCollision(double x, double y, float rotation, short *moon, double speedsquared)
{
	if(y < 0) return 1;

	short xhitboxwidth = 5;
	short yhitboxwidth = 5;

	float rotationleniency = 20;

	double maxspeedsquared = 2500;

	short i;
	for(i = (short)x - xhitboxwidth; i <= (short)x + xhitboxwidth; i++)
	{
		if(((moon[i]&0x03ff) >= (short)y - yhitboxwidth) && ((moon[i]&0x03ff) <= (short)y + yhitboxwidth))
		{
			if(((moon[i]&0x0400) == 0x0400) && (rotation >= -90-rotationleniency && rotation <= -90 + rotationleniency) && speedsquared < maxspeedsquared)
			{
				int j = i;
				while((moon[j]&0xf000) == 0)j--;
				j = moon[j]>>12;

				return j+1;
			}
			else
			{
				return 1;//crash
			}
		}
	}
	return 0;//no collision
}

void setFuel(short fuel)
{
	short thous = fuel/1000;
	fuel%=1000;

	short hund = fuel/100;
	fuel%=100;

	short tens = fuel/10;
	fuel%=10;

	AES_PTR[3]=(thous<<12)|(hund<<8)|(tens<<4)|fuel;

	//printf("%d\n", AES_PTR[3]);
}

void setAltitude(double xpos, double ypos, short *moon)
{
	short shxpos=(short)xpos;
	short shypos=(short)ypos;

	shypos = shypos-moon[shxpos];
	if(shypos < 0)shypos*=-1;

	shypos%=1000;

	short thous = shypos/1000;
	shypos%=1000;

		short hund = shypos/100;
		shypos%=100;

		short tens = shypos/10;
		shypos%=10;

		AES_PTR[11]=(thous<<12)|(hund<<8)|(tens<<4)|shypos;

		//printf("%d\n", AES_PTR[3]);
}

void setScore(short score)
{


	short thous = score/1000;
	score%=1000;

	short hund = score/100;
	score%=100;

	short tens = score/10;
	score%=10;

	AES_PTR[12]=(thous<<12)|(hund<<8)|(tens<<4)|score;
}

void generateStars(short *starsx, short *starsy, short *moon)
{
	int i;
	for(i = 0; i < 30; i++)
	{
		int x, y;

		x=rand()%640;

		do
		{
			y=rand()%480;
		}while(y+5 > (moon[x]&(0x03ff)));



		starsx[i]=x;
		starsy[i]=y;
	}
}

