img1=imread('1.JPG');
img2=imread('2.JPG');
img3=imread('3.JPG');
imgs={img1,img2,img3};

img3=stitch_multiple_images(imgs);

