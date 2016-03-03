function new_img = stitch_multiple_images(imgs)
    img1=imgs{1};
    img2=imgs{2};
    img3=imgs{3}; 
     
    img_gray1=rgb2gray(img1);
    img_gray2=rgb2gray(img2);
    img_gray3=rgb2gray(img3);
    %calculate the inliers to decide which should be at the center
    inliers12 = getInliernumbers( img_gray1,img_gray2 )
    inliers13 = getInliernumbers( img_gray1,img_gray3 )
    inliers23 = getInliernumbers( img_gray2,img_gray3 )
    
    if(inliers12>inliers23 && inliers13>inliers23)
        output=stitch_images(img2,img1);
        output=im2uint8(output);
        output=stitch_images(img3,output);
        printf(1);
   
    elseif(inliers23>inliers12 &&inliers13>inliers12)
        output=stitch_images(img3,img1);
        output=im2uint8(output);
        output=stitch_images(img2,output);
        printf(3);
    
        elseif(inliers23>inliers13 &&inliers12>inliers13)
        output=stitch_images(img2,img1);
        output=im2uint8(output);
        output=stitch_images(img3,output);
        printf(2);
    end
    
    new_img=output;
    imshow(output);
    
	% Given a set of images in any order, stitch them together into a final panorama
	% Example call: stitch_multiple_images({img1, img2, img3})

end