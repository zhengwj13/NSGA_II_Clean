function crowD=crowdingDistance(F1,F2,F1_Archive,F2_Archive)
%**************************************************************************
% crowdingDistance returns the crowding distance of the solutions
% corresponding to F1_Archive and F2_Archive
%
% --INPUTS--:
% F1: the first objective value of the nondominated solutions
% F2: the second objective value of the nondominated solutions
% F1_Archive: the first objective value of the archive solutions
% F2_Archive: the second objective value of the archive solutions
%
% --OUTPUT--:
% crowD: the crowding distance of the archive solutions
%**************************************************************************

nondoSize=size(F1,1);
doSize=size(F1_Archive,1);
F1C=[F1;F1_Archive];
F2C=[F2;F2_Archive];
crowD=zeros(nondoSize+doSize,1);
[s_F1,s_idx1]=sort(F1C,'descend');
crowD(s_idx1(1))=100000000000;
crowD(s_idx1(nondoSize+doSize))=100000000000;
crowD(s_idx1(2:nondoSize+doSize-1))=(s_F1(1:nondoSize+doSize-2)-s_F1(3:nondoSize+doSize))/(s_F1(1)-s_F1(nondoSize+doSize));

[s_F2,s_idx2]=sort(F2C,'descend');
crowD(s_idx2(1))=crowD(s_idx2(1))+100000000000;
crowD(s_idx2(nondoSize+doSize))=crowD(s_idx2(nondoSize+doSize))+100000000000;
crowD(s_idx2(2:nondoSize+doSize-1))=crowD(s_idx2(2:nondoSize+doSize-1))+(s_F2(1:nondoSize+doSize-2)-s_F2(3:nondoSize+doSize))/(s_F2(1)-s_F2(nondoSize+doSize));

crowD=crowD(nondoSize+1:nondoSize+doSize);