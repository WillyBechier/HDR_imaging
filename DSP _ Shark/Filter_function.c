#include "Talkthrough.h"
#include <filter.h>

//--------------------------------------------------------------------------//
// Function:	Filter_Function()					    					//
//									    									//		
//	Filtrage RII ordre 2 : fonction de transfert :	H(z)		    		//
//									    									//
//		b0 + b1.z-1 + b2.z-2				    	    					//
//	H(z)= -------------------------		       			    				//
//		a0 + a1.z-1 + a2.z-2				   	    						//
//									    									//	
//	Forme série : 							    							//
//  Y(z)= 1/a0 (b0.X(z)+ b1.X(z-1)+b2.X(z-2)-a1.Y(z-1)+a2.Y(z-2))	    	//
//					   				    									//									
//--------------------------------------------------------------------------//

void Filter_Function(void) 
{
int i;
for (i=0;i<Nfiltre;i++)	Gain[i] = 0.09r16; 
int RegSize=3;	
																								// Ordre 2 => RegSize = card [X(t), X(t-1), X(t-2)] = 3
fract16 X[RegSize],Y[RegSize];																	// Declar : X[/ / /] Y [/ / /]
fract16 CenterTap=0;																			// Declar : valeur intermédiaire : Accu
int j,k,nfiltre;																				// Declar : incrementation
fract16 Output[Size_acq];																		// Declar : sortie

for(j=0;j<RegSize;j++) X[j] = 0;																// Init X=[ 0 0 0 ]
for(j=0;j<RegSize;j++) Y[j] = 0;																// Init Y=[ 0 0 0 ]

//for (nfiltre=0;nfiltre<Nfiltre;nfiltre++)
{
	for(j=0; j<Size_acq; j++)
	{
	   // Shift the register values.

	   for(k=RegSize-1; k>0; k--)X[k] = X[k-1]; 												// X[i3 i2 i1] => X[i3 i3 i2]
	   for(k=RegSize-1; k>0; k--)Y[k] = Y[k-1]; 												// Y[o3 o2 o1] => Y[o3 o3 o2]
	   X[0] = input_data[j];																	// X[i4 i3 i2]			// Update : New Input Value

	   // Compute the filter

	   CenterTap = VectAB[nfiltre*6+3]* X[0];													// CT=b0*i4 (normalized by a0)
	   for(k=1; k<RegSize; k++)																	// CT=b0*i4 + b1*i3 - a1*o3	(normalized by a0)
	   	//{CenterTap += VectAB[nfiltre*6+k+3] * X[k] - VectAB[nfiltre*6+k] * Y[k];}				// CT=b0*i4 + b1*i3 + b2*i2 - a1*o3 - a2*o2(normalized by a0)
		{	
			CenterTap = CenterTap + VectAB[nfiltre*6+k+3] * X[k] ;
			CenterTap = CenterTap - VectAB[nfiltre*6+k] * Y[k];
		}
	   
	   Y[0] = CenterTap;   																		// Y[o4 o3 o2]
	   Output[j] = Gain[nfiltre]*Y[0];															// Output= Gain *(b0*i4 + b1*i3 + b2*i2 - a1*o3 - a2*o2) (normalized by a0)
	   
	   output_data[j]=Output[j];																// Output_data = y1 +y2 +y3 +...
	}//end of j
	

}// for nfiltre


}//end of function
