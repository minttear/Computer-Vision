function [ inliers12] = getInliernumbers( img1,img2 )
%GETINLIERNUMBERS Summary of this function goes here
%   Detailed explanation goes here
     [x1,y1,x2,y2]=get_matches(img1,img2,0);
     [T,inliers12,avg_residual]=get_transform(x1, y1, x2, y2);
     


end

