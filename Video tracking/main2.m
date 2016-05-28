close all; clc;

V=VideoReader('visor_vehicule.mpg');
v=read(V);
BG = v(:,:,:,34);
Threshold_low=2;
Threshold_high=70;
figure;hold on;

for i=850:1000
    
    I1=im2bw(BG-v(:,:,:,i),0.2);                % Current frame
    I2=im2bw(BG-v(:,:,:,i+1),0.2);              % Next frame

    points1 = detectSURFFeatures(I1);           % Detect current SURF features
    points2 = detectSURFFeatures(I2);           % Detect next SURF features

   [f1, vpts1] = extractFeatures(I1, points1);  % Extract the features.
   [f2, vpts2] = extractFeatures(I2, points2);  % Extract the features.


   indexPairs = matchFeatures(f1, f2) ;         % Pairs of matched points
   MP1 = vpts1(indexPairs(:,1));                % Retrieve the locations of current matched points.
   MP2 = vpts2(indexPairs(:,2));                % Retrieve the locations of next matched points.

   
   M1= MP2.Location(:,1) - MP1.Location(:,1);   % Horizontal velocity
   F=find((Threshold_low<abs(M1)) & (abs(M1)<Threshold_high)); % Threshold Inf & Sup

   MPLoc1 = MP1.Location(F,:);                  % Locations of selected current matched points
   MPLoc2 = MP2.Location(F,:);                  % Locations of selected next matched points

   
   showMatchedFeatures(I1,I2,MP1,MP2,'Parent',ax); % Show movement vectors of the match points
   snapnow;
end;