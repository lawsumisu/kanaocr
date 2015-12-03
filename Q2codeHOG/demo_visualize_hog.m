%% Visualize multi-scale hog features 

addpath utils
close all

% read waldo image
wim = imread('single_waldo.jpg');

% extract hog features in multiple scales
wim1=imresize(wim,0.25);
waldo_hog1 = hog(wim1); 

wim2=imresize(wim,0.1);
waldo_hog2 = hog(wim2);

wim3=imresize(wim,0.05);
waldo_hog3 = hog(wim3);

% visualize multi-scale features 
figure(1)
subplot(1,4,1);
imshow(wim);
title('Waldo Image');
subplot(1,4,2);
visualizeHOG(waldo_hog1)
title('x 0.25');
subplot(1,4,3);
visualizeHOG(waldo_hog2)
title('x 0.10');
subplot(1,4,4);
visualizeHOG(waldo_hog3)
title('x 0.05');


