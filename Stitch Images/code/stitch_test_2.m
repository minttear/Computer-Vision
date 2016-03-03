img1=imread('uttower_left.jpg');
img2=imread('uttower_right.jpg');

img3=stitch_images(img1,img2);
img3=im2uint8(img3);
img3=rgb2gray(img3);


        