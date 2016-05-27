 close all;
 clear all;

ImageOriginale=double(imread('image.jpg'));
L=double(rgb2gray(ImageOriginale));
figure;
imshow(uint8(ImageOriginale),[]);

D=size(ImageOriginale);
M=D(1);
N=D(2);

[UR2,UV2,UB2] = HDR_color( ImageOriginale );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   H D R      C O A R S E D      %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
alpha=2;
lambda=0.4;

%[UR3]=HDR_function_RVB(UR2,lambda,alpha,L);
%[UV3]=HDR_function_RVB(UV2,lambda,alpha,L);
%[UB3]=HDR_function_RVB(UB2,lambda,alpha,L);

[UR3]=wls(UR2,lambda,alpha,L);
[UV3]=wls(UV2,lambda,alpha,L);
[UB3]=wls(UB2,lambda,alpha,L);

Ucoarsed=cat(3,UR3(:,:), UV3(:,:),UB3(:,:));
figure;
imshow(uint8(Ucoarsed),[]);title('Ucoarsed : A=2 L=0.4');
imwrite(mat2gray(uint8(Ucoarsed)),'Coarsed.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%   H D R      M E D I U M      %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha=2;
lambda=0.01;

%[UR3]=HDR_function_RVB(UR2,lambda,alpha,L);
%[UV3]=HDR_function_RVB(UV2,lambda,alpha,L);
%[UB3]=HDR_function_RVB(UB2,lambda,alpha,L);

[UR3]=wls(UR2,lambda,alpha,L);
[UV3]=wls(UV2,lambda,alpha,L);
[UB3]=wls(UB2,lambda,alpha,L);

Umedium=cat(3,UR3(:,:), UV3(:,:),UB3(:,:));
figure;
imshow(uint8(Umedium),[]);title('Umedium : A=2 L=0.001');
imwrite(mat2gray(uint8(Umedium)),'Medium.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%   H D R      F I N E         %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
alpha=2; 
lambda=0.001; 

%[UR3]=HDR_function_RVB(UR2,lambda,alpha,L);
%[UV3]=HDR_function_RVB(UV2,lambda,alpha,L);
%[UB3]=HDR_function_RVB(UB2,lambda,alpha,L);

[UR3]=wls(UR2,lambda,alpha,L);
[UV3]=wls(UV2,lambda,alpha,L);
[UB3]=wls(UB2,lambda,alpha,L);

Ufine=cat(3,UR3(:,:), UV3(:,:),UB3(:,:));
figure;
imshow(uint8(Ufine),[]);title('Ufine : A=2 L=0.001');
imwrite(mat2gray(uint8(Ufine)),'Fine.png');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%% M U L T I      T O N E   %%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b=Ucoarsed;
d1=ImageOriginale-Ufine;
d2=Ufine-Umedium;
d3=Umedium-Ucoarsed;

figure;
subplot(2,2,1)
imshow(uint8(d1),[]);title('d1');
imwrite(mat2gray(uint8(d1)),'d1.png');

subplot(2,2,2)
imshow(uint8(d2),[]);title('d2');
imwrite(mat2gray(uint8(d2)),'d2.png');

subplot(2,2,3)
imshow(uint8(d3),[]);title('d3');
imwrite(mat2gray(uint8(d3)),'d3.png');

subplot(2,2,4)
imshow(uint8(b),[]);title('b');

detail1=uint8(b+3*d1+d2+d3);
detail2=uint8(b+5*d1+d2+d3);
smooth=uint8(b+1.25*d1+3*d2+5*d3);

figure;
imshow(detail1,[]);title('Detail boost');
imwrite(mat2gray(detail1),'Detail_boost_1.png');

figure;
imshow(detail2,[]);title('Detail boost ++');
imwrite(mat2gray(detail2),'Detail_boost_2.png');

figure;
imshow(smooth,[]);title('Smooth boost');
imwrite(mat2gray(smooth),'Smooth.png');




