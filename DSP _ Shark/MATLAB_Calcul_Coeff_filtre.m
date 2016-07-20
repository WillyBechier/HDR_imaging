clear all
close all

Fs=48000;           %Fréquence d'échantillonage du DSP
N=10;               %Nombre de filtres
Fc=zeros(1,N+1);    %Initialisation du vecteur des fréquences de coupure des filtres
Fc1=50;         	%Fréquence de coupure basse

Fc=[Fc1 Fc1*ones(1,N).*1.26.^[1:N]]';
BW=ones(N,1);
F0=diff(Fc)+Fc(1:N);
W0=2*pi*F0/Fs;
Q=1./(2*sinh(log(2)/2.*BW.*W0./sin(W0)));
alpha=sin(W0)./(2*Q);

A=[ 1+alpha  -2*cos(W0)  1-alpha     ];
B=[ Q.*alpha  zeros(N,1) -Q.*alpha   ];
%VectA=reshape(A',3*N,1);
%VectB=reshape(B',3*N,1);
VectAB=[A B]';

% A = [1 2 3; 7 8 9 ; 13 14 15];
% B = [4 5 6; 10 11 12 ; 16 17 18];
% VectAB=[A B]'

Normalizer=max(max(abs(VectAB)));
Converter=32767;
VectAB=VectAB*Normalizer/Converter;

fileID = fopen('coeff_filter.dat','w');
%fprintf(fileID,'#define VectAB [');
fprintf(fileID,'%f ,',VectAB);
%fprintf(fileID,'] // a0a1a2 b0b1b2 ...');
fclose(fileID);