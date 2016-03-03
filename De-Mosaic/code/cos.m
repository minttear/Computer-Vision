dataDir = fullfile('..','data','demosaic');

% List of images


thisImage = fullfile(dataDir, 'cat.jpg');
    im = imread(thisImage);
    a=im(:,:,1);
    [imageHeight,imageWidth]=size(a);
    a=reshape(a,imageHeight*imageWidth,1);
    b=im(:,:,2);
    b=reshape(b,imageHeight*imageWidth,1);
    ctheta=dot(double(a),double(b))/(norm(double(a))*norm(double(b)))
    theta=acos(ctheta)*180/pi