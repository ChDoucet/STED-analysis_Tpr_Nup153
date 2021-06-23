% Automatic detection of NPCs based on both Nup153 and Tpr levels
% coordinates of Nup153 positive NPCs are stored in the vector NNPC
% coordinates of Tpr positive NPCs are stored in the vector TNPC


close all
clear all
clc



%% Get titles and define parameters

conditions={'scrambled';'siElys';'siNup96';'siNup133';'siNup153';'siTpr'};


Thp=0.09;
Thm=0.12;
px=15;


m=[0;0;0;0;0;0];



for k=1:6  %6
   cd('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data')

    folder=conditions{k};
    [num,txt,raw]=xlsread('FileProperties_Nup153_Tpr.xlsx',folder);
    
 
n=length(txt);
if m(k)<n
for j=m(k)+1:n   %n

name=txt{j}

cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data/',folder))
P=mat2gray(imread(strcat(name,'_Nup153.tif')));
M=mat2gray(imread(strcat(name,'_Tpr.tif')));
B=zeros(size(P));
K=cat(3,M,P,B);

% detect pores
cd('/Users/christine/Documents/Data/STED/Pore_analysis')
TNPC=find_NPCs_STED_v3(M,Thm);  % pores detected based on Tpr signal
NNPC=find_NPCs_STED_v3(P,Thp);  % pores detected based on Nup153 signal
cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Results/',folder))
save(strcat(name,'_pores.mat'),'NNPC','TNPC');

% visualization

figure
title(name)
imshow(K)
hold on
plot(TNPC(:,1),TNPC(:,2),'*y');
plot(NNPC(:,1),NNPC(:,2),'+c');
hold off
saveas(gca,strcat(name,'.fig'),'fig');
%close
end
end
end

