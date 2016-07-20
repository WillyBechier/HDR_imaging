function [ deriv_ecg b4] = AnalyseDeriv( Signal, Fs)

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

Gain=1;
B=[1 2 0 -2 -1]/Gain;
A=1;
% figure;
% freqz(B,A,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    F I L T R A G E     D U     S I G N A L    %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Signal_Deriv_filter=filter(B,A,Signal_Padd);
deriv_ecg=[zeros(1,20) Signal_Deriv_filter(1+20:Ns)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%    P E R I O D O G R A M M E    +    S I G N A L    %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);
subplot(614)
plot(Time,[deriv_ecg(1:Ns-100) zeros(1,100)],'m');title('signal Deriv filtré');

Periodo_Rect_Deriv = periodogram(Signal_Deriv_filter,rectwin(N),Nfft);

figure(2);
hold on;
plot(Xfft,20*log(Periodo_Rect_Deriv),'m');
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%   S O R T I E S      C O E F F      F I L T R E     %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b4=B;

end