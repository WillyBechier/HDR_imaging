function [SOS_B_Q,SOS_C_Q,SOS_E_Q] = Quantization( SOS_B,SOS_C,SOS_E,G_B,G_C,G_E,LB,LC,LE,nE,nF)

nW=1+nE+nF; % Longueur du mot  S 2 1 0 -1 -2 -3  =>Max = 0 111 111 = 7.875

%-------------------------------------------------------------------------%
%                   Calcul des paliers de quantification                  %
% ------------------------------------------------------------------------%

U=linspace(-2^(nE)+2^(-nF), 2^(nE)-2^(-nF), 10000);
Q=quantizer([nW nF],'fixed','nearest','saturate');
Escalier=quantize(Q,U)';
Palier=unique(quantize(Q,U))'*ones(1,2);

%-------------------------------------------------------------------------%
%            Implantation de la Quantification à virgule fixe             %
% ------------------------------------------------------------------------%

SOS_B_Q=quantize(Q,SOS_B);
SOS_C_Q=quantize(Q,SOS_C);
SOS_E_Q=quantize(Q,SOS_E);

Max_Coeff=max(max([SOS_B; SOS_C; SOS_E]))+0.5;
Min_Coeff=min(min([SOS_B; SOS_C; SOS_E]))-0.5;

%-------------------------------------------------------------------------%
%                        Plot Quantification Paliers                      %
% ------------------------------------------------------------------------%


Fig7=figure(7);
set(Fig7,'name','Quantification Paliers')
title('Quantification : Paliers'); axis([-2^nE, 2^nE -2^nE, 2^nE]);
hold on;
plot(-2^(nE+1)+2^(-nF):2*(2^(nE+1)-2^(-nF)):2^(nE+1)-2^(-nF),Palier,'c');
plot(U,Escalier,'m')
hold off;


%-------------------------------------------------------------------------%
%                      Plot Quantification Coefficients                   %
% ------------------------------------------------------------------------%

Fig8=figure(8);
set(Fig8,'name','Quantification Coeffs')

subplot(1,3,1)
hold on;
plot(0:LB+1:LB+1,Palier,'c')
plot(1:LB,SOS_B,'bo',1:LB,SOS_B_Q,'r.')
hold off;
title('Quantification Coeff B')
axis([0 LB+1 Min_Coeff, Max_Coeff]);

subplot(1,3,2)
hold on;
plot(0:LC+1:LC+1,Palier,'c')
plot(1:LC,SOS_C,'bo',1:LC,SOS_C_Q,'r.')
hold off;
title('Quantification Coeff C')
axis([0 LC+1 Min_Coeff, Max_Coeff]);

subplot(1,3,3)
hold on;
plot(0:LE+1:LE+1,Palier,'c')
plot(1:LE,SOS_E,'bo',1:LE,SOS_E_Q,'r.')
hold off
title('Quantification Coeff E')
axis([0 LE+1 Min_Coeff, Max_Coeff]);


end

