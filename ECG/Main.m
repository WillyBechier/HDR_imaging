clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% C H O O S E   E C G   P A T H O L O G Y  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%load('ECG_PATHO1.mat');         % Dilatation QRS
%load('ECG_PATHO2.mat');         % Disparition QRS => Sinusoide
load('ECG_PATHO3.mat');         % Battements irréguliers
%load('ECG_PATHO4.mat');         %  
%load('ECG60_2.mat');            % ECG Sain
%[ ecg , Fs] = ECGvirtuel();     % ECG synthetique


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  I N I T I A L I S A T I O N    F I G U R E  %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L=length(ecg);
figure(1);                              % Signaux temporels
figure(2);                              % Periodogrammes
%PeriodoCorrelo(ecg,Fs);                 % Plot Periodo(ecg),Correlo(ecg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  E T A P E S     D E    F I L T R A G E  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Signal_ecg     ] =AnalyseSecteur(ecg,Fs,60,0.1); % 'green'     notch
[hp_ecg b1 b2 b3] =AnalyseBande(Signal_ecg,Fs);   % 'red'       band-pass
[deriv_ecg b4   ] =AnalyseDeriv(hp_ecg,Fs);       % 'magenta'   deriv
[square_ecg     ] =AnalyseSquare(deriv_ecg,Fs);   % 'black'     square
[moy_ecg b5     ] =AnalyseGliss(square_ecg,Fs);   % 'cyan'      gliss

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  Q R S     C O M P L E X     D E T E C T I O N  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[QRS_loc,QRS_width_buff,QRS_buff_on,QRS_buff_off]=peak_features(moy_ecg,b1,b2,b3,b4,b5,Signal_ecg,Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  S I G N A L    H O L E   F I L L I N G %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Plage=1446:1458;
% Plage=1463:1473;
% Iteration=40;
% Signal_restaure=Papoulis( Signal_ecg , Fs ,Plage, Iteration);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  P A T H O L O G Y    D E T E C T I O N %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%[ malade1 ] = PATHO1(QRS_width_buff);
%[ malade2 ] = PATHO2(deriv_ecg );
[ malade3 ] = PATHO3(ecg,Fs, QRS_buff_on, QRS_loc ,QRS_width_buff );

%maladie=[maladie1 maladie2 maladie3]
