I = im2double(imread('test.png'));

%Binarization
%turn image into black and white
BW = im2bw(I, 0.9);
imshow(I);
figure, imshow(BW);

%Segmentation

row_start = {}
%horizontal pixel scan, find top/bottom of each row (any row with a black pixel)
BW_row_sum = sum(BW,2);

%per row: vertical scan, find left/right of each character (any column with a single black pixel)
for 
BW_col_sum = sum(BW);

%Character recognition
%