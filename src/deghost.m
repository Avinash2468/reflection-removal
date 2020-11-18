function deghost(image_path, label_x, label_y, dk_thresh, ck_thresh)
  addpath('epllcode'); % Dependency on Patch-GMM prior
  addpath('lbfgsb'); 
  addpath('lbfgsb/lbfgsb3.0_mex1.2'); % Dependency on bounded-LBFGS Optimization 

I = im2double(imread(image_path));

% size of the image
[h, w, channels] = size(I);

%getting the appropriate signs for dx and dy from user input
if strcmpi(label_x,"l") == 1 
    signx = -1;
elseif strcmpi(label_x,"r") == 1 
    signx = 1;
else
    signx = 0;
end

if strcmpi(label_y,"u") == 1 
    signy = -1;
elseif strcmpi(label_y,"d") == 1 
    signy = 1;
else
    signy = 0;
end
    
%passing greyscale to the kernel
if channels>1
	I_gray = rgb2gray(I);
else
	I_gray = I;
end

% spatial shift 
[dx, dy] = get_dk(I_gray, signx, signy, dk_thresh);

% attenuation factor
c = estimate_ck(I_gray, dx, dy, ck_thresh);

% ghosting kernel
k = construct_kernel(h, w, dx, dy, c);

I_t = zeros(size(I));
I_r = zeros(size(I));

for i = 1:channels
    fprintf("For channel %d\n",i)
    % apply optimization to each channel 
    [I_t(:,:,i), I_r(:,:,i)] = patch_gmm(I(:,:,i), k, i);
    [I_t(:,:,i), I_r(:,:,i)] = enhance_channel(I_t(:,:,i), I_r(:,:,i), 10, I(:,:,i));
end

  fprintf('Saving results\n');
  save_path = split(image_path, '/');
  save_path = split(save_path(end), '.');
  im_name = save_path(1);
  save_path = strcat("../outputs/", im_name);
  imwrite(I, char(strcat(save_path,'_input.png')));
  imwrite(I_t, char(strcat(save_path,'_transmission.png')));
  imwrite(I_r, char(strcat(save_path,'_reflection.png')));

end
