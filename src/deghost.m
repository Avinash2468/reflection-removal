function deghost(image_path, signx, signy, dk_thresh, ck_thresh, label)
  addpath('epllcode');
  addpath('lbfgsb')
  addpath('lbfgsb/lbfgsb3.0_mex1.2');

I = im2double(imread(image_path));

% size of the image
[h w channels] = size(I);

if channels>1
	I_gray = rgb2gray(I);
else
	I_gray = I;
end

% spatial shift 
[dx dy] = get_dk(I_gray, signx, signy, dk_thresh);

% attenuation factor
c = estimate_ck(I_gray, dx, dy, ck_thresh);

% ghosting kernel
k = construct_kernel(h, w, dx, dy, c);

for i = 1:channels
    fprintf("For channel ",i)
    % apply optimization to each channel 
    [I_t(:,:,i), I_r(:,:,i)] = patch_gmm(I(:,:,i), k);
%     [I_t(:,:,i), I_r(:,:,i)] = enhance_channel(I_t(:,:,i), I_r(:,:,i), 10, I(:,:,i));
end

  imwrite(I, char(strcat(label,'_input.png')));
  imwrite(I_t, char(strcat(label,'_transmission.png')));
  imwrite(I_r, char(strcat(label,'_reflection.png')));
end
