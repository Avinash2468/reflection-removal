function [ I_t, I_r ] = enhance_channel(I_t, I_r, padding, I_in)

% Post-processing to enhance the results
% Subtract min value to center the image
I_t = min_subtract(I_t, padding);
I_r = min_subtract(I_r, padding);

% Match the global information of the original image with that of the
% transmitted image
sig = sqrt( sum( (I_in - mean(I_in) ).^2 ) / sum( (I_t-mean(I_t(:)) ).^2 ) );
I_t = sig * ( I_t - mean(I_t(:)) ) + mean( I_in(:) );
end

function [I] = min_subtract(I, padding) 
I_temp = I(padding + 1: end - padding - 1, padding + 1: end - padding);
I = I - min(I_temp(:));
end