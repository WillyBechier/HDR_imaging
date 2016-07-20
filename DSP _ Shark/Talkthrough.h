#ifndef  __Talkthrough_DEFINED
#define __Talkthrough_DEFINED

//--------------------------------------------------------------------------//
// Header files																//
//--------------------------------------------------------------------------//
#include <sys\exception.h>
#include <cdefBF533.h>
#include <fract.h>
#include <math.h>


//--------------------------------------------------------------------------//
// Symbolic constants														//
//--------------------------------------------------------------------------//
// addresses for Port A in Flash A
#define pFlashA_PortA_Dir	(volatile unsigned char *)0x20270006
#define pFlashA_PortA_Data	(volatile unsigned char *)0x20270004

// addresses for Port B in Flash A
#define pFlashA_PortB_Dir	(volatile unsigned char *)0x20270007
#define pFlashA_PortB_Data	(volatile unsigned char *)0x20270005

// names for codec registers, used for sCodec1836TxRegs[]
#define DAC_CONTROL_1		0x0000
#define DAC_CONTROL_2		0x1000
#define DAC_VOLUME_0		0x2000
#define DAC_VOLUME_1		0x3000
#define DAC_VOLUME_2		0x4000
#define DAC_VOLUME_3		0x5000
#define DAC_VOLUME_4		0x6000
#define DAC_VOLUME_5		0x7000
#define ADC_0_PEAK_LEVEL	0x8000
#define ADC_1_PEAK_LEVEL	0x9000
#define ADC_2_PEAK_LEVEL	0xA000
#define ADC_3_PEAK_LEVEL	0xB000
#define ADC_CONTROL_1		0xC000
#define ADC_CONTROL_2		0xD000
#define ADC_CONTROL_3		0xE000

// names for slots in ad1836 audio frame
#define INTERNAL_ADC_L0			0
#define INTERNAL_ADC_R0			2
#define INTERNAL_DAC_L0			0
#define INTERNAL_DAC_R0			2
#define INTERNAL_ADC_L1			1
#define INTERNAL_ADC_R1			3
#define INTERNAL_DAC_L1			1
#define INTERNAL_DAC_R1			3

// size of array sCodec1836TxRegs
#define CODEC_1836_REGS_LENGTH	11

// SPI transfer mode
#define TIMOD_DMA_TX 0x0003

// SPORT0 word length
#define SLEN_24	0x0017

// DMA flow mode
#define FLOW_1	0x1000


//--------------------------------------------------------------------------//
// Global variables															//
//--------------------------------------------------------------------------//

#define Size_acq  128
#define Nfiltre  10
#define Fs 48000


extern int iChannel0LeftIn;
extern int iChannel0RightIn;
extern int iChannel0LeftOut;
extern int iChannel0RightOut;
extern int iChannel1LeftIn;
extern int iChannel1RightIn;
extern int iChannel1LeftOut;
extern int iChannel1RightOut;
extern volatile short sCodec1836TxRegs[];
extern volatile int iRxBuffer1[];
extern volatile int iTxBuffer1[];

extern fract16 Big_Input[];																// Big buffer = 12 * Input_data[128]
extern fract16 input_data[];															// 128 points d'échantillons
extern fract16 output_data[];															// 128 points de signal de sortie
extern fract16 DelayFunction[];															// Fonction oscillante pour le delay
extern fract16 ShellFunction[];															// Fonction pour vibrato

extern volatile fract16 VectAB[];														// Coeff du filtre
extern volatile fract16 coeff_sinus[];													// 1660 points = 1 periode => 3Hz

extern int Fdelay;																		// Fdelay = 3Hz 
extern fract16 DelayMaxInv;																// DelayMax = 1440 echantillon => 1/1440 pour normaliser
extern fract16 w0;																		// w0 = pulsation du delay
extern int nDelay;																		// nDelay = [20ms 30ms]*Fs = [960 1440] 
extern fract16 DelaySpan;																// DelaySpan = 30-20 = 10ms
extern fract16 DelayMean;																// DelayMean = (30-20)/2 = 25 ms
extern fract16 Delayed_Input[];															// Valeur du signal en retard
extern fract16 GainChorus;	
extern fract16 GainMain;																// Gain de chorus <1 



extern unsigned char willy;																// Position LED
extern int Switcher;																	//
extern int offset;																		//
extern int offseter;																	// 
extern int Toff;																		// Position dans le triangle ( 0 / 8000 \ 16000 )
extern int G;
extern fract16 Gain[];																	//


//--------------------------------------------------------------------------//
// 						In file : Initialise								//
//--------------------------------------------------------------------------//

void Init_EBIU(void);
void Init_Flash(void);
void Init_Flags(void);
void Init1836(void);
void Init_Sport0(void);
void Init_DMA(void);
void Init_Interrupts(void);
void Enable_DMA_Sport(void);
void Enable_DMA_Sport0(void);
void Init_Timers(void);

//--------------------------------------------------------------------------//
//					In File : Process_Data : all functions					//
//--------------------------------------------------------------------------//
void Process_Data(void);
extern void Identity_Function(void);
extern void Filter_Function(void);
extern void Filter_Function2(void);
extern void Chorus_Function(void);
extern void Flanger_Triangle_Function(void);
extern void Flanger_Parabole_Function(void);

//--------------------------------------------------------------------------//
//						In File : ISR : all interrupt						//
//--------------------------------------------------------------------------//

EX_INTERRUPT_HANDLER(Sport0_RX_ISR);
EX_INTERRUPT_HANDLER(FlagA_ISR);
EX_INTERRUPT_HANDLER(FlagB_ISR);
EX_INTERRUPT_HANDLER(Timer0_ISR);

#endif //__Talkthrough_DEFINED
