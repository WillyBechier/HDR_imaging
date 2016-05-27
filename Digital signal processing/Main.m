clear all;
close all;

fe=2000;
f_axis=0:2/fe:1;
f_log =logspace(0,3,1000)*2/fe;
N=500;

wp=[280*2/fe 560*2/fe];                                                     % Borne passante BF
ws=[200*2/fe 600*2/fe];                                                     % Borne atténuée BF
rp=0.1;                                                                     % 0.1dB ripple
rs=10;                                                                      % Attenuation
GainPlateau=-20;

Fideal=[0 200 280 560 600 fe/2]*2/fe;                                       % Fréquences de coupure
Mnormalized=[0 0 1 1 0 0];                                                  % Amplitude normalisée
Mideal=[-30 -30 -20 -20 -30 -30];

F1=[0 200 200 280 560 600 600 fe/2]*2/fe;                                   % Fréquences Borne sup
F2=[0 200 280 280 560 560 600 fe/2]*2/fe;                                   % Fréquence Borne inf
M1=[-30 -30 -20 -20 -20 -20 -30 -30];                                       % GdB Borne sup
M2=[-30 -30 -30 -20.1 -20.1 -30 -30 -30];  

nE=3;                                                                       % Partie entière    2^0     2^1     2^2
nF=1:9;                                                                     % Partie franction  2^-1    2^-2    2^-3
nW=1+nE+nF;                                                                 % Longueur du mot
Length_nF=length(nF);                                                       % nb de nF testés

%-------------------------------------------------------------------------%
%  Fig1                          FIR-Filter                               %
%                                                                         %
%                                                                         %
%  Plot le gabarit avec le filtre idéal, puis avec le FIR-Filter.         %
%  On filtre ensuite un bruit blanc.                                      %
%                                                                         %
%  Input : N,fe,F1,F2,M1,M2,Fideal,Mnormalized,Mideal                     %
%  Output: B_ideal,Hideal,W                                               %
%-------------------------------------------------------------------------%

[Bideal,Hideal,W]=FIR_Filter(N,fe,F1,F2,M1,M2,Fideal,Mnormalized,Mideal);

%-------------------------------------------------------------------------%
%  Fig2       IIR-Filter : Butterworth - Tchebychev - Elliptique          %
%                                                                         %
%                                                                         %
%  Plot le gabarit avec le filtre de Butterworth, Tchebychev, Elliptique  %
%                                                                         %
%  Input : N,fe,F1,F2,M1,M2,W,GainPlateau,wp,ws,rp,rs                     %
%  Output: H_Butterworth,H_Tchebychev,H_Elliptique,                       %
%          N_Butterworth,B_Butterworth,A_Butterworth,                     %
%          Z_Butterworth,P_Butterworth,G_Butterworth,                     %
%          N_Tchebychev,B_Tchebychev,A_Tchebychev,                        %
%          Z_Tchebychev,P_Tchebychev,G_Tchebychev,                        %
%          N_Elliptique,B_Elliptique,A_Elliptique,                        %
%          Z_Elliptique,P_Elliptique,G_Elliptique                         %
%-------------------------------------------------------------------------%

[H_Butterworth,H_Tchebychev,H_Elliptique,~,B_Butterworth,A_Butterworth,Z_Butterworth,P_Butterworth,G_Butterworth,~,B_Tchebychev,A_Tchebychev,Z_Tchebychev,P_Tchebychev,G_Tchebychev,~,B_Elliptique,A_Elliptique,Z_Elliptique,P_Elliptique,G_Elliptique] = IIR_Filter( N,fe,F1,F2,M1,M2,W,GainPlateau,wp,ws,rp,rs);

%-------------------------------------------------------------------------%
%  Fig3             Decompositon en filtres du 2nd ordre                  %
%                                                                         %
%  Input : B_Butterworth,A_Butterworth,                                   %
%          B_Tchebychev,A_Tchebychev,                                     %
%          B_Elliptique,A_Elliptique,                                     %
%          W,H_Butterworth,H_Tchebychev,H_Elliptique                      %
%  Output: SOS_B,G_B,LB,SOS_C,G_C,LC,SOS_E,G_E,LE,                        %
%          ZB2,PB2,ZC2,PC2,ZE2,PE2,KB2,KC2,KE2                            %
%          Z_Butterworth,P_Butterworth,G_Butterworth,                     %
%-------------------------------------------------------------------------%

[SOS_B,G_B,LB,SOS_C,G_C,LC,SOS_E,G_E,LE,ZB2,PB2,ZC2,PC2,ZE2,PE2,KB2,KC2,KE2]=TF2SOS_Function(B_Butterworth,A_Butterworth,B_Tchebychev,A_Tchebychev,B_Elliptique,A_Elliptique,W,H_Butterworth,H_Tchebychev,H_Elliptique);

%-------------------------------------------------------------------------%
%  Fig4        Triangle de Stabilité, Cercle unité (Poles,Zeros)          %
%                                                                         %
%  Input : SOS_B,SOS_C,SOS_E,ZB2,PB2,ZC2,PC2,ZE2,PE2                      %
%          W,H_Butterworth,H_Tchebychev,H_Elliptique                      %
%  Output:                                                                %
%-------------------------------------------------------------------------%

