function [Bideal,Hideal,W] = FIR_Filter( N,fe,F1,F2,M1,M2,Fideal,Mnormalized,Mideal)
%---------------------------------------------------------------------------%
%                                       FIR                                 %
%---------------------------------------------------------------------------%

                                 % GdB Borne inf

[Bideal]=fir2(N,Fideal,Mideal);                                             % B = coefficient du numérateur / A = 1 = dénominateur
[Hideal,W] = freqz(Bideal,1,512);                                                     % H = Generation absisse ordonnée du filtre 
[Bnormal]=fir2(N,Fideal,Mnormalized);                                       % B = coefficient du numérateur / A = 1 = dénominateur

%---------------------------------------------------------------------------%
%                       Génération de bruit blanc                           %
%---------------------------------------------------------------------------%

nb=fe;                                                                      % nombre de points
Bblanc=randn(1,nb);                                                         % Bruit Blanc
Bruitfiltre=filter(Bnormal,1,Bblanc);                                             % Bruit Blanc Filtré
FFT_BB = fft(Bblanc);                                                       % FFT BB
FFT_BB_filtre = fft(Bruitfiltre);                                           % FFT BB filtré

Fig1 = figure(1);
set(Fig1,'Name','Gabararit, et RIF');

subplot(3,1,1)
plot(F1,M1,'r',F2,M2,'r',Fideal,Mideal,'b:*','LineWidth',2)                 % Plot le gabarit et le filtre idéal
title('Gabarit + Filtre Idéal')                                                  
ylabel('Amplitude (dB)');
axis([0 1 -35 -15]);

subplot(3,1,2)
hold on
plot(F1,M1,'r',F2,M2,'r',W/pi,-abs(Hideal),'b','LineWidth',2)               % Plot le gabarit et le filtre RIF
title('Gabarit + FIR.filter')                                                  
ylabel('Amplitude (dB)')
axis([0 1 -35 -15]);

subplot(3,1,3)
hold on;
plot(linspace(0,1,fe/2),abs(FFT_BB(1:fe/2)),'y');                           % FFT du bruit blanc        (dB)
plot(linspace(0,1,fe/2),abs(FFT_BB_filtre(1:fe/2)),'g');                    % FFT du bruit blanc filtré (dB)
plot(Fideal,100*Mnormalized,'b','LineWidth',2);                             % Gabarit idéal
title('Gabarit   +   FFT[Bruit Blanc] (jaune)   +   FFT[Bruit Blanc Filtré] (vert)')
xlabel('fréquence normalisée')
ylabel('Amplitude (dB)')
hold off


end

