
#include "signal.h"
using namespace std;
int pi=acos(-1);

echelon::echelon()
{
}

sinus::sinus()
{
}

triangle::triangle()
{
}

creneau::creneau()
{
	cout<<"rentrer votre temps de hold"<<endl;
	cin>>holdC;
}

pulse::pulse()
{
	cout<<"rentrer votre temps de hold"<<endl;
	cin>>holdP;
}

signal::signal()
{
	cout<<"rentrer votre amplitude"<<endl;
	cin>>amplitude;
	cout<<"rentrer votre phase"<<endl;
	cin>>phase;
};

periodique::periodique()
{
	cout<<"rentrer votre periode"<<endl;
	cin>>periode;
};	

/////////////////////////////////////////
float sinus::fonction(float t)
{
	float fonction1;
	if(t<=phase)
		{	fonction1=0;}
	else
	{	
	fonction1 = sin(2*pi*t/periode);
	}
	return fonction1;
};
/////////////////////////////////////////
float triangle::fonction(float t)
{
	float fonction1;
	if(t<=phase)
		{	fonction1=0;}
	else
	{
	if (fmod(t-phase,periode)<periode/2)
		{	fonction1 = (2*amplitude*fmod(t-phase,periode)) / periode;}
	else
		{	fonction1 =2*amplitude-2*amplitude*fmod(t-phase,periode) / periode;}
	}
	return fonction1;
};
/////////////////////////////////////////
float creneau::fonction(float t)
{
	float fonction1;
		if(t<=phase)
		{	fonction1=0;}
	else
	{
if (fmod(t-phase,periode)<holdC )
		{	fonction1 = amplitude;}
	else
		{	fonction1 = 0;}
	}
		return fonction1;
};
/////////////////////////////////////////
float echelon::fonction(float t)
{	
	float fonction1;
	if ( t<phase )
	{fonction1 = 0;}
	else 
	{fonction1=amplitude;}
	return fonction1;
};

/////////////////////////////////////////
float pulse::fonction(float t)
{	
	float fonction1;
	if ( t<phase || t>phase+holdP)
	{fonction1 = 0;}
	else 
	{fonction1=amplitude;}
	return fonction1;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

void sinus::set_sinus(float Namplitude, float Nphase, float Nperiode)
{
	amplitude = Namplitude;
	phase = Nphase;
	periode = Nperiode;
}

void triangle::set_triangle(float Namplitude, float Nphase, float Nperiode)
{
	amplitude = Namplitude;
	phase = Nphase;
	periode = Nperiode;
}

void creneau::set_creneau(float Namplitude, float Nphase, float Nperiode, float NholdC)
{
	amplitude = Namplitude;
	phase = Nphase;
	periode = Nperiode;
	holdC = NholdC;
}

void echelon::set_echelon(float Namplitude, float Nphase)
{
	amplitude = Namplitude;
	phase = Nphase;
}

void pulse::set_pulse(float Namplitude, float Nphase, float NholdP)
{
	amplitude = Namplitude;
	phase = Nphase;
	holdP = NholdP;
}
