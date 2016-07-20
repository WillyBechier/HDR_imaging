clear all
close all


F=3;
Fs=48000;           %Fréquence d'échantillonage du DSP
N=48000/3;

% for n=1:N
% toto(n)=sin(2*pi*F/Fs*n);
% end

sinus=sin(2*pi*F/Fs*(0:N-1));

fileID = fopen('CFsinus.dat','w');
%fprintf(fileID,'#define VectAB [');
fprintf(fileID,',%fr16\n',sinus);
%fprintf(fileID,'] // a0a1a2 b0b1b2 ...');
fclose(fileID);

t=(0:N-1)/Fs
plot(t,sinus)