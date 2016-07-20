function [ Signal_Restaure ] = Papoulis( Signal_ecg , Fs ,PlageAbime, NombreIteration)

N=length(Signal_ecg);
NPlage=length(PlageAbime);
Signal_Abime=Signal_ecg;

Interpolation= (( Signal_Abime(PlageAbime(NPlage)) - Signal_Abime(PlageAbime(1)) )/NPlage)*(0:NPlage-1) + Signal_Abime(PlageAbime(1));
Signal_Interpole=Signal_Abime;
Signal_Interpole(PlageAbime)=Interpolation;

Signal_Restaure=Signal_Interpole;

for i=1:NombreIteration
   
    FFTsignal=fft(Signal_Restaure);
    
    FFTsignal(ceil(N/2-30*2*N/Fs):ceil(N/2+30*2*N/Fs))=0;           %FFT nulle f>30Hz
 
    correction=real(ifft(FFTsignal));
    Signal_Restaure(PlageAbime(2:NPlage-1))=correction(PlageAbime(2:NPlage-1));
end

    figure;
    hold on;
    title('Signal origine (vert) interpolé (bleu) restauré (rouge)');
    plot(Signal_ecg,'g');
    plot(Signal_Interpole,'b');
    plot(Signal_Restaure,'r:');
  
    hold off;

end

