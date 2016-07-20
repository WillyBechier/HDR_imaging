#include "Talkthrough.h"

//--------------------------------------------------------------------------//
// Function:	Identity_Function()					                        //
//									   									    //
//--------------------------------------------------------------------------//

int i;
void Identity_Function(void) 
{
	for (i=0;i<Size_acq;i++){output_data[i] = input_data[i];} 	// Output <==> Input
}