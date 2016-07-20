#include "Talkthrough.h"

//--------------------------------------------------------------------------//
// Function:	Init_EBIU													//
//																			//
// Description:	This function initializes and enables asynchronous memory 	//
//				banks in External Bus Interface Unit so that Flash A can be //
//				accessed.													//
//--------------------------------------------------------------------------//
void Init_EBIU(void)
{
	*pEBIU_AMBCTL0	= 0x7bb07bb0;
	*pEBIU_AMBCTL1	= 0x7bb07bb0;
	*pEBIU_AMGCTL	= 0x000f;
}  

//--------------------------------------------------------------------------//
// Function:	Init_Flash													//
//																			//
// Description:	This function initializes pin direction of Port A in Flash A//
//				to output.  The AD1836_RESET on the ADSP-BF533 EZ-KIT board //
//				is connected to Port A.										//
//--------------------------------------------------------------------------//
void Init_Flash(void)
{
	*pFlashA_PortA_Dir = 0x1;

}

//--------------------------------------------------------------------------//
// Function:	Init1836()													//
//																			//
// Description:	This function sets up the SPI port to configure the AD1836. //
//				The content of the array sCodec1836TxRegs is sent to the 	//
//				codec.														//
//--------------------------------------------------------------------------//
void Init1836(void)
{
	int i;
	int j;
	static unsigned char ucActive_LED = 0x01;
	
	// write to Port A to reset AD1836
	*pFlashA_PortA_Data = 0x00;
	
	// write to Port A to enable AD1836
	*pFlashA_PortA_Data = ucActive_LED;
	
	// wait to recover from reset
	for (i=0; i<0xf0000; i++) asm("nop;");

	// Enable PF4
	*pSPI_FLG = FLS4;
	// Set baud rate SCK = HCLK/(2*SPIBAUD) SCK = 2MHz	
	*pSPI_BAUD = 16;
	// configure spi port
	// SPI DMA write, 16-bit data, MSB first, SPI Master
	*pSPI_CTL = TIMOD_DMA_TX | SIZE | MSTR;
	
	// Set up DMA5 to transmit
	// Map DMA5 to SPI
	*pDMA5_PERIPHERAL_MAP	= 0x5000;
	
	// Configure DMA5
	// 16-bit transfers
	*pDMA5_CONFIG = WDSIZE_16;
	// Start address of data buffer
	*pDMA5_START_ADDR = (void *)sCodec1836TxRegs;
	// DMA inner loop count
	*pDMA5_X_COUNT = CODEC_1836_REGS_LENGTH;
	// Inner loop address increment
	*pDMA5_X_MODIFY = 2;
	
	// enable DMAs
	*pDMA5_CONFIG = (*pDMA5_CONFIG | DMAEN);
	// enable spi
	*pSPI_CTL = (*pSPI_CTL | SPE);
	
	// wait until dma transfers for spi are finished 
	for (j=0; j<0xaff0; j++) asm("nop;");
	
	// disable spi
	*pSPI_CTL = 0x0000;
}


//--------------------------------------------------------------------------//
// Function:	Init_Sport0													//
//																			//
// Description:	Configure Sport0 for I2S mode, to transmit/receive data 	//
//				to/from the AD1836. Configure Sport for external clocks and //
//				frame syncs.												//
//--------------------------------------------------------------------------//
void Init_Sport0(void)
{
	// Sport0 receive configuration
	// External CLK, External Frame sync, MSB first, Active Low
	// 24-bit data, Stereo frame sync enable
	*pSPORT0_RCR1 = RFSR | RCKFE;
	*pSPORT0_RCR2 = SLEN_24 | RXSE | RSFSE;
	
	// Sport0 transmit configuration
	// External CLK, External Frame sync, MSB first, Active Low
	// 24-bit data, Secondary side enable, Stereo frame sync enable
	*pSPORT0_TCR1 = TFSR | TCKFE;
	*pSPORT0_TCR2 = SLEN_24 | TXSE | TSFSE;
}

