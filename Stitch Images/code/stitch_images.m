function new_img = stich_images(img1, img2)
     sample1 = rgb2gray(img1);
     sample2 = rgb2gray(img2);
     [x1,y1,x2,y2]=get_matches(sample1,sample2,0);
     [T,num_inliers,avg_residual]=get_transform(x1, y1, x2, y2)
      sample1=im2double(sample1);
      sample2=im2double(sample2);
      H = maketform('projective', T');
      [right,xdata_range,ydata_range]=imtransform(img2,H);
      xdataout=[min(1,xdata_range(1)) max(size(sample2,2),xdata_range(2))];
      ydataout=[min(1,ydata_range(1)) max(size(sample2,1),ydata_range(2))];
     right=imtransform(img2,H,'XData',xdataout,'YData',ydataout);
     left=imtransform(img1,maketform('projective',eye(3)),'XData',xdataout,'YData',ydataout);
     
     
    new_img = im2double(left) + im2double(right);
    new_img(im2double(left)~=0 & im2double(right)~=0)=new_img(im2double(left)~=0 & im2double(right)~=0)/2;
    imshow(new_img);
%      img3=makepano(sample1,sample2,T);
%      imshow(img3);
%      new_img=img3;
     
	% Return a new complete image that stitches the two input images together
	% If the two images cannot be stitched together, return 0

end