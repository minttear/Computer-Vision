function blobs = detectBlobsScaleImage(im)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSCALEIMAGE(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the image and keeps the
%   filter same for speed. 
% 
% Input:
%   IM - input image
%
% Ouput:
%   BLOBS - n x 4 array with blob in each row in (x, y, radius, score)
%
% This code is taken from:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Blob detector


% Dummy - returns a blob at the center of the image

imagegray=rgb2gray(im);
image=im2double(imagegray);
[h,w]=size(image);
level=10;
scaleSpace=cell(level,1);
stdscaleSpace=zeros(h,w,level);
factor=1.3;

for i=1:level;
    sigma=1.5;
    scale=sigma/(factor^(i-1));
    filt_size=2*ceil(3*sigma)+1;
    filter=sigma*sigma*fspecial('log',filt_size,sigma);
    imagelayer=imresize(image,scale);
    scaleSpace{i}=abs(imfilter(imagelayer,filter));
    
    %filt_size=round(2*sigma*sqrt(2))+1-mod(round(2*sigma*sqrt(2)),2);
    resultScale=ordfilt2(scaleSpace{i},25,ones(5,5));
    scaleSpace{i}(resultScale~=scaleSpace{i})=0;
    %[h,w]=size(scaleSpace{i});
   % for m=1:h
      %for n=1:w
           %if scaleSpace{i}(m,n)~=0
            %    stdscaleSpace(round(m/scale),round(n/scale),i)=scaleSpace{i}(round(m),round(n));
            %end
       % end
   % end
    stdscaleSpace(:,:,i)=imresize(scaleSpace{i},[h,w]);
end
    [h,w]=size(image);
    stdlayer=zeros(h,w);
    for i=1:h
        for j=1:w
            stdlayer(i,j)=max(stdscaleSpace(i,j,:));
        end
    end
    stdlayer=ordfilt2(stdlayer,49,ones(7,7));
    blobs=[0,0,0,0];
    for i=1:h
        for j=1:w
            for k=1:level
                if  stdlayer(i,j)>0.10&&stdscaleSpace(i,j,k)==stdlayer(i,j)
                    new=[j,i,round(1.5*sqrt(2)*factor^(k-1)),round(stdlayer(i,j))];
                    blobs=[blobs;new];
                end
            end
        end
    end
    size(blobs)
    %butterfly 0.09 einstein 0.07 fish 0.04 colorful 0.05 yellow 0.065
    %goldfish 0.12
    
