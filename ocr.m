I = im2double(imread('test.png'));

%Binarization
%turn image into black and white
BW = im2bw(I, 0.9);
inv_BW = 1-BW;
imshow(I);
figure, imshow(BW);

%Segmentation

row_start = [];
row_end = [];
%horizontal pixel scan, find top/bottom of each row (any row with a black pixel)
BW_row_sum = sum(inv_BW,2);
flag = 0;

for n=1:length(BW_row_sum)
    if flag==0 && BW_row_sum(n)~=0
        row_start = [row_start n];
        flag = 1;
    elseif flag~=0 && BW_row_sum(n)==0
        row_end = [row_end n-1];
        flag = 0;
    end
end
% edge case, if row ends at bottom of image, need to save final row_end
% index
if BW_row_sum(length(BW_row_sum))>0
    row_end = [row_end length(BW_row_sum)];
end

%per row: vertical scan, find left/right of each character (any column with a single black pixel)
BW_col_sum = sum(inv_BW);

%Character recognition
%