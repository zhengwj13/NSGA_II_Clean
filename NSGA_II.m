function runtime=NSGA_II(n,k,N,parentChoice,pChoice,m,beta,Max_gen,funcType,Totaltime)
%**************************************************************************
% NSGA-II implements the NSGA-II.
%
% --Inputs--
% n: problem size
% k: jump size
% N: population size
% parentChoice: different choices of the parent selection
%   0 - each individual becomes the parent once
%   1 - N times choosing a parent uniformly at random
%   2 - binary tournament selection without replacement
%   3 - binary tournament selection in Deb's code
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
endFoundGen=zeros(Totaltime,1);
PFsizeHis=zeros(Totaltime, Max_gen);
F1His=cell(Totaltime, 1);
F2His=cell(Totaltime, 1);
succN=0;      % number of success

%% Main Body
while time<=Totaltime
    P=randi([0,1],N,n); % Initialization
    [F1,F2]=EMOFitness(P,n,k,funcType);
    [P,F1,F2,rankInfo,PcrowD]=cal_Idx_crowdDistance(P,n,F1,F2,N,N);
    Q=P;
    
    FES=N;
    gen=1;
    cnt0n=0;
    
    while gen <= Max_gen
        oldF=[F1 F2]; % Test removing some front
        
       %% Record the zise of the current PF, and 1000-th F1, F2
        PFsizeHis(time,gen)=calPFsize(funcType,n,k,F1,F2);
        if gen==3000
            F1His{time}=F1';
            F2His{time}=F2';
        end
        
        if mod(gen,10000)==0
        fprintf('Current Pareto front size is %d when gen=%d\n',PFsizeHis(time,gen),gen);
        end
        
        %% Check whether two ends are all found
        if (cnt0n == 0) && (size(setdiff(0,F1),2) == 0) && (size(setdiff(n,F1),2) == 0)
            endFoundGen(time,1)=gen;
            cnt0n=1;
        end
        
        stopIndicator=boolStop(funcType,n,k,F1,F2);
		if stopIndicator==1
            fprintf('**In the %dth run, find the optima when gen=%d, FES=%d**\n\n',time,gen,FES);
            runtime(time,1)=gen;
            runFES(time,1)=FES;
            PFsizeHis(time,gen:Max_gen)=PFsizeHis(time,gen);
            succN=succN+1;
            break;
        end
        
        selP=selection(P, rankInfo, PcrowD,n,parentChoice);
        Q=mutation(selP,n,pChoice,m,beta);
        [QF1,QF2]=EMOFitness(Q,n,k,funcType);
        FES=FES+N;
        
        PQ=[P;Q];
        PQF1=[F1;QF1];
        PQF2=[F2;QF2];
        
        randPer=randperm(size(PQ,1)); % random permutation
        PQ=PQ(randPer,:);
        PQF1=PQF1(randPer,:);
        PQF2=PQF2(randPer,:);
        
        [P,F1,F2,rankInfo,PcrowD]=cal_Idx_crowdDistance(PQ,n,PQF1,PQF2,2*N,N);
        
        if size(setdiff(oldF,[F1 F2],'rows'),1) > 0
            fprintf('Warning: In the %d-th generation, some Pareto front is deleted!\n',gen);
        end
        
        gen = gen+1;
        if gen>Max_gen
            fprintf('!!In the %dth run, we cannot find the optima within %d generations!!\n',time,Max_gen);
            runtime(time,1)=Max_gen;
            runFES(time,1)=Max_gen*N;
        end
        
    end
    time=time+1;
end

succRate=succN/Totaltime;
fprintf('For (n,k)=(%d, %d), the success time is %d\n', n,k,succN);
fprintf('Average runtime (function evaluation time) is %d\n',mean(runFES));
