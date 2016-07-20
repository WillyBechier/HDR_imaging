#include "Talkthrough.h"

//--------------------------------------------------------------------------//
// Function:	Vibrato_Function()				            				//
//									    									//
// 		Gain 	  : 1.5						    							//
//		Frequence : 6Hz   	Periode ==> 8000 points		    				//
//									    									//
// Decoupe du signal : 	| 0  -  4000 -  8000 |				   			 	//
//			|--------------------|				    						//
//			|   ,---.		     |		 		    						//
// 			|  /	 \      /    |				    						//
//			|		  '____'     |			            					//
//			|--------------------|				    						//			
//									    									//
// NB : 0.00000025 	=	1/(2000^2)				    						//
//		0.0005		=	1/(2000)				    						//
//		0.001		=	2/(2000)				    						//
//		0.003		=	6/(2000)				    						//
//		0.6		=	1.5/(1+1.5)				    							//
//		0.4		=	1/(1+1.5)				    							//
//--------------------------------------------------------------------------//

void Vibrato_Function(void) 
{
int j,k=0;																						// Increment d'échantillons
	for (j=0;j<Size_acq;j++)
	{
		if(Toff==8000) {Toff=0;}																// Si au bout de la periode, reprendre à 0																				
		if(Toff<4001){
			ShellFunction[j]=-multr_fr1x16(Toff,0.00000025r16);									// Parabole de base (8000 , 1)
			ShellFunction[j]=multr_fr1x16((ShellFunction[j]+0.001r16),Toff);}					// Parabole convexe
		else {
			ShellFunction[j]= multr_fr1x16(Toff,0.00000025r16);									// Parabole de base (14000,-1)
			ShellFunction[j]=multr_fr1x16((ShellFunction[j]-0.003r16),Toff+8);}					// Parabole concave
		Toff=Toff+1;																			// Incrementation d'indice
		ShellFunction[j]=multr_fr1x16(0.4r16,ShellFunction[j]);									// Shell => [-1, 1]/( 1 + 1.5)
				
		output_data[j] = multr_fr1x16(input_data[j],0.6r16);									// OD = ID * ( 1.5 + Shell ) / ( 1 + 1.5 ) => OD = ID * 1.5/2.5
		output_data[j] = output_data[j]+multr_fr1x16(input_data[j],ShellFunction[j]);			// OD = ID * ( 1.5 + Shell ) / ( 1 + 1.5 ) => OD = OD + ID * Shell

	}

}//end of function
