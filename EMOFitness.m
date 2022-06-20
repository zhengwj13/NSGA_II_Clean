function [f1,f2]=EMOFitness(x,n,k,funcType)
%**************************************************************************
% EMOFitness calculates the function value of the individual x.
%
% --Inputs--
% x: the individual to be evaluated
% n: problem size
% k: jump size
% funcType: 
%   0 - COCZ
%   1 - LOTZ
%   3 - OneJumpZeroJump
%**************************************************************************

if funcType == 0
    f1=evalFitness(x, 0, k, n, size(x,1), 1, 1);
    f2=evalFitness(1-x, 0, k, n, size(x,1), 1, 1);
elseif funcType == 1
    f1=evalFitness(x, 3, k, n, size(x,1), 1, 1);
    f2=evalFitness(x, 8, k, n, size(x,1), 1, 1);
elseif funcType == 2
    f1=evalFitness(x, 7, k, n, size(x,1), 1, 1);
    f2=evalFitness(x, 9, k, n, size(x,1), 1, 1);
elseif funcType == 3
    f1=evalFitness(x, 6, k, n, size(x,1), 1, 1);
    f2=evalFitness(1-x, 6, k, n, size(x,1), 1, 1);
end