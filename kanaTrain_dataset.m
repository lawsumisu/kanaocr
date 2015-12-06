function [imArray, targets] = kanaTrain_dataset(dirnames, extension)
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
    numExtraTransforms = 40;
    
    %% Apply random transformations
    %Iterate through each image in this directory, and apply a series of
    %affine transformations to it.
    for i = 1:n
        name = getfield(images(i), 'name');
        bitmap = 1- im2double(imread(strcat(dirname,'/',name)));
        
        % Add the original, unmodified version of the image to the array
        imArray = [imArray bitmap];
        t1 = zeros(n, 1);
        t1(i) = 1;
        targets = [targets t1];
        
        for j = 1:numExtraTransforms
            %Apply a small random translation
            rx = randi([-3,3]);
            ry = randi([-3,3]);
            transformedImage = imtranslate(bitmap, [rx,ry], 'FillValues', 0);
            imArray = [imArray transformedImage];
            
            %Add target for this transformation
            targets = [targets t1];
            
            % Apply a small random rotation.
            rTheta = randi([-30,30]);
            rotatedImage = imrotate(transformedImage, rTheta, 'crop');
            imArray = [imArray rotatedImage];
            targets = [targets t1];   
            
            %Apply a small random horizontal or vertical skew.
            rMin = -.4;
            rMax = .4;
            xy = (rMax-rMin)*rand(1) + rMin;
            skew = eye(3);
            coinFlip = randi([0,1]);
            if (coinFlip)
                skew(2,1) = xy;
            else
                skew(1,2) = xy;
            end          
            T = affine2d(skew);
            skewedImage = imwarp(transformedImage, T);
            
            %Need to crop skewed image if it is too large.
            dim = size(skewedImage);
            xCoordinate = max(floor(dim(2)/2-15),1);
            yCoordinate = max(floor(dim(1)/2-15),1);
            skewedImage = imcrop(skewedImage, [xCoordinate yCoordinate 29 29]);
            imArray = [imArray skewedImage];
            targets = [targets t1];
        end
    end
    
end