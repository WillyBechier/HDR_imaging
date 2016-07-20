#include "Talkthrough.h"
#include <filter.h>

//--------------------------------------------------------------------------//
// Function:	Filter_Function2()					    					//
//									    									//		
//	Filtrage RII ordre 2 : fonction de transfert :	H(z)		    		//
//									    									//
//		b0 + b1.z-1 + b2.z-2				    	    					//
//	H(z)= -------------------------		       			   				 	//
//		a0 + a1.z-1 + a2.z-2				   	    						//
//									    									//	
//	Forme série : 							    							//
//  Y(z)= 1/a0 (b0.X(z)+ b1.X(z-1)+b2.X(z-2)-a1.Y(z-1)+a2.Y(z-2))	    	//
//					   				    									//									
//--------------------------------------------------------------------------//

static fract16 x[3] = {0};

static fract16 y_l[3] = {0};
static fract16 y_m[3] = {0};
static fract16 y_h[3] = {0};

static fract16 G_fil[3] = {0.3r16,0.3r16,0.3r16};

void Filter_Function2(void)
{
	
	int i = 0;
	
	for (i = 0; i < Size_acq; i++)
	{			
		
		// Update previous values
		x[2] = x[1];
		x[1] = x[0];
		x[0] = input_data[i];		

		// ------------------- Low frequencies --------------------------
		// f=300 Hz
		
		// Recursive contribution
		y_l[0] = y_l[1] + multr_fr1x16(30926,y_l[1]) - multr_fr1x16(30953,y_l[2]);
		
		// Innovative contribution
		y_l[0] += multr_fr1x16(908,x[0]) - multr_fr1x16(908,x[2]);
		
		y_l[2] = y_l[1];
		y_l[1] = y_l[0];
					
		
				
		// ------------------- Mid frequencies --------------------------
		// f=1 kHz
		
		// Recursive contribution
		y_m[0] = y_m[1] + multr_fr1x16(25693,y_m[1]) - multr_fr1x16(26077,y_m[2]);
		
		// Innovative contribution
		y_m[0] += multr_fr1x16(3346,x[0]) - multr_fr1x16(3346,x[2]);
		
		y_m[2] = y_m[1];
		y_m[1] = y_m[0];
		
		// ------------------- High frequencies --------------------------
		// f=4 kHz
		
		// Recursive contribution
		y_h[0] = y_h[1] + multr_fr1x16(8087,y_h[1]) - multr_fr1x16(12734,y_h[2]);
		
		// Innovative contribution
		y_h[0] += multr_fr1x16(10017,x[0]) - multr_fr1x16(10017,x[2]);
		
		y_h[2] = y_h[1];
		y_h[1] = y_h[0];		
		
				
		output_data[i] = multr_fr1x16(G_fil[0],y_l[0]) + multr_fr1x16(G_fil[1],y_m[0]) + multr_fr1x16(G_fil[2],y_h[0]);
		
				
	}	
	
}