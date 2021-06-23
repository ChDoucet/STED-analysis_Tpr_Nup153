% calculates densities of Nup153 positive and Tpr positive pores

close all
clear all
clc



%% Get titles and define parameters

conditions={'scrambled';'siElys';'siNup96';'siNup133';'siNup153'; 'siTpr'};


m=[0;0;0;0;0;0];



for k=1:6 %3
   cd('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data')

    folder=conditions{k};
    [num,txt,raw]=xlsread('FileProperties_Nup153_Tpr.xlsx',folder);
    
 
n=length(txt);

Nup153_density=[];
Tpr_density=[];

for j=m(k)+1:n    %n
close all

name=txt{j}


% load pores

cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Results/',folder))
data=load(strcat(name,'_pores.mat'));
NNPC2=data.NNPC;
TNPC2=data.TNPC;

% select pores within ROI
NNPCs=[];
TNPCs=[];

cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data/',folder))
ROI=load(strcat(name,'_ROI.mat'));
pos1=ROI.pos1;
pos2=ROI.pos2;
NucArea=ROI.NucArea;

%if isempty(pos2)==0

N=length(NNPC2);
I=length(TNPC2);

for r=1:N
    if inpolygon(NNPC2(r,1), NNPC2(r,2),pos1(:,1),pos1(:,2))==1 & inpolygon(NNPC2(r,1), NNPC2(r,2),pos2(:,1),pos2(:,2))==0
NNPCs=[NNPCs; [NNPC2(r,1),NNPC2(r,2)]];
    end
end

for r=1:I
    if inpolygon(TNPC2(r,1), TNPC2(r,2),pos1(:,1),pos1(:,2))==1 & inpolygon(TNPC2(r,1), TNPC2(r,2),pos2(:,1),pos2(:,2))==0
TNPCs=[TNPCs; [TNPC2(r,1),TNPC2(r,2)]];
    end
end

Nup153_density=[Nup153_density;length(NNPCs)/NucArea];
Tpr_density=[Tpr_density;length(TNPCs)/NucArea];


cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Results/',folder))
save(strcat(name,'_densities_Nup153_Tpr.mat'),'NNPCs','TNPCs');
end

save(strcat(folder,'_densities_Nup153_Tpr.mat'),'Nup153_density','Tpr_density');
clear Nup153_density Tpr_density

end
