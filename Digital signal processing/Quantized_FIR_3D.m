function [SOS_B_Q3D,SOS_C_Q3D,SOS_E_Q3D,H_B_Q3D,H_C_Q3D,H_E_Q3D,W3D] = Quantized_FIR_3D( nE,nF,Length_nF,GainPlateau,SOS_B,SOS_C,SOS_E,G_B,G_C,G_E,LB,LC,LE )


%-------------------------------------------------------------------------%
%                      	Initiatilisation Matrices                         %
% ------------------------------------------------------------------------%

H_B_Q3D=zeros(LB,512,Length_nF);
H_C_Q3D=zeros(LC,512,Length_nF);
H_E_Q3D=zeros(LE,512,Length_nF);

SOS_B_Q3D=zeros(LB,6,Length_nF);
SOS_C_Q3D=zeros(LC,6,Length_nF);
SOS_E_Q3D=zeros(LE,6,Length_nF);

U3D=zeros(Length_nF,10);

A_B_Q3D=zeros(Length_nF,2*LB+1);
A_C_Q3D=zeros(Length_nF,2*LC+1);
A_E_Q3D=zeros(Length_nF,2*LE+1);

B_B_Q3D=zeros(Length_nF,2*LB+1);
B_C_Q3D=zeros(Length_nF,2*LC+1);
B_E_Q3D=zeros(Length_nF,2*LE+1);

%-------------------------------------------------------------------------%
%                	Calcul des FIR avec différents nF                     %
% ------------------------------------------------------------------------%

for i=nF
U3D(i,1:10000)=linspace(-2^(nE)+2^(-i), 2^(nE)-2^(-i), 10000);
Q3D(i)=quantizer([i+1+nE i],'fixed','nearest','saturate');

SOS_B_Q3D(:,:,i)=quantize(Q3D(i),SOS_B);
SOS_C_Q3D(:,:,i)=quantize(Q3D(i),SOS_C);
SOS_E_Q3D(:,:,i)=quantize(Q3D(i),SOS_E);

[B_B_Q3D(i,:),A_B_Q3D(i,:)]=sos2tf(SOS_B_Q3D(:,:,i),G_B);
[B_C_Q3D(i,:),A_C_Q3D(i,:)]=sos2tf(SOS_C_Q3D(:,:,i),G_C);
[B_E_Q3D(i,:),A_E_Q3D(i,:)]=sos2tf(SOS_E_Q3D(:,:,i),G_E);

[H_B_Q3D(1:512,i),W3D]=freqz(B_B_Q3D(i,:),A_B_Q3D(i,:),512);
[H_C_Q3D(1:512,i), ~ ]=freqz(B_C_Q3D(i,:),A_C_Q3D(i,:),512);
[H_E_Q3D(1:512,i), ~ ]=freqz(B_E_Q3D(i,:),A_E_Q3D(i,:),512);
end;

%-------------------------------------------------------------------------%
%                 Plot FIR avec Niveau de quantification                  %
% ------------------------------------------------------------------------%

Fig10=figure(10);
set(Fig10,'name','Quantification sur Butterworth');

for i=nF
subplot(1,3,1)
title('Quantification FIR_{Butterworth}');axis([0 Length_nF 0 1 -50 0]);
xlabel('nF');ylabel('f_{normalisée}');zlabel('Amplitude');grid on;
hold on;
plot3(i*ones(512,1),W3D/pi,20*log10(abs(H_B_Q3D(1:512,i)))+GainPlateau,'color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,1],'linewidth',2);

subplot(1,3,2)
title('Quantification FIR_{Chebytchev}');axis([0 Length_nF 0 1 -50 0]);
xlabel('nF');ylabel('f_{normalisée}');zlabel('Amplitude');grid on;
hold on;
plot3(i*ones(512,1),W3D/pi,20*log10(abs(H_C_Q3D(1:512,i)))+GainPlateau,'color',[1,0.8-i*0.8/Length_nF+0.1,1],'linewidth',2);


subplot(1,3,3)
title('Quantification FIR_{Elliptique}');axis([0 Length_nF 0 1 -50 0]);
xlabel('nF');ylabel('f_{normalisée}');zlabel('Amplitude');grid on;
hold on;
plot3(i*ones(512,1),W3D/pi,20*log10(abs(H_E_Q3D(1:512,i)))+GainPlateau,'color',[1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1],'linewidth',2);
end;

%-------------------------------------------------------------------------%
%                        Plot Réponse Impulsionnelle                      %
% ------------------------------------------------------------------------%

% Fig11=figure(11);
% set(Fig11,'name','Quantification sur Butterworth');
% 
% for i=nF
% subplot(1,3,1)
% title('Quantification FIR_{Butterworth}');axis([0 Length_nF 0 1 -50 0]);
% xlabel('nF');ylabel('f_{normalisée}');zlabel('Amplitude');grid on;
% hold on;
% plot3(i*ones(512,1),W3D/pi,20*log10(abs(H_B_Q3D(1:512,i)))+GainPlateau,'color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,1],'linewidth',2);

% subplot(1,3,2)
% title('Quantification FIR_{Chebytchev}');axis([0 Length_nF 0 1 -50 0]);
% xlabel('nF');ylabel('f_{normalisée}');zlabel('Amplitude');grid on;
% hold on;
% plot3(i*ones(1024,1),W3D/pi,20*log10(abs(H_C_Q3D(1:1024,i)))+GainPlateau,'color',[1,0.8-i*0.8/Length_nF+0.1,1],'linewidth',2);
% 
% 
% subplot(1,3,3)
% title('Quantification FIR_{Elliptique}');axis([0 Length_nF 0 1 -50 0]);
% xlabel('nF');ylabel('f_{normalisée}');zlabel('Amplitude');grid on;
% hold on;
% plot3(i*ones(1024,1),W3D/pi,20*log10(abs(H_E_Q3D(1:1024,i)))+GainPlateau,'color',[1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1],'linewidth',2);
% end;

end

