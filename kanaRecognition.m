function [kana, confidences] = kanaHOG(imarray)
addpath Q2codeHOG/utils
images = dir('cropped_kana/*.jpg');
confidences= zeros(1, length(imarray));
kana = repmat({''}, 1, length(imarray));
for i = 1:length(imarray)
    %Run hog on each character for each bound in the array.
    search_im = imarray{i};
    search_im = cat(3, search_im, search_im, search_im);
    
    for j=1:length(images)
        name = getfield(images(j), 'name');
        [I, map] = imread(strcat('cropped_kana/',name));
        
        % read waldo image
        wim = cat(3, I, I,I);

        % resize image (resizing waldo is important, 
        % try with differnet resize ratios (e.g. 0.05, 0.1, 0.15) to see the effect)
        wimSize = size(wim);
        searchImSize = size(search_im);
        ratio = min(searchImSize(1)/wimSize(1), searchImSize(2)/wimSize(2));
        wim=imresize(wim,ratio);
        
        wimSize = size(wim);
        searchImSize = size(search_im);
        if wimSize(1) > searchImSize(1);
            wim= wim(1:searchImSize(1),:,:);
        end
        if wimSize(2) > searchImSize(2);
            wim=wim(:,1:searchImSize(2),:);
        end
        
%         size(wim)
%         size(search_im)
%         name
        % extract hog features,
        % and create a filter from hog features
        waldo_hog = hog(wim);
        waldo_filter = get_hog_filter(waldo_hog);

        % read search image and extract hog features
        image_hog = hog(search_im);

        % obtain top K localizations of waldo in the example image 
        topK = 5;
        [bboxes, heatmap] = detect_object(image_hog,waldo_filter,topK);
       
        if confidences(i) < bboxes(1, 5)            
            confidences(i) = bboxes(1,5);
            kana{i} = name;
        end
        %visualize detections
%         figure(1)
%         subplot(1,5,1);
%         imshow(wim);
%         title('Target Object','FontSize',16);
%         subplot(1,5,2);
%         title('Search Image','FontSize',16);
%         subplot(1,5,3);
%         imshow(heatmap);
%         title('Heatmap','FontSize',16);
%         subplot(1,5,4);
%         showboxes(search_im,bboxes(1,:))
%         title('Best Detection','FontSize',16);
%         subplot(1,5,5);
%         showboxes(search_im,bboxes(1:5,:))
%         title('Top 5 detections','FontSize',16);
    
        
        
    end
end