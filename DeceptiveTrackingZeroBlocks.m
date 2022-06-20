function dlb=DeceptiveTrackingZeroBlocks(X,D,N)
%
% Inputs:
%	X		: the variable whose fitness we want to evaluate 
%	D		: the dimension size
%	N		: the population size
% Outputs:
%	dlb     : the DLB vaule on variable X

%% Initialization
if mod(D,2) ~= 0
    error('The dimension size %d is not even in DeceptiveTrackingZeroBlocks()',D);
end
dlb=D*ones(N,1);
phi=zeros(N,1);

%% Calculate phi(x)
for i=D/2-1:-1:0
    temp=1-X(:,2*i+1:D);
    phi=phi+prod(temp,2);
end

%% Calculate DTZB
value4Mask=-3*ones(N,1);
for n=1:N
    if phi(n) ~= D/2
        value4Mask(n)=1-X(n,D-2*phi(n)-1)+1-X(n,D-2*phi(n));
    end
end
if sum(value4Mask>=2) ~= 0
    error('Wrong in DeceptiveTrackingZeroBlocks()');
end
mask1=value4Mask==0;
mask2=value4Mask==1;
dlb(mask1)=2*phi(mask1)+1;
dlb(mask2)=2*phi(mask2);