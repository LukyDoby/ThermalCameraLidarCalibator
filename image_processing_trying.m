%% Image processig trying
clear;clc; close all;

imagePath = fullfile("/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/Images/");
im = imread(fullfile(imagePath,"0158.png"));

gray_im = rgb2gray(im);

bw = edge(gray_im,"canny");


[B, L] = bwboundaries(bw, 'noholes');

imshow(bw); hold on;

colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(B)

  boundary = B{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);

  %randomize text position for better visibility
  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
  col = boundary(rndRow,2); row = boundary(rndRow,1);
  h = text(col+1, row-1, num2str(L(row,col)));
  set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
end