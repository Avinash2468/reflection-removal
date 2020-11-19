function out_x=irls_grad(I_x, out_xi, mh, mx, my,  mu, mv, num_px)
% Solve tx = argmin  |tx|_p + |mh (I_x - tx)|_p + high_order_terms (optional)
% Unconstrained problem
% Support high order priors, see code

% I_x   : input gradient, can be any direction
% out_xi: initial estimation
% mh    : deconvolution kernel. mh*mk=delta. (mk=two pulse kernel)
% mx,my : first  order constraint in horizotal/vertical direction
% mu,mv : first  order constraint in \ / direction


  p=0.2;
  out_x=out_xi;

  spdiagI=@(x)(spdiags(x(:), 0,  num_px, num_px));
  
  % constraint on (Ix)xx
    mx2=mx*mx;
    my2=my*my;


  for i = 1 : 20
    delta = 1e-4;

    w1=(abs(out_x(:)).^2 + delta).^(p/2-1);
    w2=(abs(mh*( I_x(:)-out_x(:) )).^2 + delta).^(p/2-1);
    A1 = spdiags(w1(:), 0, num_px, num_px);
    A2 = mh'*spdiags(w2(:), 0, num_px, num_px)*mh;

    Atot = A1+A2;
    Ab =  A2;

    %Use 2nd dx dy, ie. constraint on (Ix)x
    w3=(abs(mx*out_x(:)).^2 + delta).^(p/2-1);
    w4=(abs(my*out_x(:)).^2 + delta).^(p/2-1);
    w5=(abs(mx*mh*( I_x(:)-out_x(:) )).^2 + delta).^(p/2-1);
    w6=(abs(my*mh*( I_x(:)-out_x(:) )).^2 + delta).^(p/2-1);

    A3 = mx'*spdiagI(w3)*mx;
    A4 = my'*spdiagI(w4)*my;
    A5 = mx'*spdiagI(w5)*mx;
    A6 = my'*spdiagI(w6)*my;
    A7 = mh'*(A5+A6)*mh;

    Atot = Atot + A3 + A4 + A7;
    Ab = Ab + A7;

    %Use 2nd du dv (diagnoal components)
    w8=(abs(mu*out_x(:)).^2 + delta).^(p/2-1);
    w9=(abs(mv*out_x(:)).^2 + delta).^(p/2-1);
    w10=(abs(mu*mh*( I_x(:)-out_x(:) )).^2 + delta).^(p/2-1);
    w11=(abs(mv*mh*( I_x(:)-out_x(:) )).^2 + delta).^(p/2-1);

    A8 = mu'*spdiagI(w8)*mu;
    A9 = mv'*spdiagI(w9)*mv;
    A10 = mu'*spdiagI(w10)*mu;
    A11 = mv'*spdiagI(w11)*mv;
    A12 = mh'*(A10+A11)*mh;

    Atot = Atot + A8 + A9 + A12;
    Ab = Ab + A12;

    %constraint on (Ix)xx
    w17=(abs(mx2*out_x(:)).^2 + delta).^(p/2-1);
    w18=(abs(my2*out_x(:)).^2 + delta).^(p/2-1);
    w19=(abs(mx2*mh*( I_x(:)-out_x(:) )).^2 + delta).^(p/2-1);
    w20=(abs(my2*mh*( I_x(:)-out_x(:) )).^2 + delta).^(p/2-1);

    A17 = mx2'*spdiagI(w17)*mx2;
    A18 = my2'*spdiagI(w18)*my2;
    A19 = mx2'*spdiagI(w19)*mx2;
    A20 = my2'*spdiagI(w20)*my2;
    A21 = mh'*(A19+A20)*mh;

    Atot = Atot + A17 + A18 + A21;
    Ab = Ab + A21;

    out_x = Atot\(Ab*I_x(:));

  end
end
