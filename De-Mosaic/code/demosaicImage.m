function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
end

%--------------------------------------------------------------------------
%                          Baseline demosaicing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:imageHeight, 1:2:imageWidth,1) = im(1:2:imageHeight, 1:2:imageWidth);

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;

%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)


mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);
%
% Implement this 
%
%red channel
    redValues=zeros(imageHeight,imageWidth);
    copy=mosim(1:2:imageHeight,1:2:imageWidth,1);
    redValues(1:2:imageHeight,1:2:imageWidth)=mosim(1:2:imageHeight,1:2:imageWidth,1);
    redValues=redValues+circshift(redValues,[1,0]);
    redValues(1:2:imageHeight,1:2:imageWidth)=copy;
    redValues=redValues+circshift(redValues,[0,1]);
    mosim(:,:,1)=redValues;
    mosim(1:2:imageHeight,1:2:imageWidth,1)=copy;
    
%blue channel
    blueValues=zeros(imageHeight,imageWidth);
    copy=mosim(2:2:imageHeight,2:2:imageWidth,1);
    blueValues(2:2:imageHeight,2:2:imageWidth)=mosim(2:2:imageHeight,2:2:imageWidth,3);
    blueValues=blueValues+circshift(blueValues,[-1,0]); 
    blueValues=blueValues+circshift(blueValues,[0,-1]);
    mosim(:,:,3)=blueValues;
    mosim(2:2:imageHeight,2:2:imageWidth,1)=copy;
    mosim(1:1:imageHeight,imageWidth,3)= mosim(1:1:imageHeight,imageWidth-1,3);
    mosim(imageHeight,1:1:imageWidth,3)= mosim(imageHeight-1,1:1:imageWidth,3);
    
%green channel
    greenValues=mosim(:,:,2);
   
    copy1=mosim(1:2:imageHeight,2:2:imageWidth,2);
    copy2=mosim(2:2:imageHeight,1:2:imageWidth,2);
    greenValues=zeros(imageHeight,imageWidth);
    greenValues(1:2:imageHeight,2:2:imageWidth)=mosim(1:2:imageHeight,2:2:imageWidth);
    greenValues1=circshift(greenValues,[0,-1]);
    greenValues=zeros(imageHeight,imageWidth);
    greenValues(2:2:imageHeight,1:2:imageWidth)=mosim(2:2:imageHeight,1:2:imageWidth);
    greenValues2=circshift(greenValues,[0,1]);
    
    mosim(1:2:imageHeight,1:2:imageWidth,2)=0;
    mosim(2:2:imageHeight,2:2:imageWidth,2)=0;
    mosim(:,:,2)=mosim(:,:,2)+greenValues1+greenValues2;
    mosim(1:2:imageHeight,2:2:imageWidth,2)=copy1;
    mosim(2:2:imageHeight,1:2:imageWidth,2)=copy2;
    mosim(1:2:imageHeight,imageWidth,2)=mosim(1:2:imageHeight,imageWidth-1,2);
    
    


           
            


%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
mosim = demosaicBaseline(im);
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);
%
% Implement this 
%red channel
for i=1:2:imageHeight
    for j=2:2:imageWidth
        if j<imageWidth
            mosim(i,j,1)=(mosim(i,j-1,1)+mosim(i,j+1,1))/2;
        else mosim(i,j,1)=mosim(i,j-1,1);
        end
    end
end
for i=2:2:imageHeight
    for j=1:2:imageWidth
        if i<imageHeight
            mosim(i,j,1)=(mosim(i+1,j,1)+mosim(i-1,j,1))/2;
        else mosim(i,j,1)=mosim(i-1,j,1);
        end
    end
end
for i=2:2:imageHeight
    for j=2:2:imageWidth
        if i<imageHeight
            if j<imageWidth
                mosim(i,j,1)=(mosim(i-1,j-1,1)+mosim(i-1,j+1,1)+mosim(i+1,j-1,1)+mosim(i+1,j+1,1))/4;
            else mosim(i,j,1)=(mosim(i-1,j-1,1)+mosim(i+1,j-1,1))/2;
            end
        else mosim(i,j,1)=mosim(i-1,j-1,1);
        end
    end
