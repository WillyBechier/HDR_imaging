//--------------------------------------------------------------------------//
//																			//
//	 Name: 	Talkthrough for the ADSP-BF533 EZ-KIT Lite						//
//																			//
//--------------------------------------------------------------------------//
//																			//
//	(C) Copyright 2006 - Analog Devices, Inc.  All rights reserved.			//
//																			//
//	Project Name:	BF533 C Talkthrough I2S									//
//																			//
//	Date Modified:	04/03/03		Rev 1.0							//
//																			//
//	Software:		VisualDSP++4.5											//
//																			//
//	Hardware:		ADSP-BF533 EZ-KIT Board									//
//																			//
//	Connections:	Connect RSCLK0 to TSCLK0 together (Turn SW9 pin 6 on)	//
//					Connect RFS0 to TFS0 together (Turn SW9 pin 5 ON)		//					Connect an input source (such as a radio) to the Audio	//
//					input jack and an output source (such as headphones) to //
//					the Audio output jack									//
//																			//
//	Purpose:		This program sets up the SPI port on the ADSP-BF533 to  //
//					configure the AD1836 codec.  The SPI port is disabled 	//
//					after initialization.  The data to/from the codec are 	//
//					transfered over SPORT0 in I2S mode						//
//																			//
//--------------------------------------------------------------------------//

#include "Talkthrough.h"
#include "sysreg.h"
#include "ccblkfn.h"


//--------------------------------------------------------------------------//
// Variables																//
//																			//
// Description:	The variables iChannelxLeftIn and iChannelxRightIn contain 	//
//				the data coming from the codec AD1836.  The (processed)		//
//				playback data are written into the variables 				//
//				iChannelxLeftOut and iChannelxRightOut respectively, which 	//
//				are then sent back to the codec in the SPORT0 ISR.  		//
//				The values in the array iCodec1836TxRegs can be modified to //
//				set up the codec in different configurations according to   //
//				the AD1885 data sheet.										//
//--------------------------------------------------------------------------//
// left input data from ad1836
int iChannel0LeftIn, iChannel1LeftIn;
// right input data from ad1836
int iChannel0RightIn, iChannel1RightIn;
// left ouput data for ad1836	
int iChannel0LeftOut, iChannel1LeftOut;
// right ouput data for ad1836
int iChannel0RightOut, iChannel1RightOut;
	short input_data[Size_acq];
	short output_data[Size_acq];


// array for registers to configure the ad1836
// names are defined in "Talkthrough.h"
volatile short sCodec1836TxRegs[CODEC_1836_REGS_LENGTH] =
{									
					DAC_CONTROL_1	| 0x000,
					DAC_CONTROL_2	| 0x000,
					DAC_VOLUME_0	| 0x3ff,
					DAC_VOLUME_1	| 0x3ff,
					DAC_VOLUME_2	| 0x3ff,
					DAC_VOLUME_3	| 0x3ff,
					DAC_VOLUME_4	| 0x000,
					DAC_VOLUME_5	| 0x000,
					ADC_CONTROL_1	| 0x000,
					ADC_CONTROL_2	| 0x000,
					ADC_CONTROL_3	| 0x000
					
};

// SPORT0 DMA transmit buffer
volatile int iTxBuffer1[4*4*Size_acq];
// SPORT0 DMA receive buffer
volatile int iRxBuffer1[4*4*Size_acq];

fract16 Big_Input[21*Size_acq];
fract16 input_data[Size_acq];
fract16 output_data[Size_acq];
fract16 Input[Size_acq];

int offseter;


int offset=0;
int offseter=0;
int G = 5;
unsigned char willy = 0x00;	
fract16 Gain[Nfiltre];
int Switcher;
int Fdelay=3;																		// Fdelay = 3Hz 
fract16 w0;																			// w0 = pulsation du delay
int nDelay;	
int Toff=0;

fract16 DelayFunction[Size_acq];													// nDelay = [20ms 30ms]*Fs = [960 1440] 
fract16 ShellFunction[Size_acq];
fract16 DelaySpan=0.005r16;															// DelaySpan = 30-20 = 10ms
fract16 DelayMean=0.025r16;
fract16 DelayMaxInv = 0.0006944444r16;												// DelayMean = (30-20)/2 = 25 ms
fract16 Delayed_Input[Size_acq];													// Valeur du signal en retard
fract16 GainMain=0.6r16;															// Gain de l'echo
fract16 GainChorus=0.3r16;															// Gain du principal ( GM + GC < 1 ) 


volatile fract16 VectAB[6*Nfiltre] = {	
	#include "CFnormalized.dat"
	};
	
//volatile fract16 coeff_sinus[125*Size_acq] = {
//	#include "CFsinus.dat"
//	};

//--------------------------------------------------------------------------//
// Function:	main														//
//																			//
// Description:	After calling a few initalization routines, main() just 	//
//				waits in a loop forever.  The code to process the incoming  //
//				data can be placed in the function Process_Data() in the 	//
//				file "Process_Data.c".										//
//--------------------------------------------------------------------------//
void main(void)
{


	sysreg_write(reg_SYSCFG, 0x32);		//Initialize System Configuration Register
	Init_EBIU();
	Init_Flash();
	Init1836();
	Init_Sport0();
	Init_DMA();
	Init_Interrupts();
	Init_Flags();
	Enable_DMA_Sport0();

		Init_Timers();

	while(1);
}
