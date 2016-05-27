function [  ] = Quantized_FIR( W,H_Butterworth,H_Tchebychev,H_Elliptique,GainPlateau,SOS_B_Q,SOS_C_Q,SOS_E_Q,G_B,G_C,G_E )
[B_B_Q,A_B_Q]=sos2tf(SOS_B_Q,G_B);
[B_C_Q,A_C_Q]=sos2tf(SOS_C_Q,G_C);
[B_E_Q,A_E_Q]=sos2tf(SOS_E_Q,G_E);


H_B_Q=freqz(B_B_Q,A_B_Q,512);
H_C_Q=freqz(B_C_Q,A_C_Q,512);
H_E_Q=freqz(B_E_Q,A_E_Q,512);

%-------------------------------------------------------------------------%
%                      Plot Filtres Ideal & Quantifié                     %
% ------------------------------------------------------------------------%


Fig9=figure(9);
set(Fig9,'name','Comparaison FIR idéal - quantifié');

subplot(1,3,1)
hold on;
plot(W/pi,20*log10(abs(H_Butterworth))+GainPlateau,'b');
plot(W/pi,20*log10(abs(H_B_Q))+GainPlateau,'k:');
hold off;
title('COLOR = FIR_{Butterworth}    Dotes = Quantized');axis([0 1 -35 -15]);
xlabel('fréquence normalisée');ylabel('Amplitude');

subplot(1,3,2)
hold on;
plot(W/pi,20*log10(abs(H_Tchebychev))+GainPlateau,'m');
plot(W/pi,20*log10(abs(H_C_Q))+GainPlateau,'k:');
hold off;
title('COLOR = FIR_{Tchebychev}    Dotes = Quantized');axis([0 1 -35 -15]);
xlabel('fréquence normalisée');ylabel('Amplitude');

subplot(1,3,3)
hold on;
plot(W/pi,20*log10(abs(H_Elliptique))+GainPlateau,'r');
plot(W/pi,20*log10(abs(H_E_Q))+GainPlateau,'k:');
hold off;
title('COLOR = FIR_{Elliptique}    Dotes = Quantized');axis([0 1 -35 -15]);
xlabel('fréquence normalisée');ylabel('Amplitude');


end

