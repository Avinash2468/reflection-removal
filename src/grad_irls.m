function [I_t, I_r]=grad_irls(I_in, k_mat)
  
  h = size(I_in,1);
  w = size(I_in,2);
  
  dims = [size(I_in,1) size(I_in,2)];
  
  mk = k_mat;
  mh = inv(mk);

  mx = get_fx(h, w);
  my = get_fy(h, w);
  mu = get_fu(h, w);
  mv = get_fv(h, w);

  I_x = imfilter(I_in, [-1 1]);
  I_y = imfilter(I_in, [-1; 1]);

  out_xi = I_x/2;
  out_yi = I_y/2;

  out_x = irls_grad(I_x, out_xi, mh, mx, my,  mu, mv, h*w);
  out_x = reshape(out_x, dims);
  outr_x = reshape(mk\(I_x(:)-out_x(:)), dims);
  
  out_y = irls_grad(I_y, out_yi, mh, mx, my, mu, mv, h*w);
  out_y = reshape(out_y, dims);
  outr_y = reshape(mk\(I_y(:)-out_y(:)), dims);

  I_t = Integration2D(out_x, out_y, I_in);
  I_r = Integration2D(outr_x, outr_y, I_in);
