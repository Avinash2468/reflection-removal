function deghost(image_path)

I = im2double(imread(image_path));

% size of the image
[h w channels] = size(I);

% spatial shift 
[dx dy] = estimate_dk(I);

% attenuation factor
c = estimate_ck(I);

% ghosting kernel
k = construct_kernel(h, w, dx, dy, c);

for i = 1:channels

    % apply optimization to each channel 
    
end

% output
end
