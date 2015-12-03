function hog_filter = get_hog_filter(hog_image)
    hog_filter = hog_image - mean(hog_image(:));    
end