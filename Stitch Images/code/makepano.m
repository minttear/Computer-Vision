function [panoImg] = makepano(im1, im2, H)
outSize = [700,2000];
warped_im1 = warpH(im1, eye(3), outSize);
warped_im2 = warpH(im2, H, outSize);


panoImg = im2double(warped_im1) + im2double(warped_im2);
panoImg(im2double(warped_im1)~=0 & im2double(warped_im2)~=0)=panoImg(im2double(warped_im1)~=0 & im2double(warped_im2)~=0)/2;

panoImg = im2uint8(panoImg);

end