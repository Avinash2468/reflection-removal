function [dx,dy] = get_dk(im, thresh)
    
    im=im2double(im);
    im = rgb2gray(im);
    [ht,wd] = size(im);
    
    %compute the laplacian of the grayscale image
    laplacianKernel = [0 -1 0; -1 4 -1; 0 -1 0];
    laplacianImage = imfilter((im), laplacianKernel); 
    
    %compute the 2D autocorrelation map of the laplacian
    auto = xcorr2(laplacianImage);  
    [m,n] = size(auto);
    ori_x = floor(m/2)+1;
    ori_y = floor(n/2)+1;
        
    
    %view autocorrelation map
    
    auto2 = uint8(255 * mat2gray(auto));   
    x=[-floor(m/2)+1 floor(m/2)+1]; y=[-floor(n/2)+1 floor(n/2)+1];
    imagesc(x,y,auto2);
    imshow(auto2)
    axis on
    
    
    %compute local maxima in 5x5 patch
    %first and second local minima
    max_1 = ordfilt2(auto, 25, true(5,5));
    max_2 = ordfilt2(auto, 24, true(5,5));

    
    %remove local maxima within 4 pixels of the origin
    max_1(ori_x-4 : ori_x+4 , ori_y-4 : ori_y+4) = 0;
    max_2(ori_x-4 : ori_x+4 , ori_y-4 : ori_y+4) = 0;

    
    max_indices = find(max_1==auto & ((max_1 - max_2) > thresh));
    max_vals = max_1(max_indices);

    
    
    maxima = -1;
    dx = 0; 
    dy = 0;

    for i = 1 : length(max_indices)
        if (max_vals(i) > maxima)              
                %consider coordinate axes
                [y, x] = ind2sub([m,n], max_indices(i)); 
                dy = y;
                dx = x;
                maxima = max_vals(i);
        end
    end
    
    dx
    dy
    
    %origin shift for the coordinates
    dx = abs (dx - ori_y);
    dy = abs (dy - ori_x);
    
end
    