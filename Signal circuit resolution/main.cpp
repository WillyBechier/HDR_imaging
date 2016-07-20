#include "signal.h"
#include <iostream.h>
#include <fstream.h>

void main()
{
	signal *Signal1;
	
	int choix;
	cout<<"1=sinus / 2=triangle / 3=creneau / 4=echelon / 5=pulse"<<endl;
	cin>>choix;
	ofstream fichier;
	switch ( choix )
		{
	case 1 : {Signal1 = new sinus;			fichier.open("sinus.txt",ios::out|ios::app);		cout<<"vous avez cree un sinus"<<endl;}; break;
	case 2 : {Signal1 = new triangle;		fichier.open("triangle.txt",ios::out|ios::app);		cout<<"vous avez cree un triangle"<<endl;} break;
	case 3 : {Signal1 = new creneau;		fichier.open("creneau.txt",ios::out|ios::app);		cout<<"vous avez cree un creneau"<<endl;} break;
	case 4 : {Signal1 = new echelon;		fichier.open("echelon.txt",ios::out|ios::app);		cout<<"vous avez cree un echelon"<<endl;} break;
	case 5 : {Signal1 = new pulse;			fichier.open("pulse.txt",ios::out|ios::app);		cout<<"vous avez cree un pulse"<<endl;} break;
	break;
		}


		int t=0;
	for(t=0;t<500;t++)
	{
		fichier<<Signal1->fonction(t)<<endl;
	}

	fichier.close();

};
