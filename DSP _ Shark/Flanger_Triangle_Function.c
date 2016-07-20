#include "Talkthrough.h"

//--------------------------------------------------------------------------//
// Function:	Flanger_Triangle_Function()				    				//		
// Delay variable : Triangle						   					 	//
//									    									//
// 		Delay     : [45ms - 55ms]				    						//
//		Mean 	  :  50ms					    							//
//		Frequence :  3Hz   	Periode ==> 16000 points	    				//
//									    									//
// Decoupe du signal : 	| 0 - 8000 - 16000|				    				//
//			|-----------------|				    							//
//			|     .			  |				    							//
//			|    / \          |				    							//
// 			|   /   \   /     |				    							//
//			|		 \ /      |				    							//
//			|	 	  '       |				    							//
//			|-----------------|				    							//
//									    									//
// NB : 0.000225		=	0.9/4000				    					//				
//		120000			=	0.025*48000				    					//
//		0.00003051757	=	2^-15					   					 	//
//									    									//
//--------------------------------------------------------------------------//



void Flanger_Triangle_Function(void) 
{
int j,k=0;																							// Increment d'échantillon
	for(k=24*Size_acq-1; k>Size_acq; k--){Big_Input[k] = Big_Input[k-Size_acq];} 					// Shift la data
	for (j=0;j<Size_acq;j++)
	{
		if(Toff>16000) 		{Toff=0;}																// Si au bout du triangle, reprendre à 0																				
		if(Toff<8000)		{DelayFunction[j]=multr_fr1x16(Toff,0.000225r16);	}					// Pente Montante : y=x*0.9/4000
		else
			{
			if(Toff>12000) 	{DelayFunction[j]=multr_fr1x16(Toff,0.000225r16)-3.6;}					// Pente montante : y=(x-12000)*0.9/4000
			else 			{DelayFunction[j]=-multr_fr1x16(Toff,0.000225r16)+1.8;}	
		}																							// Sur pente descendante du triangle [1 ==> -1]
		Toff=Toff+1;																				// Incrementation d'indice
		
		nDelay = 2400;																				// DelayMean*Fs
		nDelay = nDelay + multr_fr1x16(240,multr_fr1x16(DelayFunction[j],0.00003051757r16));						// nDelay = nombre d'échantillons de retard	
		Big_Input[Size_acq-1-j] = input_data[j];													// BI = [ID[New] ... ID[Old->New] ... ID[Old]]
		Delayed_Input[j] =Big_Input[j+nDelay];														// DI = BI [echnatillon + delay]
		output_data[j]=multr_fr1x16(GainMain,input_data[j])+multr_fr1x16(GainChorus,Delayed_Input[j]);
	}
}//end of function