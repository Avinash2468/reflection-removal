function [I_t, I_r ] = patch_gmm(I_in, k_mat)

  % Setup for patch-based reconstruction
  h = size(I_in,1);
  w = size(I_in,2);
  psize = 8;

  % Operator that maps an image to its ghosted version
  A = [speye(h*w, h*w) k_mat]; 
  num_patches = (h - psize + 1) * (w - psize + 1);
  t_merge = merge_patches(ones(psize^2, num_patches), h, w, psize);
  r_merge = merge_patches(ones(psize^2, num_patches), h, w, psize);
  mask = cat(1, t_merge(:), r_merge(:));
 
  % Setup for GMM prior
  load GSModel_8x8_200_2M_noDC_zeromean.mat
  excludeList=[];

  % Initialize
  % IRLS: Iteratively reweighted least squares optimization method
  [I_t_i, I_r_i ] = grad_irls(I_in, k_mat);

  % Apply patch gmm with the initial result.
  % Create patches from the two layers.
  est_t = im2patches(I_t_i, psize);
  est_r = im2patches(I_r_i, psize);

  % Params for the iterations
  beta = 200;
  lambda = 1e6;
  
  for i = 1 : 25
    fprintf('Optimization iteration : %d...\n', i);

    % Merge the patches with bounded least squares
    t_merge = merge_patches(ones(psize^2, num_patches), h, w, psize);
    r_merge = merge_patches(ones(psize^2, num_patches), h, w, psize);
    sum_piT_zi = cat(1, t_merge(:), r_merge(:));
    z = lambda * transpose(A) * I_in(:) + beta * sum_piT_zi;

    % Non-negative optimization by L-BFGSB
    opts = struct( 'factr', 1e4, 'pgtol', 1e-8, 'm', 50);
    opts.printEvery = 50;

    sum_zi_2 = norm(est_t(:))^2 + norm(est_r(:))^2;
    fcn = @(x)( lambda * norm(A*x - I_in(:))^2 + ...
        beta*( sum(x  .*mask.*x - 2 * x.* sum_piT_zi(:)) + sum_zi_2));

    f_handle = @(x)(lambda * transpose(A) * (A*x) + beta * (mask.*x));
    grad = @(x)(2*(f_handle(x) - z));
    fun = @(x)fminunc_wrapper( x, fcn, grad);

    l = zeros(numel(z), 1);
    u = ones(numel(z), 1);

    [out, ~, ~] = lbfgsb(fun, l, u, opts );

    out = reshape(out, h, w, 2);
    I_t = out(:,:,1);
    I_r = out(:,:,2);

    % Extract est_t and est_r by restoring patches using the patch based prior
    est_t = im2patches(I_t, psize);
    est_r = im2patches(I_r, psize);

    noiseSD=(1/beta)^0.5;
    [est_t, ~]= aprxMAPGMM(est_t, psize, noiseSD, [h w], GS, excludeList);
    [est_r, ~]= aprxMAPGMM(est_r, psize, noiseSD, [h w], GS, excludeList);

    
    beta = beta*2; %taking beta factor as two

  end