end
%blue channel
for i=1:2:imageHeight
    for j=2:2:imageWidth
        if i<imageHeight
            if i>1
            mosim(i,j,3)=(mosim(i+1,j,3)+mosim(i-1,j,3))/2;
            else mosim(i,j,3)=mosim(i+1,j,3);
            end
            
        else mosim(i,j,3)=mosim(i-1,j,3);
        end
    end
end
for i=2:2:imageHeight
    for j=1:2:imageWidth
        if j<imageWidth
            if j>1
                mosim(i,j,3)=(mosim(i,j-1,3)+mosim(i,j+1,3))/2;
            else mosim(i,j+1,3);
            end
        else mosim(i,j,3)=mosim(i,j-1,3);
        end
    end
end
for i=1:2:imageHeight
    for j=1:2:imageWidth
        if(i<imageHeight&& i>1 &&j<imageWidth&&j>1)
             mosim(i,j,3)=(mosim(i-1,j-1,3)+mosim(i-1,j+1,3)+mosim(i+1,j-1,3)+mosim(i+1,j+1,3))/4;
        end 
        if(j==1 && i<imageHeight && i>1)
            mosim(i,j,3)=(mosim(i-1,j+1,3)+mosim(i+1,j+1,3))/2;
        end
        if(i==1 && j==1)
            mosim(i,j,3)=mosim(i+1,j+1,3);
        end
        if(j==imageWidth && i>1 &&i<imageHeight)
            mosim(i,j,3)=(mosim(i-1,j-1,3)+mosim(i+1,j-1,3))/2;
        end
        if(j==imageWidth&& i==imageHeight)
            mosim(i,j,3)=mosim(i-1,j-1,3);
        end
    end
end

%green channel
for i=1:2:imageHeight
    for j=1:2:imageWidth
        if(i<imageHeight&& i>1 &&j<imageWidth&&j>1)
              mosim(i,j,2)=(mosim(i-1,j,2)+mosim(i+1,j,2)+mosim(i,j-1,2)+mosim(i,j+1,2))/4;
        end 
        if(j==1 && i<imageHeight && i>1)
           mosim(i,j,2)=(mosim(i-1,j,2)+mosim(i+1,j,2)+mosim(i,j+1,2))/3;
        end
        if(i==1 && j==1)
            mosim(i,j,2)=(mosim(i+1,j,2)+mosim(i,j+1,2))/2;
        end
        if(j==imageWidth&& i>1 &&i<imageHeight)
            mosim(i,j,2)=(mosim(i-1,j,2)+mosim(i+1,j,2)+mosim(i,j-1,2))/3;
        end
        if(j==imageWidth&& i==imageHeight)
            mosim(i,j,2)=mosim(i-1,j-1,2);
        end
        
    end
end
for i=2:2:imageHeight
    for j=2:2:imageWidth
        if i<imageHeight
            if j<imageWidth
                mosim(i,j,2)=(mosim(i,j-1,2)+mosim(i,j+1,2)+mosim(i-1,j,2)+mosim(i+1,j,2))/4;
            else mosim(i,j,2)=(mosim(i,j-1,2)+mosim(i-1,j,2)+mosim(i+1,j,2))/3;
            end
        else mosim(i,j,2)=(mosim(i,j-1,2)+mosim(i-1,j,2))/2;
        end
    end
end
            
                    
           



%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
%
% Implement this 
%
mosim = demosaicBaseline(im);
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);
%
% Implement this 
%red channel
for i=1:2:imageHeight
    for j=2:2:imageWidth
        if j<imageWidth
            mosim(i,j,1)=(mosim(i,j-1,1)+mosim(i,j+1,1))/2;
        else mosim(i,j,1)=mosim(i,j-1,1);
        end
    end
end
for i=2:2:imageHeight
    for j=1:2:imageWidth
        if i<imageHeight
            mosim(i,j,1)=(mosim(i+1,j,1)+mosim(i-1,j,1))/2;
        else mosim(i,j,1)=mosim(i-1,j,1);
        end
    end
end
for i=2:2:imageHeight
    for j=2:2:imageWidth
        if i<imageHeight
            if j<imageWidth
               if abs(mosim(i-1,j-1,1)-mosim(i+1,j+1))>abs(mosim(i-1,j+1,1)-mosim(i+1,j-1,1))
                 mosim(i,j,1)=(mosim(i-1,j+1,1)+mosim(i+1,j-1,1))/2;
               else mosim(i,j,1)=(mosim(i-1,j-1,1)+mosim(i+1,j+1,1))/2;
               end
            else mosim(i,j,1)=(mosim(i-1,j-1,1)+mosim(i+1,j-1,1))/2;
            end
        else mosim(i,j,1)=mosim(i-1,j-1,1);
        end
    end
