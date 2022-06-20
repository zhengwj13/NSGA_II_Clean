function PFsize=calPFsize(funcType,n,k,F1,F2)
% --Inputs--
% n: problem size
% k: jump size
% funcType: 
%   0 - COCZ
%   1 - LOTZ
%   2 - DLOBTZB
%   3 - OneJumpZeroJump
% F1, F2: the function values
% Outputs:
%	stopIndicator - 0 for not stop, 1 for stop

if funcType==0
    PFsize=size(unique(F1),1);
elseif funcType == 1
    mask=(F1+F2==n);
    F12=[F1 F2];
    F12test=F12(mask,:);
    PFsize=size(unique(F12test,'rows'),1);
elseif funcType == 2
%     PF1=[1:2:n-1 n];
%     PF2=[n n-1:-2:1];
%     PF=[PF1' PF2'];
%     PFtest=[F1 F2];
%     Diff=setdiff(PF,PFtest,'rows');
%     PFsize=(size(Diff,1) == 0);
elseif funcType == 3
    PF=[k 2*k:n n+k];
    nPF=setdiff([k:n+k],PF);
    F1test=unique(F1);
    PFsize=size(setdiff(F1test,nPF),1);
else
	error('Error in funcType value!');
end

