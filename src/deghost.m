function deghost(image_path)
  addpath('epllcode');
  addpath('lbfgsb')
  addpath('lbfgsb/lbfgsb3.0_mex1.2');

I = im2double(imread(image_path));

% size of the image
[h w channels] = size(I);

% spatial shift 
[dx dy] = get_dk(I);

% attenuation factor
c = estimate_ck(I, dx, dy);

% ghosting kernel
k = construct_kernel(h, w, dx, dy, c);

for i = 1:channels
    fprintf("For channel ",i)
    % apply optimization to each channel 
    [I_t(:,:,i), I_r(:,:,i)] = patch_gmm(I(:,:,i), k);

end

  imwrite(I, char(strcat('t','_input.png')));
  imwrite(I_t, char(strcat('t','_transmission.png')));
  imwrite(I_r, char(strcat('t','_reflection.png')));
end
