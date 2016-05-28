close all; clc;

V = VideoReader('visor_vehicule.mpg');          % Load Video
v = read(V);                                    % Read the Video

videoSource = vision.VideoFileReader('visor_vehicule.mpg','ImageColorSpace','Intensity','VideoOutputDataType','uint8');

detector = vision.ForegroundDetector(...
       'NumTrainingFrames', 2, ...
       'InitialVariance', 30*30);
   
blob = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);
   
shapeInserter = vision.ShapeInserter('BorderColor','Black');

   
   videoPlayer = vision.VideoPlayer();
while ~isDone(videoSource)
     frame  = step(videoSource);
     fgMask = step(detector, frame);
     bbox   = step(blob, fgMask);
     out    = step(shapeInserter, frame, bbox);
     step(videoPlayer, out);
end