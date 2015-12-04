function [imArray, targets] = kanaTrain_dataset(dirnames, extension, numCharacters)
%% APPLY AFFINE TRANSFORMATION
%    Constructs an array that corresponds to random affine transformations
%    applied to images located in the specified directories.
%    
%    imArray: 1D array that contains all the transformed images, such that
%    imArray{i} gets the ith images stored.
%    
%    Requires that all of images have the same extension (specified with an
%    intial '.'

%% Iterate through each directory
% For each directory, get all of its images and apply affine
% transformations to them.
m = length(dirnames);
imArray = {};
targets = [];
for k = 1:m
    dirname = dirnames{k};
    images = dir(strcat(dirname, '/*.', extension));
    n = length(images);
    numExtraTransforms = 1;
    arrayLength = (1+numExtraTransforms)*length(images);
    
    %% Apply random transformations
    %Iterate through each image in this directory, and apply a series of
    %affine transformations to it.
    for i = 1:n
        name = getfield(images(i), 'name');
        bitmap = im2double(imread(strcat(dirname,'/',name)));
        
        % Add the original, unmodified version of the image to the array,
        % as well as its inversion.
        imArray = [imArray bitmap];
        t1 = zeros(numCharacters, 1);
        t1(i) = 1;
        targets = [targets t1];
        for j = 1:numExtraTransforms
            %Apply a small random translation
            rx = randi([-2,2]);
            ry = randi([-2,2]);
            transformedImage = imtranslate(bitmap, [rx,ry], 'FillValues', 1);
            imArray = [imArray transformedImage];
            
            %Add target for this transformation
            t2 = zeros(numCharacters, 1);
            t2(i) = 1;
            targets = [targets t2];
        end
    end
    
end

% Display transformed images.
% for i = 1:49
%     subplot(7,7,i);
%     imshow(imArray{i+100});
% end