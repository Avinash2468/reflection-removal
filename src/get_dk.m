function [dx,dy] = get_dk(input_im, signx, signy, thresh)
    
     im=im2double(input_im);
%     im = rgb2gray(im);
%     [ht,wd] = size(im);
    
    %compute the laplacian of the grayscale image
    laplacianKernel = [0 -1 0; -1 4 -1; 0 -1 0];
    laplacianImage = imfilter((im), laplacianKernel); 
    
    %compute the 2D autocorrelation map of the laplacian
    auto = xcorr2(laplacianImage);
    [m,n] = size(auto);
    ori_x = floor(m/2)+1;
    ori_y = floor(n/2)+1;
        
   
    
    %view autocorrelation map
      
%      auto2 = uint8(255 * mat2gray(auto));   
%      x=[-floor(m/2)+1 floor(m/2)+1]; y=[-floor(n/2)+1 floor(n/2)+1];
%      imagesc(x,y,auto2);
%      imshow(auto2)
%      axis on
    
    
    %compute local maxima in 5x5 patch
    %first and second local minima
    max_1 = ordfilt2(auto, 25, true(5,5));
    max_2 = ordfilt2(auto, 24, true(5,5));
    
    %remove local maxima within 4 pixels of the origin
    max_1(ori_x-4 : ori_x+4 , ori_y-4 : ori_y+4) = 0;
    max_2(ori_x-4 : ori_x+4 , ori_y-4 : ori_y+4) = 0;
    
    %eliminating vertical and horizontal shifts if it is known to be a
    %diagonal shift
    if signx ~=0 && signy ~=0
        max_1(ori_x , :) = 0;
        max_1(: , ori_y) = 0;
        max_2(ori_x , :) = 0;
        max_2(: , ori_y) = 0;
    end
    
    %keeping a limit on the shifts
    max_1 = black_out(max_1, m, n);
    max_2 = black_out(max_2, m, n);
    
    %setting the appropriate threshold value
%     diff = max_1 - max_2;
%     [mindiff,i1] = min(diff(:));
%     [maxdiff,i2] = max(diff(:));
    
%     thresh = (maxdiff-mindiff)/3;
    fprintf("Threshold used is %d\n\n", thresh)
    
    max_indices = find(max_1==auto & ((max_1 - max_2) > thresh));
    max_vals = max_1(max_indices);
    max_vals_2 = max_2(max_indices);
    
%     for i = 1 : length(max_indices)
%           [dy, dx] = ind2sub([m,n], max_indices(i)); 
%           a = (dy - ori_x);
%           b = (dx - ori_y);
%           fprintf("%d\t%d\t%d\t%d\t%d\t%d\n",dx,dy,b,a,max_vals(i),max_vals_2(i));
%     end
    
    [~, ind]=max(max_vals);
    
    [dy,dx] = ind2sub([m,n],max_indices(ind));
    
    max_1(max_indices(ind));
    max_2(max_indices(ind));
    
    %origin shift for the coordinates
    dx =   ((dx - ori_y));
    dy =   ((dy - ori_x));
%     
%     dx
%     dy
    if signx == 0 && signy == 0
        %do nothing
        
    elseif (signx == 0)
        if (dy*signy < 0)
            fprintf("I am here\n")
            dy = dy*(-1);
            dx = dx*(-1);
        end
    
    elseif (signy == 0)
        if(dx*signx < 0)
            dy = dy*(-1);
            dx = dx*(-1);
        end
    elseif (dy*signy < 0 && dx*signx < 0 )
        dy = dy*(-1);
        dx = dx*(-1);
        
    elseif (dy*signy > 0 && dx*signx > 0)
        %do nothing
        
    else
        fprintf("Your signs do not agree with the direction of shift detected\n")
        fprintf("Ouputs may be flawed\nPlease recheck the signs\n")
    end
    
    fprintf("Estimation of dk values are\n")
    fprintf("\tdx = %d \n\tdy = %d\n", dx, dy)
    
end

function [auto] =  black_out(auto, m, n)
    auto(1:floor(m/4),:) = 0;
    auto(floor(3*m/4):m,:) = 0;
    auto(:,1:floor(n/4)) = 0;
    auto(:,floor(3*n/4):n) = 0;
end