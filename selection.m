function selP=selection(P,rankInfo, PcrowD,n,parentChoice)
%**************************************************************************
% This function selects the parent to be mutated
%
% --Inputs--
% P:        the current population
% rankInfo: rank information
% PcrowD:   crowding distance
% n:        problem size
% parentChoice: different choices of the parent selection
%   0 - each individual becomes the parent once
%   1 - N times choosing a parent uniformly at random
%   2 - binary tournament selection without replacement
%   3 - binary tournament selection in Deb's code
%**************************************************************************

if size(P,2)~=n
    error('Check P dimension!\n');
end

if parentChoice == 0
    selP=P;
elseif parentChoice == 1
    ind=randi(size(P,1),size(P,1),1);
    selP=P(ind,:);
elseif parentChoice == 2
    selP=P;
    for i=1:size(P,1)
        randP=randperm(size(P,1));
        if rankInfo(randP(1)) < rankInfo(randP(2))
            selP(i,:)=P(randP(1),:);
        elseif rankInfo(randP(1)) > rankInfo(randP(2))
            selP(i,:)=P(randP(2),:);
        else
            if PcrowD(randP(1)) > PcrowD(randP(2))
                selP(i,:)=P(randP(1),:);
            elseif PcrowD(randP(1)) < PcrowD(randP(2))
                selP(i,:)=P(randP(2),:);
            else
                irand=randi(2,1,1);
                selP(i,:)=P(randP(irand),:);
            end
        end
    end
elseif parentChoice == 3
    selP=P;
    randP1=randperm(size(P,1));
    randP2=randperm(size(P,1));
    
    sizeEven=floor(size(P,1)/2)*2;
    for i=1:4:sizeEven
        if rankInfo(randP1(i)) < rankInfo(randP1(i+1))
            selP(i,:)=P(randP1(i),:);
        elseif rankInfo(randP1(i)) > rankInfo(randP1(i+1))
            selP(i,:)=P(randP1(i+1),:);
        else
            if PcrowD(randP1(i)) > PcrowD(randP1(i+1))
                selP(i,:)=P(randP1(i),:);
            elseif PcrowD(randP1(i)) < PcrowD(randP1(i+1))
                selP(i,:)=P(randP1(i+1),:);
            else
                irand=randi([0 1],1,1);
                selP(i,:)=P(randP1(irand+i),:);
            end
        end
        if i+3<=size(P,1)
            if rankInfo(randP1(i+2)) < rankInfo(randP1(i+3))
                selP(i+1,:)=P(randP1(i+2),:);
            elseif rankInfo(randP1(i+2)) > rankInfo(randP1(i+3))
                selP(i+1,:)=P(randP1(i+3),:);
            else
                if PcrowD(randP1(i+2)) > PcrowD(randP1(i+3))
                    selP(i+1,:)=P(randP1(i+2),:);
                elseif PcrowD(randP1(i+2)) < PcrowD(randP1(i+3))
                    selP(i+1,:)=P(randP1(i+3),:);
                else
                    irand=randi([2 3],1,1);
                    selP(i+1,:)=P(randP1(irand+i),:);
                end
            end
            
            if rankInfo(randP2(i)) < rankInfo(randP2(i+1))
                selP(i+2,:)=P(randP2(i),:);
            elseif rankInfo(randP2(i)) > rankInfo(randP2(i+1))
                selP(i+2,:)=P(randP2(i+1),:);
            else
                if PcrowD(randP2(i)) > PcrowD(randP2(i+1))
                    selP(i+2,:)=P(randP2(i),:);
                elseif PcrowD(randP2(i)) < PcrowD(randP2(i+1))
                    selP(i+2,:)=P(randP2(i+1),:);
                else
                    irand=randi([0 1],1,1);
                    selP(i+2,:)=P(randP2(irand+i),:);
                end
            end

            if rankInfo(randP2(i+2)) < rankInfo(randP2(i+3))
                selP(i+3,:)=P(randP2(i+2),:);
            elseif rankInfo(randP2(i+2)) > rankInfo(randP2(i+3))
                selP(i+3,:)=P(randP2(i+3),:);
            else
                if PcrowD(randP2(i+2)) > PcrowD(randP2(i+3))
                    selP(i+3,:)=P(randP2(i+2),:);
                elseif PcrowD(randP2(i+2)) < PcrowD(randP2(i+3))
                    selP(i+3,:)=P(randP2(i+3),:);
                else
                    irand=randi([2 3],1,1);
                    selP(i+3,:)=P(randP2(irand+i),:);
                end
            end
        else
            if rankInfo(randP2(i)) < rankInfo(randP2(i+1))
                selP(i+1,:)=P(randP2(i),:);
            elseif rankInfo(randP2(i)) > rankInfo(randP2(i+1))
                selP(i+1,:)=P(randP2(i+1),:);
            else
                if PcrowD(randP2(i)) > PcrowD(randP2(i+1))
                    selP(i+1,:)=P(randP2(i),:);
                elseif PcrowD(randP2(i)) < PcrowD(randP2(i+1))
                    selP(i+1,:)=P(randP2(i+1),:);
                else
                    irand=randi([0 1],1,1);
                    selP(i+1,:)=P(randP2(irand+i),:);
                end
            end
        end
    end
    
    if sizeEven<size(P,1)
        randP=randperm(size(P,1));
        if rankInfo(randP(1)) < rankInfo(randP(2))
            selP(size(P,1),:)=P(randP(1),:);
        elseif rankInfo(randP(1)) > rankInfo(randP(2))
            selP(size(P,1),:)=P(randP(2),:);
        else
            if PcrowD(randP(1)) > PcrowD(randP(2))
                selP(size(P,1),:)=P(randP(1),:);
            elseif PcrowD(randP(1)) < PcrowD(randP(2))
                selP(size(P,1),:)=P(randP(2),:);
            else
                irand=randi(2,1,1);
                selP(size(P,1),:)=P(randP(irand),:);
            end
        end
    end
end