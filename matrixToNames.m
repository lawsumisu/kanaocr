function [classifiedNames] = matrixToNames(matrix, kanaNames)
%Kana Character Recognition problem definition
%  [KANA,TARGETS] = KANAPD()
%  Returns:
%    KANA - 88xN matrix of 8x11 bitmaps for each kana, where N is
%           the number of images in the 'kana_bitmaps' directory.
%    TARGETS  - NxN target vectors.
%    kanaNames - the names corresponding to the kana at each column\
classifiedNames = {};
for i = 1:length(matrix(1, :))
    n = find(matrix(:, i));
    classifiedNames = [classifiedNames kanaNames(n)]; 
end