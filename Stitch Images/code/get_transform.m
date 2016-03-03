function [bestT, num_inliers, avg_residual] = get_transform(x1, y1, x2, y2)

	% Do RANSAC to determine the best transformation between the matched coordinates
	% provided by (x1,y1,x2,y2).
   
	% Return the transformation, the number of inliers, and average residual
    p1=vertcat(x1,y1);
    p2=vertcat(x2,y2);
    M=size(x1,2)
    N=4;
    bestT=[];
    num_inliers=0;
    nIter=3000;
    tol=0.01;
    avg_residual=0;
    for i=1:nIter
        randomIdx=randperm(M,N);
        randomP1x=x1(:,randomIdx);
        randomP1y=y1(:,randomIdx);
        randomP1=vertcat(randomP1x,randomP1y);
        randomP2x=x2(:,randomIdx);
        randomP2y=y2(:,randomIdx);
        randomP2=vertcat(randomP2x,randomP2y);
        transT=computeT(randomP1,randomP2);
       %do the transform
        warpedP2=transT*[p2;ones(1,M)];
        %normalize
        warpedP2 = warpedP2 ./ repmat(warpedP2(3,:),3,1);
        warpedP2 = warpedP2(1:2,:);
        
        error=p1-warpedP2;
        E = sqrt(sum(error.*error, 1)) / M;
        idx=(E<tol);
        num=sum(idx);
        if num>num_inliers
            selectedP1=p1(:,idx);
            selectedP2=p2(:,idx);
            bestT = computeT(selectedP1,selectedP2);
            num_inliers=num;
            avg_residual=sum(E)/M;
            
        end
        
    end
        
end
