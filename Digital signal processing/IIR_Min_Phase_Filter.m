function [ ZB2,ZC2,ZE2,PB2,PC2,PE2,SOS_B_MinPhase,SOS_C_MinPhase,SOS_E_MinPhase ] = IIR_Min_Phase_Filter( SOS_B,SOS_C,SOS_E,ZB2,ZC2,ZE2,PB2,PC2,PE2,KB2,KC2,KE2,H_Butterworth,H_Tchebychev,H_Elliptique,G_B,G_C,G_E,GainPlateau,W)

%-------------------------------------------------------------------------%
%                       Check toutes les |Zeros|>1                        %
%                                                                         %
% FOS_ALL_B = [ 1/po , -1 , 1  ,1/po* ; " " " " " " " ; Num Den ]         %
% FOS_ALL_B = {1/po -1.(z-1) 0} over {1 1/po*.(z-1) 0}                    %
%                                                                         %
%            1      1 - po    .z^-1       1/po  -1  .z^-1                 %
% FOS_ALL = --- . ------------------- =  ------------------               %
%            po     1 - 1/po* .z^-1       1 - 1/po* .z^-1                 %
%                                                                         %
%                                                                         %
%            zo     1 - 1/zo* .z^-1       1  -1/zo* .z^-1                 %
% FOS_ALL = --- . ------------------- =  ------------------               %
%            1      1 - zo    .z^-1       1/zo  -1  .z^-1                 %
%                                                                         %
%-------------------------------------------------------------------------%

KB2=prod(abs(ZB2(abs(ZB2(:))>1)));                              %*prod(abs(1./(PB2(abs(PB2(:))>1))))
KC2=prod(abs(ZC2(abs(ZC2(:))>1)));                              %*prod(abs(1./(PC2(abs(PC2(:))>1))))
KE2=prod(abs(ZE2(abs(ZE2(:))>1)));                              %*prod(abs(1./(PE2(abs(PE2(:))>1))))


ZB2(abs(ZB2(:))>1)=1./conj(ZB2(abs(ZB2(:))>1));
ZC2(abs(ZC2(:))>1)=1./conj(ZC2(abs(ZC2(:))>1));
ZE2(abs(ZE2(:))>1)=1./conj(ZE2(abs(ZE2(:))>1));


PB2(abs(PB2(:))>1)=1./conj(PB2(abs(PB2(:))>1));
PC2(abs(PC2(:))>1)=1./conj(PC2(abs(PC2(:))>1));
PE2(abs(PE2(:))>1)=1./conj(PE2(abs(PE2(:))>1));


SOS_B_MinPhase=zp2sos(ZB2,PB2,KB2);
SOS_C_MinPhase=zp2sos(ZC2,PC2,KC2);
SOS_E_MinPhase=zp2sos(ZE2,PE2,KE2);

[MPF_Num_B,MPF_Den_B]=zp2tf(ZB2,PB2,KB2);
Amplitude_MinB=freqz(MPF_Num_B,MPF_Den_B);

[MPF_Num_C,MPF_Den_C]=zp2tf(ZC2,PC2,KC2);
Amplitude_MinC=freqz(MPF_Num_C,MPF_Den_C);

[MPF_Num_E,MPF_Den_E]=zp2tf(ZE2,PE2,KE2);
Amplitude_MinE=freqz(MPF_Num_E,MPF_Den_E);


%-------------------------------------------------------------------------%
%                         Phase : Min_Phase_Filter Vs Normal                          %
%-------------------------------------------------------------------------%


Phase_Butterworth = unwrap(2*angle(H_Butterworth))/2;
Phase_Tchebychev = unwrap(2*angle(H_Tchebychev))/2;
Phase_Elliptique = unwrap(2*angle(H_Elliptique))/2;

Phase_MinButterworth = unwrap(2*angle(Amplitude_MinE))/2;
Phase_MinTchebychev = unwrap(2*angle(Amplitude_MinE))/2;
Phase_MinElliptique = unwrap(2*angle(Amplitude_MinE))/2;

%-------------------------------------------------------------------------%
%                                   PLOT                                  %
%-------------------------------------------------------------------------%

Fig5=figure(5);
set(Fig5,'name','Min Phase Filters')

subplot(2,3,1)
hold on;
plot(W/pi,20*log10(abs(H_Butterworth))+GainPlateau,'b','linewidth',3);
plot(W/pi,20*log10(abs(Amplitude_MinB))+20*log10(G_B)+GainPlateau,'w:','linewidth',2);
hold off;
title('COLOR = FIR_{Butterworth}    Dotes = MinPhaseFilter');axis([0 1 -35 -15]);
xlabel('fréquence normalisée');ylabel('Amplitude');

subplot(2,3,2)
hold on;
plot(W/pi,20*log10(abs(H_Tchebychev))+GainPlateau,'m','linewidth',3);
plot(W/pi,20*log10(abs(Amplitude_MinC))+20*log10(G_C)+GainPlateau,'w:','linewidth',2);
hold off;
title('COLOR = FIR_{Tchebychev}    Dotes = MinPhaseFilter');axis([0 1 -35 -15]);
xlabel('fréquence normalisée');ylabel('Amplitude');

subplot(2,3,3)
hold on;
plot(W/pi,20*log10(abs(H_Elliptique))+GainPlateau,'r','linewidth',3);
plot(W/pi,20*log10(abs(Amplitude_MinE))+20*log10(G_E)+GainPlateau,'w:','linewidth',2);
hold off;
title('COLOR = FIR_{Elliptique}    Dotes = MinPhaseFilter');axis([0 1 -35 -15]);
xlabel('fréquence normalisée');ylabel('Amplitude');

subplot(2,3,4)
hold on;
plot(W/pi,Phase_Butterworth,'b','linewidth',3);
plot(W/pi,Phase_MinButterworth,'k:','linewidth',2);
hold off;
xlabel('fréquence normalisée');ylabel('Phase');

subplot(2,3,5)
hold on;
plot(W/pi,Phase_Tchebychev,'m','linewidth',3);
plot(W/pi,Phase_MinTchebychev,'k:','linewidth',2);
hold off;
xlabel('fréquence normalisée');ylabel('Phase');

subplot(2,3,6)
hold on;
plot(W/pi,Phase_Elliptique,'r','linewidth',3);
plot(W/pi,Phase_MinElliptique,'w:','linewidth',2);
hold off;
xlabel('fréquence normalisée');ylabel('Phase');



end

