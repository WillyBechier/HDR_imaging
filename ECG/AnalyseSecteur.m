function [ Signal_ecg ] = AnalyseSecteur( Signal,Fs,f1,eps)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    I N I T I A L I S A T I O N    %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Signal=Signal';

Ns=length(Signal);                  % Longueur du signal
Nz=400;                             % Longueur du zero-padding
N=Ns+Nz;                            % Longueur du signal paddé
Time = (1 : Ns)/Fs;                 % Echelle temporelle
Signal_Padd=[Signal, zeros(1,Nz)];  % Signal paddé

Nfft=2*(N-1);                       % Nombre de points de FFT
Xfft=(0:N-1)*(Fs/(2*N));            % Echelle de la FFT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%    F I L T R E     A     E N C O C H E    %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fsecteur=f1;
a1=-2*cos(2*pi*fsecteur/Fs);
B=[1 a1 1];
A=[1 (1-eps)*a1 (1-eps)^2];
% figure;
% freqz(B,A,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    F I L T R A G E     D U     S I G N A L    %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Signal_notch_filter=filter(B,A,Signal_Padd);
Signal_ecg=Signal_notch_filter(1:Ns);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%    P E R I O D O G R A M M E    +    S I G N A L    %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);
subplot(611)
plot(Time,Signal,'b');title('signal original');
subplot(612)
plot(Time,Signal_ecg,'g');title('signal Notch-filtré');

Periodo_Rect = periodogram(Signal_Padd,rectwin(N),Nfft);
Periodo_Rect_notch = periodogram(Signal_notch_filter,rectwin(N),Nfft);

figure(2);
xlabel('frequence (Hz)');
ylabel('amplitude (dB)');
hold on;
plot(Xfft,20*log(Periodo_Rect),'b');
plot(Xfft,20*log(Periodo_Rect_notch),'g');title('FFT signal filtré ( vert ) non-filtré (bleu)');
hold off;


end