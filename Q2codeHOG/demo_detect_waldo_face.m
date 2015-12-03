%% Detect the Face of Waldo

addpath utils
close all

% create waldo face filter
wim = imread('single_waldo.jpg');
wim = wim(120:471,380:779,:); % crop face region
FILTER_RESIZE_RATIO = 0.10;
wim=imresize(wim,FILTER_RESIZE_RATIO); % try different scales to see the effect
waldo_hog = hog(wim);
waldo_filter = get_hog_filter(waldo_hog);

% read search image, extract hog features, and perform detection
scales = [0.25 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.25];
confidences = zeros(10,2);
accumulatedBboxes = [];
bestBboxesWithinScales = []
for i = 1: length(scales)
    search_im = imresize(imread('waldo_face.jpg'), scales(i));
    imDim = size(search_im);
    image_hog = hog(search_im);
    topK = 5;
    [bboxes, heatmap] = detect_object(image_hog,waldo_filter,topK);
    
    image_hog = hog(search_im);
    [bboxes, heatmap] = detect_object(image_hog,waldo_filter,topK);

    % visualize
    figure(2);
    
    subplot(2,5,i);
    showboxes(search_im,bboxes(1:topK,:));
    %Scale bboxes so that when they are drawn on the original image, they
    %maintain their relative size.
    relativeDimensions = bboxes(:,1:4);
    relativeDimensions(:,1) = relativeDimensions(:,1)/imDim(1);
    relativeDimensions(:,2) = relativeDimensions(:,2)/imDim(2);
    relativeDimensions(:,3) = relativeDimensions(:,3)/imDim(1);
    relativeDimensions(:,4) = relativeDimensions(:,4)/imDim(2);
    accumulatedBboxes = [accumulatedBboxes; [relativeDimensions, bboxes(:,5)]];
    [maxConfidence, bestIndex] = max(bboxes(:,5));
    bestBboxesWithinScales = [bestBboxesWithinScales; bboxes(bestIndex, :)/scales(i)];
    title(strcat('Scale = ', num2str(scales(i))),'FontSize',16);
    
    % add data for plotting.
    confidences(i,1) = scales(i); 
    confidences(i,2) = max(bboxes(:, 5));
end

maxBoxes = [];
for j = 1:5
    %Get bbox with highest maximum, then remove all similar matches.
    [m, idx] = max(accumulatedBboxes(:,5));
    maxBoxes = [maxBoxes; accumulatedBboxes(idx,:)];
    remainingBboxes = [];
    area = rectint(accumulatedBboxes(idx,1:4), accumulatedBboxes(idx,1:4));
    for i = 1: length(accumulatedBboxes)
        intersection = rectint(accumulatedBboxes(i,1:4), accumulatedBboxes(idx,1:4));
        area2 = rectint(accumulatedBboxes(i,1:4), accumulatedBboxes(i,1:4));
        union = area + area2 - intersection;
        if intersection/union > .5
            continue;
        end
        remainingBboxes = [remainingBboxes; accumulatedBboxes(i,:)];
    end
    accumulatedBboxes = remainingBboxes;
end
im = imread('waldo_face.jpg');
imDim2 = size(im);
absoluteDimensions = maxBoxes(:,1:4);
absoluteDimensions(:,1) = absoluteDimensions(:,1)*imDim2(1);
absoluteDimensions(:,2) = absoluteDimensions(:,2)*imDim2(2);
absoluteDimensions(:,3) = absoluteDimensions(:,3)*imDim2(1);
absoluteDimensions(:,4) = absoluteDimensions(:,4)*imDim2(2);

figure(3);
showboxes(im, bestBboxesWithinScales);
figure(4);
showboxes(im,absoluteDimensions);



