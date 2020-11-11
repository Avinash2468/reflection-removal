function [kernel] = construct_kernel(h, w, dx, dy, c)

file = fopen(‘dk.txt’, ‘r’);
format = ‘%f %f’;
A = fscanf(file, format);
fclose(file);
file = fopen(‘ck.txt’, ‘r’);
format = ‘%f’;
A = fscanf(file, format);
fclose(file);

index = [1:h*w];
index = reshape(index, [h, w]);

% shift pixels by dk
index2 = padarray(index, abs([dy, dx]));
index2 = circshift(index2, [dy, dx]);
index2 = index2(abs(dy) + 1:end - abs(dy), abs(dx) + 1:end - abs(dx), :);

% applying attenuation on shifted pixels.
indexes = ones(h, w);

% pixels having a shift and pixels to which they are getting mapped.
shifted_pixels = sparse(index(:), index(:), indexes);

indexes2 = ones(h, w);
indexes2(index2 == 0) = 0;
indexes2 = indexes2.*c;

% pixels which have undergone attenuation
shifted_pixels2 = sparse(index(:), index(:), indexes2);

kernel = shifted_pixels + shifted_pixels2;

end

