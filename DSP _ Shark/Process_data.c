#include "Talkthrough.h"

//--------------------------------------------------------------------------//
// Function:	Process_Data()												//
//																			//
// Description: This function is called from inside the SPORT0 ISR every 	//
//				time a complete audio frame has been received. The new 		//
//				input samples can be found in the variables iChannel0LeftIn,//
//				iChannel0RightIn, iChannel1LeftIn and iChannel1RightIn 		//
//				respectively. The processed	data should be stored in 		//
//				iChannel0LeftOut, iChannel0RightOut, iChannel1LeftOut,		//
//				iChannel1RightOut, iChannel2LeftOut and	iChannel2RightOut	//
//				respectively.												//
//--------------------------------------------------------------------------//
void Process_Data(void)
{
//--------------------------------------------------------------------------//
//			Ecriture dans iRxBuffer :										//
//			S1	 _ _ _ S2 		...  Sn			n=Size_acq					//
//			Sn+1 _ _ _ Sn+2		... S2n			Tab[4 | Size_acque*4]		//
//		   	|						 | 			On écrit dans un canal		//
//		   	|						 |			sur 4						//
//		  	S3n+1 _ _ _ S3n+1	... S4n										//
//--------------------------------------------------------------------------//
	
switch (Switcher)
	{
		case 0 : 	{ 	offset =0; 					Switcher=1;			break;		}
		case 1 :	{ 	offset = 4*Size_acq;		Switcher=2;			break;		}
		case 2 :	{ 	offset = 8*Size_acq;		Switcher=3;			break;		}
		case 3 :	{ 	offset = 12*Size_acq;		Switcher=0;			break;		}
		default :	{ 	offset = 0;					Switcher=0;			break;		}	
	}
	
//--------------------------------------------------------------------------//
//		Lecture de iRxBuffer : Tab[4 | Size_acque*4]	n=Size_acq			//
//					S1	 _ _ _ S2 		...  Sn								//
//					Sn+1 _ _ _ Sn+2		... S2n								//
//		   			|						 | 								//
//		   			|						 |								//
//		  			S3n+1 _ _ _ S3n+1	... S4n								//
//																			//
//			24bits codec => 32bits int => 16bits short						//
//--------------------------------------------------------------------------//	

	int i;
	for (i=0;i<Size_acq;i++) input_data[i]=iRxBuffer1[4*i+offset]>>8;
	
//--------------------------------------------------------------------------//
//						Signal Processing => Filtering						//
//--------------------------------------------------------------------------//
	
	//Identity_Function();				//OK
	//Filter_Function(); 				//Ne fonctionne pas car les coeffs ne sont pas bon 
	//Filter_Function2(); 				//OK
	//Chorus_Function();				//OK
	//Flanger_Triangle_Function();		//OK
	  Flanger_Parabole_Function();		//OK
	//Vibrato_Function();

//--------------------------------------------------------------------------//
//			Si on a assez de mémoire pour 16 000 échantillons de Sinus		//
//--------------------------------------------------------------------------//	

	//for (i=0;i<Size_acq;i++)	{output_data[i]= coeff_sinus[i+offseter*Size_acq];}
	//offseter=offseter+1;
	//if (offseter==125) offseter=0;


//--------------------------------------------------------------------------//
//						Charge iTxBuffer1 avec la sortie					//
//--------------------------------------------------------------------------//
		
	for (i=0;i<Size_acq;i++)
	{
		iTxBuffer1[4*i+offset] = output_data[i]<<8;
	}
}
