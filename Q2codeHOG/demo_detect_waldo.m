%% Detect Waldo in a simple example

addpath utils

% read waldo image
wim = imread('../cropped_kana/a.jpg');
wim = cat(3, wim,wim, wim);

% resize image (resizing waldo is important, 
% try with differnet resize ratios (e.g. 0.05, 0.1, 0.15) to see the effect)
wim=imresize(wim,1); 

size(wim)

% extract hog features,
% and create a filter from hog features
wim2 = imread('../individual_kana/yo.jpg');
wim2 = cat(3, wim2, wim2, wim2);
size(wim2)
waldo_hog = hog(wim);
waldo_filter = get_hog_filter(waldo_hog);

% read search image and extract hog features
search_im = wim2;
image_hog = hog(search_im);

% obtain top K localizations of waldo in the example image 
topK = 5;
[bboxes, heatmap] = detect_object(image_hog,waldo_filter,topK);

% visualize detections
figure(1)
subplot(1,5,1);
imshow(wim);
title('Target Object','FontSize',16);
subplot(1,5,2);
imshow(search_im);
title('Search Image','FontSize',16);
subplot(1,5,3);
imshow(heatmap);
title('Heatmap','FontSize',16);
subplot(1,5,4);
showboxes(search_im,bboxes(1,:))
title('Best Detection','FontSize',16);
subplot(1,5,5);
showboxes(search_im,bboxes(1:5,:))
title('Top 5 detections','FontSize',16);

bboxes(1,:)


