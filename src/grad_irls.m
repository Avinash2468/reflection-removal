function [I_t, I_r]=grad_irls(I_in, k_mat)
  
  h = size(I_in,1);
  w = size(I_in,2);
  
  configs.dims=[size(I_in,1) size(I_in,2)];
  configs.delta=1e-4;
  configs.p=0.2;
  configs.use_lap=1;
  configs.use_diagnoal=1;
  configs.use_lap2=1;
  configs.use_cross=0;
  configs.niter=20;
  configs.num_px=h*w;
  configs.non_negative = true;
  
  mk = k_mat;
 mh = inv(mk);

  mx = get_fx(h, w);
  my = get_fy(h, w);
  mu = get_fu(h, w);
  mv = get_fv(h, w);
  mlap = get_lap(h, w);

  I_x = imfilter(I_in, [-1 1]);
  I_y = imfilter(I_in, [-1; 1]);

  out_xi = I_x/2;
  out_yi = I_y/2;

  out_x = irls_grad(I_x, [], out_xi, mh, configs, mx, my,  mu, mv, mlap);
%   outr_x = reshape(mh*(I_x(:)-out_x(:)), configs.dims);
  outr_x = reshape(mh*(I_x(:)-out_x(:)), configs.dims);
  
  out_y = irls_grad(I_y, [], out_yi, mh, configs, mx, my, mu, mv, mlap);
  outr_y = reshape(mh*(I_y(:)-out_y(:)), configs.dims);

  I_t = Integration2D(out_x, out_y, I_in);
  I_r = Integration2D(outr_x, outr_y, I_in);
