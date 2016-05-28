close all; clc;

V = VideoReader('visor_vehicule.mpg');          % Load Video
v = read(V);                                    % Read the Video
BG = v(:,:,:,34);                               % Set the background
figure;hold on;
Frame_start=1;                                  % 850 is ok
Frame_end=1200;                                 % 1000 is ok
N_m=zeros(Frame_end-Frame_start+1,1);    

for i=Frame_start:Frame_end                     % Video frames
    FRAME=v(:,:,:,i);                           % Select the current frame

    BW = im2bw(BG-FRAME,0.2);                   % Current Object/Background
    BW = imerode(BW,strel('disk',3));           % Expand BG (single pixels off)
    BW = imdilate(BW,strel('disk',16));         % Expand Object (fuse patchs)
    BW_contour = bwmorph(BW,'remove');          % Outline the object
    [L,N_mobile] = bwlabel(BW);                 % Discriminates objects
    TARGET=FRAME;                               % Initiate the Target Image
    TARGET(:,:,2)=TARGET(:,:,2)+70*uint8(BW);   % Highlight the objects
    N_m(i)=N_mobile;
    
   subplot(1,2,1);                              % Highlighted Object
   imshow(TARGET);
   title(['Nombre de mobiles = ',num2str(N_mobile)])
   
   subplot(1,2,2)                               % Display the current frame
   imshow(FRAME);                               % Frame the objects
   for n=1:N_mobile
     [rowL,colL]=find(L==n); 
     x=min(colL);
     y=min(rowL);
     w=max(colL)-x;
     h=max(rowL)-y;
     rectangle('Position',[x,y,w,h]);
   end
   title(['Nombre de mobiles = ',num2str(N_mobile)])
  
   snapnow;
   
end;

figure;
plot(N_m,'r','linewidth',2);
title('Evolution of the number of mobiles');
xlabel('Frame');ylabel('Number of mobiles');
