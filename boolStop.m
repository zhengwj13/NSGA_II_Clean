function stopIndicator=boolStop(funcType,n,k,F1,F2)
% --Inputs--
% x: the individual to be evaluated
% n: problem size
% k: jump size
% funcType: 
%   0 - COCZ
%   1 - LOTZ
%   2 - DLOBTZB
%   3 - OneJumpZeroJump
% Outputs:
%	stopIndicator - 0 for not stop, 1 for stop

if funcType==0
    PF=[0:n];
    F1test=unique(F1);
    PFT=setdiff(PF,F1test);
    stopIndicator=(size(PFT,2) == 0);
elseif funcType == 1
    PF=[0:n];
    mask=(F1+F2==n);
    tF1=F1(mask);
    F1test=unique(tF1);
    PFT=setdiff(PF,F1test);
    stopIndicator=(size(PFT,2) == 0);
elseif funcType == 2
    PF1=[1:2:n-1 n];
    PF2=[n n-1:-2:1];
    PF=[PF1' PF2'];
    PFtest=[F1 F2];
    Diff=setdiff(PF,PFtest,'rows');
    stopIndicator=(size(Diff,1) == 0);
elseif funcType == 3
    PF=[k 2*k:n n+k];
    F1test=unique(F1);
    PFT=setdiff(PF,F1test);
    stopIndicator=(size(PFT,2) == 0);
else
	error('Error in funcType value!');
end

