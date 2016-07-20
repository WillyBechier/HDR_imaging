function [ malade3 ] = PATHO3(Signal,Fs, QRS_buff_on, QRS_loc, QRS_width_buff )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    I N I T I A L I S A T I O N    %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=length(QRS_loc);
Distance=zeros(1,N-1);
Good=zeros(1,N-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%    E S P A C E M E N T    I N T E R - P I C    %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:N-1
Distance(i)=QRS_loc(i+1)-QRS_loc(i);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    S E U I L    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tolerance=0.1;

Regular=mean(Distance(1:8));
RegularVector=Regular*ones(1,N-1);
SeuilH=(Regular*(1+Tolerance))*ones(1,N-1);
SeuilB=(Regular-20*(1-Tolerance))*ones(1,N-1);
Ecart=abs(Regular-Distance);

for i=1:N-1
    if( (Distance(i)<SeuilH(i))  & (Distance(i)>SeuilB(i)) )   
        Good(i)=1;
    else
        Good(i)=0;
    end
end

Good=Good'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    P L O T    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
title('Ecart Inter-Battement (bleu), moyenne état sain (cyan), Tolérance (rouge)');
hold on;
xlabel('n° des pics')
ylabel('écart entre pics')
plot(Distance,'b');
plot(RegularVector,'c');
plot(SeuilB,'r');
plot(SeuilH,'r');
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    T E S T    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (mean(Good)<0.5)
    malade2=0;
else
    malade2=1;
end  



malade3=1;



end