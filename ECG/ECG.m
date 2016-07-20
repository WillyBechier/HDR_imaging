function [ Signal_ecg, Fs ] = ECGvirtuel()


Ns=100;
Nz=400;
N=Ns+Nz;
Xs=0:Ns-1;

f0=60;
f1=50;
fe=400;

Nfft=2*(N-1);
Xfft=0:(fe/2)/N:fe/2-(fe/2)/N;

% bruit blanc gaussien
sigmaBruit=0.2;
moyenne=0;
BruitBlanc=moyenne+sigmaBruit*randn(1,Ns);
figure;hist(BruitBlanc,50);title('distribution du bruit');

% sinusoide
Sinus=sin(2*pi*f0/fe*Xs);

% signal

A1=0.2;
A2=1;
A3=20;

Signal1=A1*Sinus+BruitBlanc;
Signal2=A2*Sinus+BruitBlanc;
Signal3=A3*Sinus+BruitBlanc;

figure;
subplot(3,1,1)
plot(Xs,Signal1);title('Signal RSB_1 = -7dB');
ylabel('signal1');
subplot(3,1,2)
plot(Xs,Signal2);title('Signal RSB_2 = 25dB');
ylabel('signal2');
subplot(3,1,3)
plot(Xs,Signal3);title('Signal RSB_3 = 85dB');
xlabel('temps');
ylabel('signal3');
 
% RSB
P_S1=A1^2/2;
P_S2=A2^2/2;
P_S3=A3^2/2;
P_B=sigmaBruit^2;
RSB1=10*log (P_S1/P_B);
RSB2=10*log (P_S2/P_B);
RSB3=10*log (P_S3/P_B);

% Periodogramme
Signal_Padd = [Signal2 zeros(1,Nz)];
Periodo_Rect = periodogram(Signal_Padd,rectwin(N),Nfft);

figure;
xlabel('fréquence(Hz)');
ylabel('amplitude');
plot(Xfft,20*log(Periodo_Rect));title('Periodogramme Signal');

Signal_ecg=Signal2;
Fs=fe;

