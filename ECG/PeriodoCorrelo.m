function [  ] = PeriodoCorrelo( Signal,Fs )

Signal=Signal';                             % Signal

Ns=length(Signal);                          % Longueur du signal
Nz=400;                                     % Longueur du zero-padding
N=Ns+Nz;                                    % Longueur du signal paddé

Signal_Padd=[Signal, zeros(1,Nz)];          % Signal paddé

Nfft=2*(N-1);                               % Nombre de point de FFT
Xfft=(0:N-1)*(Fs/(2*N));                    % Echelle de FFT



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    P E R I O D O G R A M M E    %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Periodo_Rect = periodogram(Signal_Padd,rectwin(N),Nfft);
Periodo_Hann = periodogram(Signal_Padd,hann(N),Nfft);

figure;
xlabel('fréquence(Hz)');
ylabel('amplitude');
hold on;
plot(Xfft,20*log(Periodo_Rect));title('Periodogramme Rectangle(bleu) & Hanning(rouge)');
plot(Xfft,20*log(Periodo_Hann),'red');
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%    C O R R E L O G R A M M E S   %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Correlo_Biais    = abs(fft(xcorr(Signal_Padd, 'biased' )));
Correlo_NonBiais = abs(fft(xcorr(Signal_Padd,'unbiased')));
echelle=0:1/(N/(Fs/2)):Fs/2-1/(N/(Fs/2));

figure;
subplot(1,3,1)
xlabel('Amplitude');
ylabel('fréquence');
plot(echelle,20*log(Correlo_Biais(1:N)));title('correlogramme biaisé');
subplot(1,3,2)
xlabel('Amplitude');
ylabel('fréquence');
plot(echelle,20*log(Correlo_NonBiais(1:N)),'red');title('correlogramme non-biaisé');
subplot(1,3,3)
xlabel('Amplitude');
ylabel('fréquence');
plot(Xfft,20*log(Periodo_Rect));title('Periodogramme');

end

