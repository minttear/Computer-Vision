function [ transT ] = computeT( p1,p2 )
%COMPUTET Summary of this function goes here
%   Detailed explanation goes here

n = size(p1,2);
A = zeros(2*n,9);
p2 = [p2; ones(1,n)];

I = 1:n;
A((I-1)*2+1,1:3) = p2';
A((I-1)*2+1,7:9) = -repmat(p1(1,:)',1,3) .* p2';
A(I*2,4:6) = p2';
A(I*2,7:9) = -repmat(p1(2,:)',1,3) .* p2';

[~,~,V] = svd(A);
h = V(:,end);
transT = vec2mat(h,3);

end