//--------------------------------------------------------------------------//
// Function:	Init_DMA													//
//																			//
// Description:	Initialize DMA1 in autobuffer mode to receive and DMA2 in	//
//				autobuffer mode to transmit									//
//--------------------------------------------------------------------------//
void Init_DMA(void)
{
	// Set up DMA1 to receive
	// Map DMA1 to Sport0 RX
	*pDMA1_PERIPHERAL_MAP = 0x1000;
	
	// Configure DMA1
	// 32-bit transfers, Interrupt on completion, Autobuffer mode
	*pDMA1_CONFIG = WDSIZE_32 | DI_EN | FLOW_AUTO | WNR | DMA2D | DI_SEL;	// 32 bits | data interrupt | autobuffer | DMA2D
	// Start address of data buffer
	*pDMA1_START_ADDR = (void *)iRxBuffer1;
	// DMA inner loop count
	*pDMA1_X_COUNT = 4*Size_acq;					// nombre de canaux
	// Inner loop address increment
	*pDMA1_X_MODIFY = 4;							// échantillons dans 1 seul canal
	// DMA inner loop count
	*pDMA1_Y_COUNT = 4;								// nombre de lignes
	// Inner loop address increment
	*pDMA1_Y_MODIFY = 4;							// nombre de lignes
		
	
	// Set up DMA2 to transmit
	// Map DMA2 to Sport0 TX
	*pDMA2_PERIPHERAL_MAP = 0x2000;
		// Configure DMA2
	// 32-bit transfers, Autobuffer mode
	*pDMA2_CONFIG = WDSIZE_32 | FLOW_AUTO |DI_EN | DMA2D |  DI_SEL;
	// Start address of data bufferD
	*pDMA2_START_ADDR = (void *)iTxBuffer1;
	// DMA inner loop count
	*pDMA2_X_COUNT = 4*Size_acq;
	// Inner loop address increment
	*pDMA2_X_MODIFY = 4;
	
	// DMA inner loop count
	*pDMA2_Y_COUNT = 4;								// nombre de lignes
	// Inner loop address increment
	*pDMA2_Y_MODIFY = 4;							// nombre de lignes
}

//--------------------------------------------------------------------------//
// Function:	Enable_DMA_Sport											//
//																			//
// Description:	Enable DMA1, DMA2, Sport0 TX and Sport0 RX					//
//--------------------------------------------------------------------------//
void Enable_DMA_Sport0(void)
{
	// enable DMAs
	*pDMA2_CONFIG	= (*pDMA2_CONFIG | DMAEN);
	*pDMA1_CONFIG	= (*pDMA1_CONFIG | DMAEN);
	
	// enable Sport0 TX and RX
	*pSPORT0_TCR1 	= (*pSPORT0_TCR1 | TSPEN);
	*pSPORT0_RCR1 	= (*pSPORT0_RCR1 | RSPEN);
}

//--------------------------------------------------------------------------//
// Function:	Init_Interrupts												//
//																			//
// Description:	Initialize Interrupt for Sport0 RX							//
//--------------------------------------------------------------------------//
void Init_Interrupts(void)
{
	// Set Sport0 RX (DMA1) interrupt priority to 2 = IVG9 
	*pSIC_IAR0 = 0xffffffff;
	*pSIC_IAR1 = 0xffffff2f;
	*pSIC_IAR2 = 0xfff43ff5;

	// assign ISRs to interrupt vectors
	// Sport0 RX ISR -> IVG 9
	register_handler(ik_ivg9, Sport0_RX_ISR);
		// interup A
	register_handler(ik_ivg10, FlagA_ISR);
	
	// interup B
	register_handler(ik_ivg11, FlagB_ISR);

	// interup timer
	register_handler(ik_ivg12,Timer0_ISR);

	// enable interrupt
	*pSIC_IMASK = 0x00190200; //1->FB 8->FA 2->Sport0 1->TIMER0

}

void Init_Flags(void)
{
	*pFIO_INEN=0x0300;
	*pFIO_DIR=0x0000;
	*pFIO_EDGE=0x0300;
	*pFIO_MASKA_D=0x0100;	// PF8 pour A
	*pFIO_MASKB_D=0x0200;	// PF9 pour B	

}

void Init_Timers(void)
{
	*pTIMER0_CONFIG=0x0019;		//
	*pTIMER0_PERIOD=0x0080000;
	*pTIMER0_WIDTH=0x00400000;
	*pTIMER_ENABLE=0x0001;
	

}
