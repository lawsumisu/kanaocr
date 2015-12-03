images = dir('resized_kana/*.jpg');

for j=1:length(images)
    I = im2double(imread(strcat('resized_kana/',getfield(images(j),'name'))));
    N = imresize(I, 8.0/length(I(1, :)));
    if length(N) > 11
        N = N(1:11, :);
    elseif length(N) < 11
        M = ones(11, 8);
        M(1:length(N(:, 1)), 1:length(N(1, :))) = N;
        N = M;
    end
    imwrite(N, strcat('resized_kana/',getfield(images(j),'name')));
end