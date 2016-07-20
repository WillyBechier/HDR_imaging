#include "Talkthrough.h"

//--------------------------------------------------------------------------//
// Function:	Flanger_Parabole_Function()				    				//
// Delay variable : Parabolique						    					//
//									    									//							
// 	 	Delay     : [45ms - 55ms]	=>	240 points	    					//
//		Mean 	  :  50ms			=>	2400 points	    					//
//		Frequence :  3Hz   	Periode ==> 	16000 points	    			//
//     									    								//
// Decoupe du signal : 	| 0  - 8000 -  16000 |				    			//
//			|--------------------|				    						//
//			|   ,---.	     	 |		 		    						//
// 			|  /	 \      /    |				    						//
//			| 	  	  '____'     |			            					//
//			|--------------------|				    						//
//									    									//
// NB : 0.00000005625 	=	0.9/(4000^2)				    				//
//		0.0005			=	2/4000				            				//
//		0.00135			=	3*2/4000			            				//
//		2400			=	48000*50ms			            				//
//		0.00003051757	=	2^-15					    					//
//								            								//
//--------------------------------------------------------------------------//


void Flanger_Parabole_Function(void) 
{
int j,k=0;																									// Increment d'échantillons
	for(k=24*Size_acq-1; k>Size_acq; k--){Big_Input[k] = Big_Input[k-Size_acq];} 							// Shift la data de 128 [[New]==>[Old]]	
	for (j=0;j<Size_acq;j++)
	{
		if(Toff==16000) {Toff=0;}																			// Si au bout de la periode, reprendre à 0																				
		if(Toff<8000){
			DelayFunction[j]=-multr_fr1x16(Toff,0.00000005625r16);											// Parabole de base (8000 , 1)
			DelayFunction[j]=multr_fr1x16((DelayFunction[j]+0.0005r16),Toff);}								// Parabole convexe
		else {
			DelayFunction[j]=multr_fr1x16(Toff,0.00000005625r16);											// Parabole de base (14000,-1)
			DelayFunction[j]=multr_fr1x16((DelayFunction[j]-0.00135r16),Toff)+7.2;}							// Parabole concave
		Toff=Toff+1;																						// Incrementation d'indice
		
		nDelay = 2400/DelayMaxInv;																			// (DelayMean*Fs) * DelayMaxInv;
		nDelay = nDelay + multr_fr1x16(240,multr_fr1x16(DelayFunction[j],0.00003051757r16));				// nDelay = nombre d'échantillons de retard	
		Big_Input[Size_acq-1-j] = input_data[j];															// BI = [ID[New] ... ID[Old->New] ... ID[Old]]
		Delayed_Input[j] = Big_Input[j+nDelay];																// DI = 
		output_data[j] = multr_fr1x16(GainMain,input_data[j])+multr_fr1x16(GainChorus,Delayed_Input[j]);	// OD = 0.5 * ID + 0.5 * DI
	}

}//end of function