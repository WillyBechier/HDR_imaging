function [ output_args ] = StabilityTriangle_UnitCircle_MinPhase( SOS_B,SOS_C,SOS_E,ZB2,ZC2,ZE2,PB2,PC2,PE2 )

%-------------------------------------------------------------------------%
%                 Position Coefficient dénominateurs                      %
%-------------------------------------------------------------------------%

Fig6=figure(6);
set(Fig6,'name','Triangle de stabilité - Poles et Zeros');

subplot(2,3,1)
hold on;
plot(-2:2,ones(1,5),'b',0:2,-1+(0:2),'b',-2:0,-1-(-2:0),'b','LineWidth',2);   % Triangle de stabilité T = {(a1,a2) | a2<1,a2>-1+a1,a2>-1-a1 }
plot(SOS_B(:,5),SOS_B(:,6),'k.','LineWidth',2);                                           % Plot tous les (a2,a1) de chaque filtre d'ordre 2
hold off;
title('Triangle de stabilité + (b1,b2)B');axis([-2 2 -2 2]);
xlabel('a1');ylabel('a2');axis([-2.5 2.5 -1.5 1.5]);
grid on;

subplot(2,3,2)
hold on;
plot(-2:2,ones(1,5),'m',0:2,-1+(0:2),'m',-2:0,-1-(-2:0),'m','LineWidth',2);   % Triangle de stabilité T = {(a1,a2) | a2<1,a2>-1+a1,a2>-1-a1 }
plot(SOS_C(:,5),SOS_C(:,6),'k.','LineWidth',2);                                           % Plot tous les (a2,a1) de chaque filtre d'ordre 2
hold off;
title('Triangle de stabilité + (a1,a2)C');axis([-2 2 -2 2]);
xlabel('a1');ylabel('a2');axis([-2.5 2.5 -1.5 1.5]);
grid on;

subplot(2,3,3)
hold on;
plot(-2:2,ones(1,5),'r',0:2,-1+(0:2),'r',-2:0,-1-(-2:0),'r','LineWidth',2);   % Triangle de stabilité T = {(a1,a2) | a2<1,a2>-1+a1,a2>-1-a1 }
plot(SOS_E(:,5),SOS_E(:,6),'k.','LineWidth',2);                                           % Plot tous les (a2,a1) de chaque filtre d'ordre 2
hold off;
title('Triangle de stabilité + (a1,a2)E');axis([-2 2 -2 2]);
xlabel('a1');ylabel('a2');axis([-2.5 2.5 -1.5 1.5]);
grid on;

%-------------------------------------------------------------------------%
%               Cercle unité et position Poles & Zeros                    %
%-------------------------------------------------------------------------%
 
subplot(2,3,4);title('Pôles(vert) Zeros(noir) du filtre MinPhase_{Butterworth}');
xlabel('\Reeal');ylabel('\Immaginary');axis([-2 2 -1.5 1.5]);grid on;
hold on;
plot(exp(1i*2*pi*(0:0.0001:2*pi)),'b','LineWidth',2);                       % Cercle unité
plot(PB2,'g.','LineWidth',2);                                     % Poles des filtres du 2nd ordre B
plot(ZB2,'k.','LineWidth',2);                                     % Zeros des filtres du 2nd ordre B
hold off;

subplot(2,3,5);title('Pôles(vert) Zeros(noir) du filtre MinPhase_{Tchebychev}');
xlabel('\Reeal');ylabel('\Immaginary');axis([-2 2 -1.5 1.5]);grid on;
hold on;
plot(exp(1i*2*pi*(0:0.0001:2*pi)),'m','LineWidth',2);                       % Cercle unité
plot(PC2,'g.','LineWidth',2);                                      % Poles des filtres du 2nd ordre B
plot(ZC2,'k.','LineWidth',2);                                      % Zeros des filtres du 2nd ordre B 
hold off;

subplot(2,3,6);title('Pôles(vert) Zeros(noir) du filtre MinPhase_{Elliptique}');
xlabel('\Reeal');ylabel('\Immaginary');axis([-2 2 -1.5 1.5]);grid on;
hold on;
plot(exp(1i*2*pi*(0:0.0001:2*pi)),'r','LineWidth',2);                       % Cercle unité
plot(PE2,'g.','LineWidth',2);                                      % Poles des filtres du 2nd ordre B
plot(ZE2','k.','LineWidth',2);                                      % Zeros des filtres du 2nd ordre B
hold off;




end

