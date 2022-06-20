function alpha=generateAlpha(n,beta)
%**************************************************************************
% This function calculates the C value in the discrete power-law
% distribution in Benjamin Doerr, Huu Phuoc Le, Regis Makhmara, and Ta Duy 
% Nguyen. Fast genetic algorithms. In Genetic and Evolutionary Computation 
% Conference, GECCO 2017, pages 777â€?84, 2017.
%
% --Inputs--
% n: problem size
% beta: for pChoice=2
%**************************************************************************

tC=[1:n/2].^(-beta);
C=sum(tC);
eC=tC/C;
pC=eC;

a=rand(1);
if a <= pC(1)
    alpha=1;
else
    for i=2:n/2
        pC(i)=pC(i-1)+eC(i);
        if a <= pC(i)
            alpha=i;
            break;
        end
    end
end





