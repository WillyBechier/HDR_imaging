#include "Talkthrough.h"

//--------------------------------------------------------------------------//
// Function:	Chorus_Function()			        	    				//
// Delay fixe : 50ms							    						//					
//					   				    									//				
//--------------------------------------------------------------------------//

void Chorus_Function(void) 
{
int j,k=0;																											// Increment d'échantillon
	for (j=0;j<Size_acq;j++)
	{
		for(k=24*Size_acq-1; k>Size_acq; k--)	Big_Input[k] = Big_Input[k-Size_acq]; 								// Shift Older data ==> [New ==> Old]
		nDelay = multr_fr1x16(120000,DelayMaxInv);																	//DelayMean*DelayMaxInv*Fs
		Big_Input[j] = input_data[j];																				// BI = [I[128] I[128] ... 12x]
		Delayed_Input[j]=Big_Input[j+nDelay];																		// Data en retard
		output_data[j]=multr_fr1x16(GainMain,input_data[j])+multr_fr1x16(GainChorus,Delayed_Input[j]);				// Output_data = X[32e] + G * X[(32-Ndelay)e]
	}//end for size_acq
}//end of function
