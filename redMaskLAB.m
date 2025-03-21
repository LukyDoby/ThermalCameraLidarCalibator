function mask = redMaskLAB(im)

L_min = 0;
L_max = 49;
a_min = 22;
a_max = 62;
b_min = -35;
b_max = 85;

labImg = rgb2lab(im);
L = labImg(:,:,1);
a = labImg(:,:,2);
b = labImg(:,:,3);

% Binary mask for pixels within specified range
mask = (L >= L_min & L <= L_max) & ...
       (a >= a_min & a <= a_max) & ...
       (b >= b_min & b <= b_max);
end