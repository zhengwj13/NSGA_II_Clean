clc;
clear all;
close all;
format long;
warning('off');

reset(RandStream.getGlobalStream,sum(100*clock));

%% Independent run setting
Totaltime=50;

%% Parameter initialization (Don't change here)
k=4;
parentChoice=3;         %   0 - each individual becomes the parent once
                        %   1 - N times choosing a parent uniformly at random
                        %   2 - binary tournament selection without
                        %   replacement
                        %   3 - binary tournament selection in Deb's code
m=1;
pChoice=1;              %   0 - one-bit mutation
                        %   1 - bit-wise mutation with flipping prob m/n
beta=1.5;
funcType=0;				%   0 - OneMinMax
                        %   1 - LOTZ

%% Main body
for funcType =0:1:0
    if funcType == 0
        nSet=[100:100:400];
    elseif funcType == 1
        nSet=[30:30:120];
    else
        error('Check function type!\n');
    end
    
    for nCnt=3:1:3
        n=nSet(nCnt);
        Max_gen_gsemo=n^4;
        fprintf('<<<< Now optimizes');
        if funcType==0
            fprintf(' OneMinMax>>>>\n');
            Nfact=[1 1.5 2 4 8];
            Max_gen=4000;
        elseif funcType==1
            fprintf(' LOTZ>>>>\n');
            Nfact=[8 4 2 1];
            Max_gen=n^4;
        else
            error('Error funcType! Pls set 0 for COCZ, 1 for LOTZ!\n');
        end
        fprintf('GSEMO with (pChoice,m,beta)=(%d,%d,%f) with (n,k)=(%d,%d) in %d generations\n',pChoice,m,beta,n,k,Max_gen);
        runtime=GSEMO(n,k,pChoice,m,beta,Max_gen_gsemo,funcType,Totaltime);
        
        fprintf('\n Now NSGA-II with Deb binary tournament selection and standard bit-wise mutation in different population sizes N\n');
        for fac=1:1:size(Nfact,2)
            N=ceil(Nfact(fac)*(n+1));
            if Nfact(fac)==1
                Totaltime=20;
                if funcType==0
                    Max_gen=3000;
                elseif funcType==1
                    Max_gen=5000;
                end
            end
            for parentChoice=3:1:3
                for pChoice=1:1:1
                    fprintf('<<<< NSGA-II with N=%d, parentChoice=%d, and pChoice=%d optimizes in %d generations>>>>\n',N,parentChoice,pChoice,Max_gen);
                    runtime2=NSGA_II(n,k,N,parentChoice,pChoice,m,beta,Max_gen,funcType,Totaltime);
                end
            end
        end
    end
end