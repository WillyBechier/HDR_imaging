function [ malade2 ] = PATHO2(signal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    I N I T I A L I S A T I O N    %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=length(signal);
signalOK=signal(1:ceil(N/2-1));
signalMAL=signal(ceil(N/2):end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%    H I S T O G R A M M E S   %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Longueur=30;
Hist0=hist(signalOK,Longueur);
Hist1=hist(signalMAL,Longueur);

E0=find(Hist0>20);
E1=find(Hist1>20);

Hist0=Hist0(E0); 
Hist1=Hist1(E1);

Longueur0=length(Hist0);
Longueur1=length(Hist1);

figure;
title('rouge=>malade    vert=>sain')
xlabel('n° echantillon');
ylabel('histogramme des signaux');
hold on;
plot(Hist1,'r');
plot(Hist0,'g');
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    N E Y M A N    P E A R S O N   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

abscisse0=0:ceil(Longueur0/2)-1;
abscisse1=0:ceil(Longueur1/2)-1;

s0=sqrt(sum((abscisse0).^2)/Longueur0);         % Variance signal sain
s1=sqrt(sum((abscisse1).^2)/Longueur1);         % Variance signal malade
 
PFA=10^(-10);                                   % Probabilité de fausse alarame
alpha=1-PFA;
seuil=chi2inv(alpha,Longueur1);                 % Seuil de test
T=(1/s0)^2*Longueur1*s1^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    T E S T    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (T-seuil<0)
    malade2=0;
else
    malade2=1;
end  

end