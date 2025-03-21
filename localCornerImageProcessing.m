function corner = localCornerImageProcessing(im)
    im_gray = im2gray(im);
    J = medfilt2(im_gray,[5,5]);
    % T = adaptthresh(J, 0.4);
    bw = edge(J,'log');
    imshow(bw);
    corner = 1;
end