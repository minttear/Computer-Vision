 function [feats, x, y] = get_feats(img)

%%
    
	% Return an N x M matrix of features, along with the corresponding x,y
	% locations of the detected features.

	% N and M both depend on what method of feature detection you choose to use.
	% N = number of features found
	% M = feature vector length

      
 
        sigma=3;
        thresh=1000;
        radius=3;
        disp=0;
        cim=harris(img, sigma, thresh, radius, disp);
        [r,c]=find(cim);
         ra=r;
         ra(:)=3;
         circles=[c,r,ra];
         enlarge_factor=1.5;
         
 
         feats = find_sift(img, circles, enlarge_factor);
         x=c;
         y=r;
        
       
 end
