function generate_ghosted(t_path, r_path, dx, dy, c)
    t_img = double(imread(t_path));
    r_img = double(imread(r_path));
    
    h = size(t_img, 1);
    w = size(t_img, 2);

    k_mat = construct_kernel(h, w, dx, dy, c);
    size(full(k_mat))
    size(t_img)
    
    err = conv2(full(k_mat), r_img,'full');
    err1 = err(1:60, 1:80);
    
   out = t_img + err1;
    
    imwrite(full(k_mat), './sample.png')
end

function out=imfiltern(I, k)
  out=imfilter(I, k(end:-1:1, end:-1:1));
end