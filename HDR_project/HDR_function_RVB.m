function [ U3 ] = HDR_function_RVB( U2,lambda,alpha,L )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% P L O T       I M A G E  %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[M,N]=size(U2);             % taillee
epsilon =0.0001;            % evite de diviser par 0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% D E R I V A T I O N %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Lx=reshape(L,N*M,1);
LU2=reshape(U2,N*M,1);
diagI=ones(1,N*M);
I=(diag(sparse(diagI)));

 DxT=sparse(N*M,N*M);
 DxT(1:N*M+1:end)=-1;
 DxT(2:N*M+1:end)=1;
 Dx=DxT';
 
 DyT=sparse(N*M,N*M);
 DyT(1:N*M+1:end)=-1;
 DyT(N+1:N*M+1:end)=1;
 Dy=DyT';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% L A P L A C I E N     I N H O M O G E N E %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ax=sparse(N*M,N*M);
diagAx = zeros(1,N*M);
id = find((1:N*M)<(N*M-1));
diagAx(id) = 1./(abs(log10(Lx(id+1)./Lx(id))).^alpha+epsilon); 
Ax=(diag(sparse(diagAx)));

%Ay=sparse(N*M,N*M);
diagAy = zeros(1,N*M);
id = find((1:N*M)<(N*M-N));
diagAy(id) = 1./(abs(log10(Lx(id+N)./Lx(id))).^alpha+epsilon); 
Ay=(diag(sparse(diagAy)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%  I M A G E    F I N A L E   %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 Lg=DxT*Ax*Dx+DyT*Ay*Dy;
 U3=(I+lambda*Lg)\LU2; 
 U3=reshape(U3,M,N);


end