StabilityTriangle_UnitCircle(SOS_B,SOS_C,SOS_E,ZB2,PB2,ZC2,PC2,ZE2,PE2);

%-------------------------------------------------------------------------%
%  Fig5                IIR-Filter à minimum de phase                      %
%                                                                         %
%  Input : SOS_B,SOS_C,SOS_E,ZB2,ZC2,ZE2,PB2,PC2,PE2,KB2,KC2,KE2,         %
%          H_Butterworth,H_Tchebychev,H_Elliptique,                       %
%          G_B,G_C,G_E,GainPlateau,W                                      %
%  Output: ZB2,ZC2,ZE2,PB2,PC2,PE2,                                       %
%          SOS_B_MinPhase,SOS_C_MinPhase,SOS_E_MinPhase                   %
% ------------------------------------------------------------------------%

[ZB2,ZC2,ZE2,PB2,PC2,PE2,SOS_B_MinPhase,SOS_C_MinPhase,SOS_E_MinPhase] = IIR_Min_Phase_Filter( SOS_B,SOS_C,SOS_E,ZB2,ZC2,ZE2,PB2,PC2,PE2,KB2,KC2,KE2,H_Butterworth,H_Tchebychev,H_Elliptique,G_B,G_C,G_E,GainPlateau,W);

%-------------------------------------------------------------------------%
%  Fig6   Triangle de Stabilité, Cercle unité     MinPhase Filter         %
%                                                                         %
%  Input : SOS_B_MinPhase,SOS_C_MinPhase,SOS_E_MinPhase,                  %
%          ZB2,ZC2,ZE2,PB2,PC2,PE2                                        %
% ------------------------------------------------------------------------%

StabilityTriangle_UnitCircle_MinPhase( SOS_B_MinPhase,SOS_C_MinPhase,SOS_E_MinPhase,ZB2,ZC2,ZE2,PB2,PC2,PE2 );

%-------------------------------------------------------------------------%
%  Fig7      Implantation de la Quantification à virgule fixe  nF=3       %
%  Fig8                 Quantification des coefficients                   %
%  Fig9            Comparaison FIR idéal - FIR quantifié nF=3             %
%                                                                         %
%  Input : SOS_B,SOS_C,SOS_E,G_B,G_C,G_E,LB,LC,LE,nE,nF                   %
%  Output: SOS_B_Q,SOS_C_Q,SOS_E_Q,G_B_Q,G_C_Q,G_E_Q                      %
% ------------------------------------------------------------------------%

[ SOS_B_Q,SOS_C_Q,SOS_E_Q ] =Quantization( SOS_B,SOS_C,SOS_E,G_B,G_C,G_E,LB,LC,LE,2,2 );
Quantized_FIR( W,H_Butterworth,H_Tchebychev,H_Elliptique,GainPlateau,SOS_B_Q,SOS_C_Q,SOS_E_Q,G_B,G_C,G_E );

%-------------------------------------------------------------------------%
%  Fig10              Effet de nF sur les Min_Phase_Filter                %
%  Fig11          Effet de nF sur la Réponse impulsionnelle               %
%                                                                         %
%  Input : nE,nF,Length_nF,GainPlateau,                                   %
%          SOS_B_MinPhase,SOS_C_MinPhase,SOS_E_MinPhase,                  %
%          G_B,G_C,G_E,LB,LC,LE                                           %
%  Output: SOS_B_Q3D,SOS_C_Q3D,SOS_E_Q3D,H_B_Q3D,H_C_Q3D,H_E_Q3D,W3D      %
% ------------------------------------------------------------------------%

[SOS_B_Q3D,SOS_C_Q3D,SOS_E_Q3D,H_B_Q3D,H_C_Q3D,H_E_Q3D,W3D] = Quantized_FIR_3D( nE,nF,Length_nF,GainPlateau,SOS_B_MinPhase,SOS_C_MinPhase,SOS_E_MinPhase,G_B,G_C,G_E,LB,LC,LE);

%-------------------------------------------------------------------------%
%  Fig12                  Effet de nF sur (a1,a2),Z,P                     %
%                                                                         %
%  Input : SOS_B_Q3D,SOS_C_Q3D,SOS_E_Q3D,nF,Length_nF                     %
%  Output: PB_Q3D,ZB_Q3D,PC_Q3D,ZC_Q3D,PE_Q3D,ZE_Q3D                      %
% ------------------------------------------------------------------------%

[PB_Q3D,ZB_Q3D,PC_Q3D,ZC_Q3D,PE_Q3D,ZE_Q3D] = StabilityTriangle_UnitCircle_Quant( SOS_B_Q3D,SOS_C_Q3D,SOS_E_Q3D,nF,Length_nF );

%-------------------------------------------------------------------------%
%  Fig13                  Effet de nF sur le TPG                          %
%                                                                         %
%  Input : H_B_Q3D,H_C_Q3D,H_E_Q3D,Length_nF,nF,W,fe                      % 
% ------------------------------------------------------------------------%

TPG_Quantization( H_B_Q3D,H_C_Q3D,H_E_Q3D,Length_nF,nF,W,fe )

