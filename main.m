%% face recognition
function main
clc
close all
 
% created object of detected face
faceDetector = vision.CascadeObjectDetector;
 
% detected
FaceRecognition(faceDetector);
end
 
%% choose picture
function I = SelectPicture()
[FileName,PathName] = uigetfile('*.jpg', 'choose a picture');
if isequal(FileName,0)
    disp('no input picture?choose again')
    I = [];
else
    I = imread(fullfile(PathName,FileName));
end
end
 
%% recognition
function [I_faces, bbox] = GetFaces(faceDetector, I)
% recognize face
bbox = step(faceDetector, I);
 
%  creat shape to draw frame of face
if size(I, 3) == 1 % grey?insert white or black frame
    if mean(I(:)) > 128 % bright,black frame
        shapeInserter = vision.ShapeInserter();
    else % drak,white frame
        shapeInserter = vision.ShapeInserter('BorderColor','White');
    end
else % color, red frame
    shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 0 0]);
end
 
% draw frame
I_faces = step(shapeInserter, I, int32(bbox));
end
 
%% face reg in pic
function FaceRecognition(faceDetector)
% click mouse
    function BtnDownFcn(h, evt)
        FaceRecognition(faceDetector);
    end
 
% choose a picture
I = SelectPicture();
if isempty(I)
    return
end
 
% face reg
[I_faces, bbox] = GetFaces(faceDetector, I);
 
close all
% creat object
fig1 = figure;
pos1 = get(fig1,'Position');
set(fig1,'Position',[10 pos1(2:4)]);
set(fig1,'WindowButtonDownFcn',@BtnDownFcn);
 
% display
figure(fig1)
imshow(I_faces)
title('click the picture to continue')
for i = 1:size(bbox, 1)
    text(bbox(i, 1), bbox(i, 2), mat2str(i), 'color', 'r')
end
 
% detected
intbbox = int32(bbox);
for i = 1:size(intbbox, 1)
    xs = intbbox(i, 1);
    xe = xs + intbbox(i,3);
    ys = intbbox(i, 2);
    ye = ys + intbbox(i,4);
    
    % creat figure
    if rem(i, 16) == 1
        fig2 = figure; 
    end
    
    subplot(4, 4, rem(i-1, 16)+1)
    imshow(I(ys:ye, xs:xe, :))
    title(mat2str(i))
end
end