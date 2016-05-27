 close all;
 clear all;

ImageOriginale=imread('image.jpg');
L=double(rgb2gray(ImageOriginale));
imwrite(uint8(L),'ImageOriginale.png')
D=size(ImageOriginale);
M=D(1);
N=D(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   H D R      C O A R S E D      %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
alpha=2;
lambda=0.4;

[Ucoarsed]=wls(L,lambda,alpha);
%[Ucoarsed,L]=HDR_function_BW(L,lambda,alpha);
figure;
imshow(Ucoarsed,[]);title('Ucoarsed : A=2 L=0.4');
imwrite(mat2gray(Ucoarsed),'Coarsed.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%   H D R      M E D I U M      %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha=2;
lambda=0.01;

[Umedium]=wls(L,lambda,alpha);
%[Umedium,L]=HDR_function_BW(L,lambda,alpha);
figure;
imshow(Umedium,[]);title('Umedium : A=2 L=0.01');
imwrite(mat2gray(Umedium),'Medium.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%   H D R      F I N E         %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
alpha=2; 
lambda=0.001; 

[Ufine]=wls(L,lambda,alpha);
%[Ufine,L]=HDR_function_BW(L,lambda,alpha);
figure;
imshow(10*Ufine,[]);title('Ufine : A=2 L=0.001');
imwrite(mat2gray(Ufine),'Fine.png');
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% M U L T I      T O N E   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b=Ucoarsed;
d1=L-Ufine;
d2=Ufine-Umedium;
d3=Umedium-Ucoarsed;

figure;
subplot(2,2,1)
imshow(d1,[]);title('d1=detail fin');
subplot(2,2,2)
imshow(d2,[]);title('d2=detail medium');
subplot(2,2,3)
imshow(d3,[]);title('d3=detail faible');
subplot(2,2,4)
imshow(d3,[]);title('b=Smooth');
imwrite(mat2gray(d1),'d1.png');
imwrite(mat2gray(d2),'d2.png');
imwrite(mat2gray(d3),'d3.png');

figure;
imshow(L,[]);title('Image Originale');

figure;
imshow(b+d1+d2+d3,[]);title('IO = b+d1+d2+d3');

detail1=uint8(b+3*d1+d2+d3);
detail2=uint8(b+5*d1+d2+d3);
smooth=uint8(b+0.1*d1+0.2*d2+5*d3);

figure;
imshow(detail1,[]);title('Detail boost');
imwrite(mat2gray(detail1),'Detail_boost_1.png');

figure;
imshow(detail2,[]);title('Detail boost ++');
imwrite(mat2gray(detail2),'Detail_boost_2.png');

figure;
imshow(smooth,[]);title('Smooth boost');
imwrite(mat2gray(smooth),'Smooth_boost.png');




