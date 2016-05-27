function [PB_Q3D,ZB_Q3D,PC_Q3D,ZC_Q3D,PE_Q3D,ZE_Q3D ] = StabilityTriangle_UnitCircle_Quant( SOS_B_Q3D,SOS_C_Q3D,SOS_E_Q3D,nF,Length_nF )

%-------------------------------------------------------------------------%
%                 Initialisation : Cercles et Triangles                   %
%-------------------------------------------------------------------------%
Fig12=figure(12);
set(Fig12,'name','Triangle de stabilité - Poles et Zeros');

subplot(2,3,1);hold on;
plot(-2:2,ones(1,5),'b',0:2,-1+(0:2),'b',-2:0,-1-(-2:0),'b','LineWidth',2);
title('Triangle de stabilité + (a1,a2)B');axis([-2 2 -2 2]);
xlabel('a1');ylabel('a2');axis([-2.5 2.5 -1.5 1.5]);

subplot(2,3,2);hold on;
plot(-2:2,ones(1,5),'m',0:2,-1+(0:2),'m',-2:0,-1-(-2:0),'m','LineWidth',2);
title('Triangle de stabilité + (a1,a2)E');axis([-2 2 -2 2]);
xlabel('a1');ylabel('a2');axis([-2.5 2.5 -1.5 1.5]);

subplot(2,3,3);hold on;
plot(-2:2,ones(1,5),'r',0:2,-1+(0:2),'r',-2:0,-1-(-2:0),'r','LineWidth',2);
title('Triangle de stabilité + (a1,a2)E');axis([-2 2 -2 2]);
xlabel('a1');ylabel('a2');axis([-2.5 2.5 -1.5 1.5]);

subplot(2,3,4);title('Pôles(vert) Zeros(noir) du filtre de Butterworth');
xlabel('\Reeal');ylabel('\Immaginary');axis([-2 2 -1.5 1.5]);hold on;
plot(exp(1i*2*pi*(0:0.0001:2*pi)),'b','LineWidth',2);

subplot(2,3,5);title('Pôles(vert) Zeros(noir) du filtre de Tchebychev');
xlabel('\Reeal');ylabel('\Immaginary');axis([-2 2 -1.5 1.5]);hold on;
plot(exp(1i*2*pi*(0:0.0001:2*pi)),'m','LineWidth',2);

subplot(2,3,6);title('Pôles(vert) Zeros(noir) du filtre Elliptique');
xlabel('\Reeal');ylabel('\Immaginary');axis([-2 2 -1.5 1.5]);hold on;
plot(exp(1i*2*pi*(0:0.0001:2*pi)),'r','LineWidth',2);

%-------------------------------------------------------------------------%
%              Plot Poles / Zero / Coeff for differnt nF                  %
%-------------------------------------------------------------------------%

for i=nF
[ZB_Q3D(i,:),PB_Q3D(i,:)]=sos2zp(SOS_B_Q3D(:,:,i));
[ZC_Q3D(i,:),PC_Q3D(i,:)]=sos2zp(SOS_C_Q3D(:,:,i));
[ZE_Q3D(i,:),PE_Q3D(i,:)]=sos2zp(SOS_E_Q3D(:,:,i));    


subplot(2,3,1)
plot(SOS_B_Q3D(:,5,i),SOS_B_Q3D(:,6,i),'LineWidth',2,'color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1],'linestyle','.');

subplot(2,3,2)
plot(SOS_C_Q3D(:,5,i),SOS_C_Q3D(:,6,i),'LineWidth',2,'color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1],'linestyle','.');

subplot(2,3,3)
plot(SOS_E_Q3D(:,5,i),SOS_E_Q3D(:,6,i),'LineWidth',2,'color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1],'linestyle','.');

subplot(2,3,4);
plot(unique(PB_Q3D(i,:)),'LineWidth',2,'linestyle','.','color',[0.8-i*0.8/Length_nF+0.1,1,0.8-i*0.8/Length_nF+0.1]);
plot(unique(ZB_Q3D(i,:)),'LineWidth',2,'linestyle','.','color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1]);

subplot(2,3,5)
plot(unique(PC_Q3D(i,:)),'LineWidth',2,'linestyle','.','color',[0.8-i*0.8/Length_nF+0.1,1,0.8-i*0.8/Length_nF+0.1]);
plot(unique(ZC_Q3D(i,:)),'LineWidth',2,'linestyle','.','color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1]); 

subplot(2,3,6);
plot(unique(PE_Q3D(i,:)),'LineWidth',2,'linestyle','.','color',[0.8-i*0.8/Length_nF+0.1,1,0.8-i*0.8/Length_nF+0.1]);
plot(unique(ZE_Q3D(i,:)),'LineWidth',2,'linestyle','.','color',[0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1,0.8-i*0.8/Length_nF+0.1]);
end;
hold off;


end