end
%blue channel
for i=1:2:imageHeight
    for j=2:2:imageWidth
        if i<imageHeight
            if i>1
            mosim(i,j,3)=(mosim(i+1,j,3)+mosim(i-1,j,3))/2;
            else mosim(i,j,3)=mosim(i+1,j,3);
            end
            
        else mosim(i,j,3)=mosim(i-1,j,3);
        end
    end
end
for i=2:2:imageHeight
    for j=1:2:imageWidth
        if j<imageWidth
            if j>1
                mosim(i,j,3)=(mosim(i,j-1,3)+mosim(i,j+1,3))/2;
            else mosim(i,j+1,3);
            end
        else mosim(i,j,3)=mosim(i,j-1,3);
        end
    end
end
for i=1:2:imageHeight
    for j=1:2:imageWidth
        if(i<imageHeight&& i>1 &&j<imageWidth&&j>1)
             if abs (mosim(i-1,j-1,3)-mosim(i+1,j+1,3))>abs (mosim(i-1,j+1,3)-mosim(i+1,j-1,3))
                 mosim(i,j,3)=(mosim(i-1,j+1,3)+mosim(i+1,j-1,3))/2;
             else mosim(i,j,3)= (mosim(i-1,j-1,3)+mosim(i+1,j+1,3))/2;
             end
        end 
        if(j==1 && i<imageHeight && i>1)
            mosim(i,j,3)=(mosim(i-1,j+1,3)+mosim(i+1,j+1,3))/2;
        end
        if(i==1 && j==1)
            mosim(i,j,3)=mosim(i+1,j+1,3);
        end
        if(j==imageWidth&& i>1 &&i<imageHeight)
            mosim(i,j,3)=(mosim(i-1,j-1,3)+mosim(i+1,j-1,3))/2;
        end
        if(j==imageWidth&& i==imageHeight)
            mosim(i,j,3)=mosim(i-1,j-1,3);
        end
    end
end

%green channel
for i=1:2:imageHeight
    for j=1:2:imageWidth
        if(i<imageHeight&& i>1 &&j<imageWidth&&j>1)
              if abs(mosim(i-1,j,2)-mosim(i+1,j,2))>abs(mosim(i,j+1,2)-mosim(i,j-1,2))
                  mosim(i,j,2)=(mosim(i,j+1,2)+mosim(i,j-1,2))/2;
              else mosim(i,j,2)=(mosim(i-1,j,2)+mosim(i+1,j,2))/2;
              end
        end 
        if(j==1 && i<imageHeight && i>1)
           mosim(i,j,2)=(mosim(i-1,j,2)+mosim(i+1,j,2)+mosim(i,j+1,2))/3;
        end
        if(i==1 && j==1)
            mosim(i,j,2)=(mosim(i+1,j,2)+mosim(i,j+1,2))/2;
        end
        if(j==imageWidth&& i>1 &&i<imageHeight)
            mosim(i,j,2)=(mosim(i-1,j,2)+mosim(i+1,j,2)+mosim(i,j-1,2))/3;
        end
        if(j==imageWidth&& i==imageHeight)
            mosim(i,j,2)=mosim(i-1,j-1,2);
        end
        
    end
end
for i=2:2:imageHeight
    for j=2:2:imageWidth
        if i<imageHeight
            if j<imageWidth
                if(abs(mosim(i,j-1,2)-mosim(i,j+1,2))>abs(mosim(i-1,j,2)-mosim(i+1,j,2)))
                    mosim(i,j,2)=(mosim(i-1,j,2)+mosim(i+1,j,2))/2;
                else mosim(i,j,2)=(mosim(i,j-1,2)+mosim(i,j+1,2))/2;
                end
            else mosim(i,j,2)=(mosim(i,j-1,2)+mosim(i-1,j,2)+mosim(i+1,j,2))/3;
            end
        else mosim(i,j,2)=(mosim(i,j-1,2)+mosim(i-1,j,2))/2;
        end
    end
end
