function [ ] = TPG_Quantization( H_B_Q3D,H_C_Q3D,H_E_Q3D,Length_nF,nF,W,fe )


Derivee_B=zeros(511,511,Length_nF);
Derivee_C=zeros(511,511,Length_nF);
Derivee_E=zeros(511,511,Length_nF);

for i=nF
Phase_B = unwrap(2*angle(H_B_Q3D(:,:,:)))/2;
Phase_C = unwrap(2*angle(H_C_Q3D(:,:,:)))/2;
Phase_E = unwrap(2*angle(H_E_Q3D(:,:,:)))/2;

DiffPhase_B=diff(Phase_B,1,1); DiffPhase_B=diff(DiffPhase_B,1,2);
DiffPhase_C=diff(Phase_C,1,1); DiffPhase_C=diff(DiffPhase_C,1,2);
DiffPhase_E=diff(Phase_E,1,1); DiffPhase_E=diff(DiffPhase_E,1,2);

Derivee_B(:,:,i)  =DiffPhase_B(:,:,i).*(diff(W)*fe/(2*pi)*ones(1,511));
Derivee_C(:,:,i)  =DiffPhase_C(:,:,i).*(diff(W)*fe/(2*pi)*ones(1,511));
Derivee_E(:,:,i)  =DiffPhase_E(:,:,i).*(diff(W)*fe/(2*pi)*ones(1,511));

end;

TPG_B = -1/(2*pi)*Derivee_B;
TPG_C = -1/(2*pi)*Derivee_C;
TPG_E = -1/(2*pi)*Derivee_E;

 
 
Fig13=figure(13);
set(Fig13,'name','Phase')

for i=nF
subplot(1,3,1);
plot3(i*ones(512,1),(1:512)*fe/512,Phase_B(1:512,i),'linewidth',2,'color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,1]);
title('Phase Butterworth');xlabel('f(Hz)');ylabel('temps(s)');grid on;hold on;

subplot(1,3,2);
plot3(i*ones(512,1),(1:512)*fe/512,Phase_C(1:512,i),'linewidth',2,'color',[1,0.8-i*0.8/Length_nF+0.1,1]);
title('Phase Tchebychev');xlabel('f(Hz)');ylabel('temsp(s)');grid on;hold on;

subplot(1,3,3);
plot3(i*ones(512,1),(1:512)*fe/512,Phase_E(1:512,i),'linewidth',2,'color',[1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1]);
title('Phase Elliptique');xlabel('f(Hz)');ylabel('temps(s)');grid on;hold on;
end;hold off;


Fig14=figure(14);
set(Fig14,'name','Temps de propagation')

for i=nF
subplot(1,3,1);
plot3(i*ones(511,1),(1:511)*fe/511,TPG_B(1:511,i),'linewidth',2,'color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,1]);
title('TPG Butterworth');xlabel('nF');ylabel('f(Hz)');zlabel('TPG(s)');grid on;hold on;

subplot(1,3,2);
plot3(i*ones(511,1),(1:511)*fe/511,TPG_C(1:511,i),'linewidth',2,'color',[1,0.8-i*0.8/Length_nF+0.1,1]);
title('TPG Tchebychev');xlabel('nF');ylabel('f(Hz)');zlabel('TPG(s)');grid on;hold on;

subplot(1,3,3);
plot3(i*ones(511,1),(1:511)*fe/511,TPG_E(1:511,i),'linewidth',2,'color',[1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1]);
title('TPG Elliptique');xlabel('nF');ylabel('f(Hz)');zlabel('TPG(s)');grid on;hold on;
end
hold off;

end

