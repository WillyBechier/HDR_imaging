#include "Talkthrough.h"

//--------------------------------------------------------------------------//
// Function:	Sport0_RX_ISR												//
//																			//
// Description: This ISR is executed after a complete frame of input data 	//
//				has been received. The new samples are stored in 			//
//				iChannel0LeftIn, iChannel0RightIn, iChannel1LeftIn and 		//
//				iChannel1RightIn respectively.  Then the function 			//
//				Process_Data() is called in which user code can be executed.//
//				After that the processed values are copied from the 		//
//				variables iChannel0LeftOut, iChannel0RightOut, 				//
//				iChannel1LeftOut and iChannel1RightOut into the dma 		//
//				transmit buffer.											//
//--------------------------------------------------------------------------//
EX_INTERRUPT_HANDLER(Sport0_RX_ISR)
{
	// confirm interrupt handling
	*pDMA1_IRQ_STATUS = 0x0001;


	
	// call function that contains user code
	Process_Data();				


}

EX_INTERRUPT_HANDLER(FlagA_ISR)		
{
	*pFIO_FLAG_C = 0x0100;
	G=G+ 1;
}

EX_INTERRUPT_HANDLER(FlagB_ISR)
{
	*pFIO_FLAG_C = 0x0200;
	G=G-1;
}

EX_INTERRUPT_HANDLER(Timer0_ISR)
{
	*pTIMER_STATUS=0x0001;
	
	if (willy >= 0x00)
	{	
		willy=0x01;
	}
	else 
	{	
		willy=0x00;
	}
	
	*pFlashA_PortB_Data = willy;
}
