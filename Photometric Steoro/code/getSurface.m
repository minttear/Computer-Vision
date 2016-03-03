function  heightMap = getSurface(surfaceNormals, method)
% GETSURFACE computes the surface depth from normals
%   HEIGHTMAP = GETSURFACE(SURFACENORMALS, IMAGESIZE, METHOD) computes
%   HEIGHTMAP from the SURFACENORMALS using various METHODs. 
%  
% Input:
%   SURFACENORMALS: height x width x 3 array of unit surface normals
%   METHOD: the intergration method to be used
%
% Output:
%   HEIGHTMAP: height map of object
fx=surfaceNormals(:,:,1)./surfaceNormals(:,:,3)*-1;
fy=surfaceNormals(:,:,2)./surfaceNormals(:,:,3)*-1;
[h,w,n]=size(surfaceNormals);
switch method
    case 'column'
        %%% implement this %%%
        firstcolumn=fy(:,1);
        firstcolumn=cumsum(firstcolumn);
        intefy=repmat(firstcolumn,1,w);
        intefx=cumsum(fx,2);
        heightMap=intefx+intefy;
        
    case 'row'
        %%% implement this %%%
        firstrow=fx(1,:);
        firstrow=cumsum(firstrow);
        intefx=repmat(firstrow,h,1);
        intefy=cumsum(fy);
        heightMap=intefx+intefy;
    case 'average'
        %%% implement this %%%
        firstrow=fx(1,:);
        firstrow=cumsum(firstrow);
        intefx=repmat(firstrow,h,1);
        intefy=cumsum(fy);
        heightMap1=intefx+intefy;
        firstcolumn=fy(:,1);
        firstcolumn=cumsum(firstcolumn);
        intefy=repmat(firstcolumn,1,w);
        intefx=cumsum(fx,2);
        heightMap2=intefx+intefy;
        heightMap= (heightMap1+heightMap2)/2;
    case 'random'
        %implement this%%%
        heightMap=zeros(h,w);
        for i=1:h
            for j=1:w
                amount=0;
                times=100;
                for count=1:1:times;
                    sum=fx(1,1)+fy(1,1);
                    m=1;
                    n=1;
                    while m~=i||n~=j
                        if m==i
                           
                            n=n+1;
                            sum=sum+fx(m,n);
                           
                        else if n==j
                            
                            m=m+1;
                            sum=sum+fy(m,n);
                           
                        else
                              if round(rand)==1
                                  
                                  m=m+1;
                                  sum=sum+fy(m,n);
                              else 
                                
                                n=n+1;
                                sum=sum+fx(m,n);
                              end
                            end
                        end
                    end
                    amount=amount+sum;
                end
                heightMap(i,j)=amount/times;
            end
        end
            
                
                   
                 
                    
                    
end

