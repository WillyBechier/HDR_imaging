
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
////////////////////////////////////////////////////////////////////
class signal  
{
protected:
	float amplitude;
	float phase;

public:
	signal();

	virtual float fonction(float t){return 0;};
};
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
	
class echelon : public signal
{
public:
	echelon();
	float fonction ( float t);
	void set_echelon(float amplitude, float phase);
};
////////////////////////////////////////////////////////////////////
	
class pulse : public signal
{
public:
	pulse();
	float fonction ( float t);
	void set_pulse(float amplitude, float phase, float holdP);
protected :
	float holdP;
};
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
	
class periodique : public signal
{
public:
	periodique();
	virtual float fonction ( float t){return 0;};
protected :
	float periode;
};
////////////////////////////////////////////////////////////////////
class sinus : public periodique
{
public:
	sinus();
	void set_sinus(float amplitude, float phase, float periode);
	float fonction ( float t);
};
////////////////////////////////////////////////////////////////////
	
class triangle : public periodique
{
public:
	triangle();
	void set_triangle(float amplitude, float phase, float periode);
	float fonction ( float t);
};
////////////////////////////////////////////////////////////////////
	
class creneau : public periodique
{
public:
	creneau();
	void set_creneau(float amplitude, float phase, float periode,float holdC);
	float fonction ( float t);
protected:
	float holdC;
};
////////////////////////////////////////////////////////////////////