function [ hp_ecg b1 b2 b3 ] = AnalyseBande( Signal, Fs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    I N I T I A L I S A T I O N    %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ns=length(Signal);                  % Longueur du signal
Nz=400;                             % Longueur du zero-padding
N=Ns+Nz;                            % Longueur du signal paddé
Time = (1 : Ns)/Fs;                 % Echelle temporelle

Signal_Padd=[Signal, zeros(1,Nz)];  % Signal paddé

Nfft=2*(N-1);                       % Nombre de points de FFT
Xfft=(0:N-1)*(Fs/(2*N));            % Echelle de la FFT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%    F I L T R E     P A S S E     B A S    %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Gain=32;
Bb=[1 zeros(1,5) -2 zeros(1,5) 1]/Gain;
Ab=[1 -2 1 ];
% figure;
% freqz(Bb,Ab,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%    F I L T R E     P A S S E     H A U T    %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Gain=32;
Bh=[1 zeros(1,15) 32 zeros(1,15) -1]/Gain;
Ah=[1 1];
% figure;
% freqz(Bh,Ah,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    F I L T R A G E     D U     S I G N A L    %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Signal_PBas_filter=filter(Bb,Ab,Signal_Padd);
Signal_PBande_filter=filter(Bh,Ah,Signal_PBas_filter);
hp_ecg=Signal_PBande_filter(1+20:20+Ns);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%    P E R I O D O G R A M M E    +    S I G N A L    %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);
subplot(613)
plot(Time,hp_ecg,'r');title('signal Passe-Bande filtré');

Periodo_Rect_Band = periodogram(Signal_PBande_filter,rectwin(N),Nfft);

figure(2);
hold on;
plot(Xfft,20*log(Periodo_Rect_Band),'r');
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%   S O R T I E S      C O E F F      F I L T R E     %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b1=Bb;
b2=[1 zeros(1,31) -1]/Gain;
b3=[zeros(1,16) 1];
end