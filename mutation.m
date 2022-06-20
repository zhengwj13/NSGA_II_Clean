function y=mutation(x,n,pChoice,m,beta)
%**************************************************************************
% This function mutate the invidual x
%
% --Inputs--
% x: the individual for mutation
% n: problem size
% pChoice: different choice of the mutation proability
%   0 - one-bit mutation
%   1 - bit-wise mutation with flipping prob m/n
%   2 - heavy-tailed mutation operator
% m: for pChoice=1
% beta: for pChoice=2
%**************************************************************************

if pChoice == 0
    y=x;
    idxChosen=randi([1,n],size(x,1),1);
    for i=1:size(x,1)
        y(i,idxChosen(i))=1-x(i,idxChosen(i));
    end
    return;
elseif pChoice == 1
    mask=rand(size(x,1),n)<=m/n;
elseif pChoice == 2
    alpha=generateAlpha(n,beta);
    mask=rand(size(x,1),n)<=alpha/n;
end
y=x;
y(mask)=1-x(mask);