function c = estimate_ck(input_img,dx,dy)
% img = im2double(imread(img_path));  
% img = rgb2gray(input_img);
img = input_img;
c= 0;
% Extracting corners using harris corner detector
img_corners = corner(img);

[rows,~] = size(img_corners);

% initialising the attentuation vector
a = zeros(size(img_corners,1),1);
% initialising the normalization vector
w = zeros(size(img_corners,1),1);

for i = 1:rows % iterating through the corners
    x = img_corners(i,1); % X-coordinate of the corner
    y = img_corners(i,2); % Y-coordinate of the corner
    slice = retrieve_patch(img,x,y,2); % Retrieving a 5x5 patch around the corner
    slice1 = retrieve_patch(img,x+dx,y+dy,2); % Retrieving a 5x5 patch around the corner at an offset d
     

    if isequal(slice,0) || isequal(slice1,0) 
        % do nothing
    else
        
      slice=slice(:); 
      slice1 = slice1(:); % converting to a row vector for further processing
      
       % Contrast normalization of the patch
       slice = contrast_normalize(slice);
       slice1 = contrast_normalize(slice1);
       
      slice=slice-mean(slice);
      slice1=slice1-mean(slice1); % normalising the mean

%        a(i)=(max(slice1)-min(slice1))/(max(slice)-min(slice));
        a(i) = sqrt(var(slice1)/var(slice));
      
      if (a(i) <1) && ( a(i) > 0)
%           temp = sum(slice.*slice1)/sum(slice.^2).^0.5/sum(slice1.^2).^0.5;
          temp  = (norm(slice-slice1))^2;
        w(i) = exp(-temp/(2*0.2^2));
      end
    end
    
    c = sum(w.*a) / sum(w);
end

fprintf("ck val is %d\n", c)
end

function slice = retrieve_patch(img,center_x,center_y,width)
[m,n] = size(img);
left = center_y - width;
right = center_y + width;
top = center_x -width;
bottom = center_x + width;  
slice = 0;
if left < 1 || top < 1 || right > m || bottom > n
    % do nothing
else
    slice = img(left:right,top:bottom);
end
end

function ret_arr = contrast_normalize(arr)
  den = max(arr)-min(arr);
  ratio = 1;
  if den ~= 0
    ratio = 1.0/(max(arr)-min(arr));
  end  
  ret_arr = (arr-min(arr))*ratio;
end  