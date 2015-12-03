%% Detect Waldo in the crowd

addpath utils
close all;

% read waldo image
wim = imread('single_waldo_half.jpg');
wim=imresize(wim,0.15); 

% extract hog features,
% and create a filter from hog features
waldo_hog = hog(wim);
waldo_filter = get_hog_filter(waldo_hog);

% read search image and extract hog features
search_im = imread('crowd2.jpg');
image_hog = hog(search_im);

% obtain top K localizations of waldo in the example image 
topK = 10;
[bboxes, heatmap] = detect_object(image_hog,waldo_filter,topK);

bb = bboxes(1,1:4);
detected_waldo_im = search_im(bb(2):bb(4),bb(1):bb(3),:);

% visualize detections
figure(1)
subplot(1,2,1);
imshow(wim);
title('Target Object','FontSize',16);
subplot(1,2,2);
imshow(detected_waldo_im);
title('Detected Object','FontSize',16);

figure(2)
showboxes(search_im,bboxes(1,:))
title('Best Detection','FontSize',16);


