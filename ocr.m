[I, map] = imread('test.png');

%Binarization
%turn image into black and white
BW = im2bw(I, 0.9);
inv_BW = 1-BW;

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
col_start = {};
col_end = {};

for m=1:length(row_start)
    % retrieve section of inverse image that is the row
    BW_col = inv_BW(row_start(m):row_end(m),:);
    BW_col_sum = sum(BW_col);
    flag = 0;
    col_start{m} = [];
    col_end{m} = [];
    for n=1:length(BW_col_sum)
        if flag==0 && BW_col_sum(n)~=0
            col_start{m} = [col_start{m} n];
            flag = 1;
        elseif flag~=0 && BW_col_sum(n)==0
            col_end{m} = [col_end{m} n-1];
            flag = 0;
        end
    end
    % edge case, if row ends at bottom of image, need to save final row_end
    % index
    if BW_col_sum(length(BW_col_sum))>0
        col_end{m} = [col_end{m} length(BW_col_sum)];
    end
end

%draw bounding boxes
bboxes = [];
for n=1:length(row_start)
    for m=1:length(col_start{n})
        bboxes=[bboxes; col_start{n}(m) row_start(n) col_end{n}(m) row_end(n)];
    end
end
showboxes(BW,bboxes,map);

%crop characters out of each image
cropped_characters = {};
for n=1:length(row_start)
    for m=1:length(col_start{n})
        figure, imshow(BW(row_start(n):row_end(n), col_start{n}(m):col_end{n}(m)));
        cropped_characters = [cropped_characters, BW(row_start(n):row_end(n), col_start{n}(m):col_end{n}(m))];
    end
end

%Character recognition
%