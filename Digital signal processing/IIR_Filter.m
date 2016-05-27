function [  H_Butterworth,H_Tchebychev,H_Elliptique,N_Butterworth,B_Butterworth,A_Butterworth,Z_Butterworth,P_Butterworth,G_Butterworth,N_Tchebychev,B_Tchebychev,A_Tchebychev,Z_Tchebychev,P_Tchebychev,G_Tchebychev,N_Elliptique,B_Elliptique,A_Elliptique,Z_Elliptique,P_Elliptique,G_Elliptique] = IIR_Filter( N,fe,F1,F2,M1,M2,W,GainPlateau,wp,ws,rp,rs )


[N_Butterworth,Wn]=buttord(wp,ws,rp,rs,'s');
[B_Butterworth,A_Butterworth]=butter(N_Butterworth,Wn);
[H_Butterworth,~] = freqz(B_Butterworth,A_Butterworth,512);
[Z_Butterworth,P_Butterworth,G_Butterworth]=butter(N_Butterworth,Wn,'s');

[N_Tchebychev,Wn]=cheb1ord(wp,ws,rp,rs,'s');
[B_Tchebychev,A_Tchebychev]=cheby1(N_Tchebychev,rp,Wn);
[H_Tchebychev,~] = freqz(B_Tchebychev,A_Tchebychev,512);
[Z_Tchebychev,P_Tchebychev,G_Tchebychev]=cheby1(N_Tchebychev,rp,Wn,'s');

[N_Elliptique,Wn]=ellipord(wp,ws,rp,rs,'s');
[B_Elliptique,A_Elliptique]=ellip(N_Elliptique,rp,rs,Wn);
[H_Elliptique,~] = freqz(B_Elliptique,A_Elliptique,512);
[Z_Elliptique,P_Elliptique,G_Elliptique]=ellip(N_Elliptique,rp,rs,Wn,'s');

Fig2=figure(2);
set(Fig2,'name','Filtres RII');
subplot(1,3,1)
hold on;
plot(F1,M1,'k:',F2,M2,'k:','LineWidth',2)                                   % Plot le gabarit et le filtre idéal
plot(W/pi,20*log10(abs(H_Butterworth))+GainPlateau,'b','LineWidth',2);
hold off;
title('IIR Butterworth');
xlabel('frequence normalisée');ylabel('Gain (db)');
axis([0 1 -31 -19]);

subplot(1,3,2)
hold on;
plot(F1,M1,'k:',F2,M2,'k:','LineWidth',2)                                   % Plot le gabarit et le filtre idéal
plot(W/pi,20*log10(abs(H_Tchebychev))+GainPlateau,'m','LineWidth',2);
hold off;
title('IIR Tchebychev');
xlabel('frequence normalisée');ylabel('Gain (db)');
axis([0 1 -31 -19]);

subplot(1,3,3)
hold on;
plot(F1,M1,'k:',F2,M2,'k:','LineWidth',2)                                   % Plot le gabarit et le filtre idéal
plot(W/pi,20*log10(abs(H_Elliptique))+GainPlateau,'r','LineWidth',2);
hold off;
title('IIR Elliptique');
xlabel('frequence normalisée');ylabel('Gain (db)');
axis([0 1 -31 -19]);


end

