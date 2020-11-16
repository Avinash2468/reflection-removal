 function [kernel] = construct_kernel(h, w, dx, dy, c)
   
 index = [1:h*w];
 index = reshape(index, [h, w]);
 
 % shift pixels by dk
 neigh_index1 = padarray(index, abs([dy, dx]));
 neigh_index1 = circshift(neigh_index1, [dy, dx]);
 neigh_index1 = neigh_index1(abs(dy) + 1:end - abs(dy), abs(dx) + 1:end - abs(dx), :);
 
 % applying attenuation on shifted pixels
 
 indexes = ones(h, w);

% pixels having a shift and pixels to which they are getting mapped
shifted_pixels1 = sparse(index(:), index(:), indexes);

indexes2 = ones(h, w);
indexes2(neigh_index1 == 0) = 0;
indexes2 = indexes2.*c;

% pixels which have undergone attenuation
neigh_index2 = circshift(index, [dy dx]);
shifted_pixels2 = sparse(index(:), neigh_index2(:), indexes2);

kernel = shifted_pixels1 + shifted_pixels2;

end
