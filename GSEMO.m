function runtime=GSEMO(n,k,pChoice,m,beta,Max_gen,funcType,Totaltime)
%**************************************************************************
% GSEMO is the implementation of GSEMO, which allows different choices of
% the mutation probability.
%
% --Inputs--
% n: problem size
% k: jump size
% pChoice: different choice of the mutation proability
%   0 - one-bit mutation
%   1 - bit-wise mutation with flipping prob m/n
%   2 - heavy-tailed mutation operator
% m: for pChoice=1
% beta: for pChoice=2
% Max_gen: the maximal generation budget
% funcType: 
%   0 - OneMinMax
%   1 - LOTZ
%   3 - OneJumpZeroJump
% Totaltime: number of independent runs
%**************************************************************************

tic;
time=1;

%% History Collections
runtime=zeros(Totaltime,1);
runFES=zeros(Totaltime,1);
succN=0;      % number of success

%% Main Body
while time<=Totaltime
    x=randi([0,1],1,n); % Initialization
    P=[x];
    [f1,f2]=EMOFitness(x,n,k,funcType);
    F1=[f1];
    F2=[f2];
    FES=1;
    gen=1;
    
    while gen <= Max_gen
        ind=randi(size(P,1));
        y=mutation(P(ind,:),n,pChoice,m,beta);
        [f1,f2]=EMOFitness(y,n,k,funcType);
        FES=FES+1;
        MW=((F1>=f1)+(F2>=f2))>1; % (f1,f2) is weakly dominated by some element
        if sum(MW)==0
            M=((F1<=f1)+(F2<=f2))>1; % (f1,f2) dominates some elements
            IND=[1:size(F1,1)];
            SIND=IND(M==0);
            P=[P(SIND,:);y];

            F1=[F1(SIND,:);f1];
            F2=[F2(SIND,:);f2];
            
            stopIndicator=boolStop(funcType,n,k,F1,F2);
            if stopIndicator==1
                fprintf('**In the %dth run, find the optima when gen=%d, FES=%d**\n\n',time,gen,FES);
                runtime(time,1)=gen;
                runFES(time,1)=FES;
                succN=succN+1;
                break;
            end
        end
        
        gen = gen+1;
        if gen>Max_gen
			fprintf('!!In the %dth run, we cannot find the optima within %d generations!!\n',time,Max_gen);
            runtime(time,1)=Max_gen;
			runFES(time,1)=Max_gen;
		end
        
    end
    time=time+1;
end

succRate=succN/Totaltime;
fprintf('For (n,k)=(%d, %d), the success time is %d\n', n,k,succN);
fprintf('Average runtime (function evaluation time) is %d\n',mean(runFES));
