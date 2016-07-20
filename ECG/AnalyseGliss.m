function [ moy_ecg b5] = AnalyseGliss( Signal, Fs)

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
%%%%%%%%%%%%%%%%%%    F I L T R E     G L I S S A N T    %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Gain=30;
B=ones(1,30)/Gain;
A=1;
% figure;
% freqz(B,A,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    F I L T R A G E     D U     S I G N A L    %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Signal_Gliss_filter=filter(B,A,Signal_Padd);
moy_ecg=[zeros(1,20) Signal_Gliss_filter(1+20:Ns)];

figure(1);
subplot(616);
plot(Time,[moy_ecg(1:Ns-30) zeros(1,30)],'c');title('signal fenetre glissante');

Periodo_Rect_Deriv = periodogram(Signal_Gliss_filter,rectwin(N),Nfft);

figure(2);
hold on;
plot(Xfft,20*log(Periodo_Rect_Deriv),'c');
hold off;



b5=B;
end