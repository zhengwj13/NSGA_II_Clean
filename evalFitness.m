function xFit = evalFitness(X, funcType, k, D, N, dVal, alpha)
% This function is the fitness evaluation code
%
% Inputs:
%	X		: the variable whose fitness we want to evaluate 
%	funcType: the different function type we want to discuss
%		0 - OneMax
%		1 - Royal Road Function
%		2 - BINVAL
%		5 - Between 0 and 2, f(x) = \sum_{i=1}^D \alpha^i x_i
%       6 - Jump
%       7 - DeceivingLeadingBlocks
%       8 - TrailingZeros
%	k		: the block size in Royal Road function
%	D		: the dimension size
%	N		: the population size
%	dVal	: true value of each dimension
% Outputs:
%	xFit	: the fitness on variable X

%% Check D
if size(X,1)~=N || size(X,2) ~= D
    error('Error in the input of evalFitness!');
end

%% Main body
xFit=zeros(N,1);
if funcType==0
	%% The function is OneMax
	xFit=sum(X,2);
elseif funcType==1
	%% The function is Royal Road
	nBlock=floor(D/k);
	xFit(N,1)=0;
	for i=1:N
		for j=1:nBlock
			xFit(i)=xFit(i)+prod(X(i,(j-1)*k+1:j*k));
        end
	end
elseif funcType==2
	%% The function is BINVAL
	dValP=repmat(dVal,N,1);
	xFit=sum(dValP.*X,2);
elseif funcType==3
	%% The function is LeadingOnes
	for i=1:N
		if sum(X(i,:))==D
			xFit(i)=D;
		else
			for j=1:D
				if X(i,j)==0
					xFit(i)=j-1;
					break;
				end
			end
		end
	end
elseif funcType==4
	%% The function is Needle
	mask=sum(X,2)==D;
	xFit(mask,1)=1;
elseif funcType==5
	%% The function is between OneMax and BinVal
	for i=1:D
		Alpha(i)=alpha^i;
	end
	xFit=X*Alpha';
elseif funcType == 6
    %% The funtion is Jump funtion with parameter k
    xFit=sum(X,2);
    mask = (xFit > D-k) & (xFit < D);
    xFit(mask)=D-xFit(mask);
    xFit(~mask)=xFit(~mask)+k;
elseif funcType == 7
    %% The function is DeceivingLeadingBlocks
    xFit=DeceptiveLeadingBlocks(X,D,N);
elseif funcType == 8
    %% The function is TrailingZeros
    for i=1:N
		if sum(X(i,:))==0
			xFit(i)=D;
		else
			for j=D:-1:1
				if X(i,j)==1
					xFit(i)=D-j;
					break;
				end
			end
		end
    end
elseif funcType == 9
    %% The function is DeceivingTrackingZeroBlocks
    xFit=DeceptiveTrackingZeroBlocks(X,D,N);
else
	error('Error in funcType value!');
end

