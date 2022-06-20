function [P,F1,F2,rankInfo,PcrowD]=cal_Idx_crowdDistance(PQ,n,PQF1,PQF2,M,N)
%**************************************************************************
% This function returns the information about the the selected N out M individuals. 
% Input
%   PQ:     Population
%   n:      Problem size
%   PQF1:   First function value of PQ
%   PQF2:   Second function value of PQ
%   M:      Population size of PQ
%   N:      Survived population size
% Output
%   P:      Survived population
%   F1:     First function value of P
%   F2:     Second function value of P
%   rankInfo£ºrankInfo
%   PcrowD: Crowding distance pf P 
%**************************************************************************

if size(PQ,1) ~= M || size(PQ,2) ~= n
    error('Check the dimensions of the population\n!');
end
PQDN=zeros(M,1);
RsizeInd=[1:M];

%% Initialize the dominated set index
S=cell(1,M);
for i=1:M
    S{i}=[];
end

%% Find the first front and dominated set
for i=1:M
    nmask1=((PQF1 < PQF1(i)) & (PQF2 <= PQF2(i)));
    nmask2=((PQF1 <= PQF1(i)) & (PQF2 < PQF2(i)));
    nmask=max(nmask1, nmask2);
    if size(PQDN,1) ~= size(nmask,1)
        fprint('Error!')
    end
    S{i}=[RsizeInd(nmask)];
    PQDN=PQDN+nmask;
end

%% Initialize the FS set
maxPQDN=max(PQDN);
FS=cell(1,maxPQDN+1);
for i=1:maxPQDN+1
    FS{i}=[];
end
FS{1}= [RsizeInd(PQDN==0)];

%% Store the other FS front
for i=1:maxPQDN
    for j=1:size(FS{i},2)
        jdIdx=S{FS{i}(j)}; % Index for decreasing DN by 1
        for jd=1:size(jdIdx,2)
            PQDN(jdIdx(jd))=PQDN(jdIdx(jd))-1;
            if PQDN(jdIdx(jd))==0
                FS{i+1}=[FS{i+1} jdIdx(jd)];
            end
        end
    end
end

%% Calculate the crowding distance for each FS front until the accumulative size is at least N
Ncon=0;
crowD=zeros(M,1);
keepIdx=[]; % Index to survive
rankInfo=[]; % rank info
for i=1:maxPQDN+1
    crowD(FS{i})=crowdingDistance([],[],PQF1(FS{i}),PQF2(FS{i}));
    Ncon=Ncon+size(FS{i},2);
    if Ncon >= N
        break;
    end
    keepIdx=[keepIdx FS{i}];
    if i==1
        rankInfo=[ones(1,Ncon)];
    else
        rankInfo=[rankInfo i*ones(1,size(FS{i},2))];
    end
end

if size(rankInfo,2) < N
    rankInfo=[rankInfo i*ones(1,N-size(rankInfo,2))];
end

[s_c,s_idxc]=sort(crowD(FS{i}),'descend');
keepIdx=[keepIdx FS{i}(s_idxc(1:size(FS{i},2)+N-Ncon))];

P=PQ(keepIdx,:);
F1=PQF1(keepIdx,:);
F2=PQF2(keepIdx,:);
PcrowD=crowD(keepIdx,:);