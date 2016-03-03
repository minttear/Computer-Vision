function [imShift, predShift] = alignChannels(im, maxShift)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first) 
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.


% Sanity check
assert(size(im,3) == 3);
assert(all(maxShift > 0));

% Dummy implementation (replace this with your own)
predShift = zeros(2, 2);


imShift(:,:,1) = im(:,:,1);
imShift(:,:,2) = im(:,:,2);
imShift(:,:,3) = im(:,:,3);
[a,b,c]=size(imShift);
max1=intmin;
max2=intmin;

for m= -maxShift:maxShift
    for n= -maxShift:maxShift
        imTemp=imShift;
        imTemp(:,:,2) = circshift(imShift(:,:,2), [m n]);
        imTemp(:,:,3)= circshift(imShift(:,:,3), [m n]);
        dt1=0;
        dt2=0;
        
        for i=1:a
            for j=1:b
            dt1 = dt1+ imTemp(i,j,2)*imShift(i,j,1);
            dt2 = dt2+ imTemp(i,j,3)*imShift(i,j,1);
            end
        end
        if dt1>max1
            max1=dt1;
            predShift(1,1)=m;
            predShift(1,2)=n;
        end
        if dt2>max2
            max2=dt2;
            predShift(2,1)=m;
            predShift(2,2)=n;
        end
    end
end

            
         

