images = dir('cropped_kana/*.jpg');

for j=1:length(images)
    [I, map] = imread(strcat('cropped_kana/',getfield(images(j),'name')));

    %Binarization
    %turn image into black and white
    BW = im2bw(I, 0.9);
    inv_BW = 1-BW;

    %horizontal pixel scan, find top/bottom of each row (any row with a black pixel)
    BW_row_sum = sum(inv_BW,2);

    for n=1:length(BW_row_sum)
        if BW_row_sum(n)~=0
            row_start = n;
            break;
        end
    end

    for n=length(BW_row_sum):-1:1
        if BW_row_sum(n)~=0
            row_end = n;
            break;
        end
    end

    BW_col_sum = sum(inv_BW);

    for n=1:length(BW_col_sum)
        if BW_col_sum(n)~=0
            col_start = n;
            break;
        end
    end

    for n=length(BW_col_sum):-1:1
        if BW_col_sum(n)~=0
            col_end = n;
            break;
        end
    end

    imwrite(BW(row_start:row_end, col_start:col_end), strcat('cropped_kana/',getfield(images(j),'name')));
end