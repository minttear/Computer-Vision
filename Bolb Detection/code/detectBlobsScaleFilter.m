function blobs = detectBlobsScaleFilter(im)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSSCALEFILTER(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the filter and keeps the
%   image same which is slow for big filters.
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
scaleSpace=zeros(h,w,10);
factor=1.3;
for i=1:10;
    %sigma=2^((i+1)/2);
    sigma=factor^(i-1)*1.5;
    filt_size=2*ceil(3*sigma)+1;
    filter=sigma*sigma*fspecial('log',filt_size,sigma);
    scaleSpace(:,:,i)=abs(imfilter(image,filter,'replicate'));
    %checksize=round(2*sigma*sqrt(2))+1-mod(round(2*sigma*sqrt(2)),2);
    resultScale=ordfilt2(scaleSpace(:,:,1),round(sigma*sqrt(2))^2,ones(round(sigma*sqrt(2)),round(sqrt(2)*sigma)));
    resultScale(resultScale~=scaleSpace(:,:,1))=0;
    scaleSpace(:,:,1)=resultScale;
    
end
    stdlayer=zeros(h,w);
    for i=1:h
        for j=1:w
            stdlayer(i,j)=max(scaleSpace(i,j,:));
        end
    end
    stdlayer=ordfilt2(stdlayer,49,ones(7,7));
    
    blobs=[0,0,0,0];
    for i=1:h
        for j=1:w
            for k=1:10
                if stdlayer(i,j)>0.08 && scaleSpace(i,j,k)==stdlayer(i,j)
                    %new=[j,i,round(2^((k+2)/2)),round(stdlayer(i,j))];
                    new=[j,i,round(factor^(k-1)*1.5*sqrt(2)),round(stdlayer(i,j))];
                    blobs=[blobs;new];
                end
            end
        end
    end
    size(blobs)
    %butterfly 0.08  einstein 0.05 fish 0.00005 colorful0.00000005 yellow
    %0.00000005 gold fish 0.00000005
    %
    
                    
                 
                    
                    
  
    
    


