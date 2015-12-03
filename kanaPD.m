function [kana,targets, kanaNames] = kanaPD(dirname, filetype)
%Kana Character Recognition problem definition
%  [KANA,TARGETS] = KANAPD()
%  Returns:
%    KANA - 88xN matrix of 8x11 bitmaps for each kana, where N is
%           the number of images in the 'kana_bitmaps' directory.
%    TARGETS  - NxN target vectors.
%    kanaNames - the names corresponding to the kana at each column
images = dir(strcat(dirname, '/*.', filetype));
n = length(images);
kana = zeros(88,n);
kanaNames = {};
targets = eye(n);
for i = 1:n
    name = getfield(images(i), 'name');
    kanaNames = [kanaNames name];
    bitmap = im2double(imread(strcat(dirname,'/',name)));
    %Invert image so that 1 corresponds to black pixels and 0 corresponds
    %to white pixels.
    k = 1 - im2bw(bitmap);
    kana(:,i)= reshape(k,88,1);   
end