function [ SOS_B,G_B,LB,SOS_C,G_C,LC,SOS_E,G_E,LE,ZB2,PB2,ZC2,PC2,ZE2,PE2,KB2,KC2,KE2] = TF2SOS_Function(B_Butterworth,A_Butterworth,B_Tchebychev,A_Tchebychev,B_Elliptique,A_Elliptique,W,H_Butterworth,H_Tchebychev,H_Elliptique)

[SOS_B,G_B]=tf2sos(B_Butterworth,A_Butterworth);
[SOS_C,G_C]=tf2sos(B_Tchebychev,A_Tchebychev);
[SOS_E,G_E]=tf2sos(B_Elliptique,A_Elliptique);

[LB,~]=size(SOS_B);
[LC,~]=size(SOS_C);
[LE,~]=size(SOS_E);

for i=1:LB
    [B,A]=sos2tf(SOS_B(i,:),1); AmplB(:,i)=freqz(B,A);
end

for i=1:LC
    [B,A]=sos2tf(SOS_C(i,:),1); AmplC(:,i)=freqz(B,A);
end

for i=1:LE
    [B,A]=sos2tf(SOS_E(i,:),1); AmplE(:,i)=freqz(B,A);
end

[ZB2,PB2,KB2]=tf2zp(B_Butterworth,A_Butterworth);
[ZC2,PC2,KC2]=tf2zp(B_Tchebychev,A_Tchebychev);
[ZE2,PE2,KE2]=tf2zp(B_Elliptique,A_Elliptique);


Ampl_TotalB=real(sum(20*log10(AmplB),2))+20*log10(G_B);
Ampl_TotalC=real(sum(20*log10(AmplC),2))+20*log10(G_C);
Ampl_TotalE=real(sum(20*log10(AmplE),2))+20*log10(G_E);

%---------------------------------------------------------------------------%
%                           Plot Filtre Theorique                           %
%---------------------------------------------------------------------------%
 
Fig3=figure(3);
set(Fig3,'name','filtres 2nd ordre');

subplot(2,3,1)
plot(W/pi,20*log10(abs(H_Butterworth)),'b','LineWidth',2);
title('filtre Butterworth_{th}');ylabel('Amplitude (dB)');
axis([0 1 -30 30]);

subplot(2,3,2)
plot(W/pi,20*log10(abs(H_Tchebychev)),'m','LineWidth',2);
title('filtre Chebytchev_{th}');
axis([0 1 -30 30]);

subplot(2,3,3)
plot(W/pi,20*log10(abs(H_Elliptique)),'r','LineWidth',2);
title('filtre Elliptique_{th}');
axis([0 1 -30 30]);

%---------------------------------------------------------------------------%
%                         Plot filtres du 2nd ordre                         %
%---------------------------------------------------------------------------%

subplot(2,3,4)
hold on;
for i=1:LB
plot(W/pi,20*log10(abs(AmplB(:,i))),'k:');
end;
plot(W/pi,Ampl_TotalB,'b','LineWidth',2);
hold off;
title('Filtres 2nd ordre B')
ylabel('Amplitude (dB)');xlabel('fréquence_{normalisée}');
axis([0 1 -30 30]);

subplot(2,3,5)
hold on;
for i=1:LC
plot(W/pi,20*log10(abs(AmplC(:,i))),'k:');
end;
plot(W/pi,Ampl_TotalC,'m','LineWidth',2);
hold off;
title('Filtres 2nd ordre C');xlabel('fréquence_{normalisée}');
axis([0 1 -30 30]);

subplot(2,3,6)
hold on;
for i=1:LE
plot(W/pi,20*log10(abs(AmplE(:,i))),'k:');
end;
plot(W/pi,Ampl_TotalE,'r','LineWidth',2);
hold off;
title('Filtres 2nd ordre E');xlabel('fréquence_{normalisée}');
axis([0 1 -30 30]);


end

