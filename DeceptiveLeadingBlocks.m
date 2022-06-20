function dlb=DeceptiveLeadingBlocks(X,D,N)
%
% Inputs:
%	X		: the variable whose fitness we want to evaluate 
%	D		: the dimension size
%	N		: the population size
% Outputs:
%	dlb     : the DLB vaule on variable X

%% Initialization
if mod(D,2) ~= 0
    error('The dimension size %d is not even in DeceptiveLeadingBlocks()',D);
end
dlb=D*ones(N,1);
phi=zeros(N,1);

%% Calculate phi(x)
for i=1:D/2
    temp=X(:,1:2*i);
    phi=phi+prod(temp,2);
end

%% Calculate dlb
value4Mask=3*ones(N,1);
for n=1:N
    if phi(n) ~= D/2
        value4Mask(n)=X(n,2*phi(n)+1)+X(n,2*phi(n)+2);
    end
end
mask1=value4Mask==0;
mask2=value4Mask==1;
dlb(mask1)=2*phi(mask1)+1;
dlb(mask2)=2*phi(mask2);