function [x1, y1, x2, y2] = get_matches(img1, img2, do_visualization)

	% Return matched x,y locations across the two images. The point defined by (x1,y1) in
	% img1 should correspond to the point defined by (x2,y2) in img2.
     [feat1,locx1,locy1]=get_feats(img1);
     [feat2,locx2,locy2]=get_feats(img2);
     [D,I] = pdist2(feat2,feat1,'euclidean','Smallest',2);
     ix = 1:size(feat1,1);

      ratio=0.8;
      r = D(1,:)./D(2,:);
      ix = ix(r < ratio | isnan(r));
      I2 = I(1,r < ratio | isnan(r));
      
  
      matches = [ix' I2'];
      
      x1 = locx1(matches(:,1))';
      y1 = locy1(matches(:,1))';
      x2=locx2(matches(:,2))';
      y2=locy2(matches(:,2))';
      

   
	if do_visualization==1 
		% You must implement this.
		% Display a single figure with the two input images side-by-side.
		% Visualize the features your method has found with some way of showing
		% the corresponding matches.
        img=cat(2,img1,img2);
        imshow(img);
        hold on;
        c=rand(size(matches,1),3);
        scatter(x1, y1, 20, c, 'o');
        x3=x2+1024;
        scatter(x3, y2, 20, c, 'o');
       
        
	end

end

