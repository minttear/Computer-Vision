function [albedoImage, surfaceNormals] = photometricStereo(imArray, lightDirs)
% PHOTOMETRICSTEREO compute intrinsic image decomposition from images
%   [ALBEDOIMAGE, SURFACENORMALS] = PHOTOMETRICSTEREO(IMARRAY, LIGHTDIRS)
%   comptutes the ALBEDOIMAGE and SURFACENORMALS from an array of images
%   with their lighting directions. The surface is assumed to be perfectly
%   lambertian so that the measured intensity is proportional to the albedo
%   times the dot product between the surface normal and lighting
%   direction. The lights are assumed to be of unit intensity.
%
%   Input:
%       IMARRAY - [h w n] array of images, i.e., n images of size [h w]
%       LIGHTDIRS - [n 3] array of unit normals for the light directions
%
%   Output:
%        ALBEDOIMAGE - [h w] image specifying albedos
%        SURFACENORMALS - [h w 3] array of unit normals for each pixel
%
% Author: Subhransu Maji
%
% Acknowledgement: Based on a similar homework by Lana Lazebnik
[h,w,n]=size(imArray);
A=permute(imArray,[3,2,1]);
A=reshape(A,[n,h*w]);
g=lightDirs\A;
g=reshape(g,[3,w,h]);
g=permute(g,[3,2,1]);
temp=g.^2;
sqal=temp(:,:,1)+temp(:,:,2)+temp(:,:,3);
albedoImage=sqrt(sqal);
fun=@(g,albedoImage) g./albedoImage;
surfaceNormals=bsxfun(fun,g,albedoImage);





%%% implement this %% 