close all
clear all
clc



%% Get titles and define parameters
cd('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr')

conditions={'scrambled';'siElys';'siNup96';'siNup133';'siNup153'; 'siTpr'};
px=15;

for k=4:4   %3
   cd('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data')
    folder=conditions{k};
    [num,txt,raw]=xlsread('FileProperties_Nup153_Tpr.xlsx',folder);  
    
m=[0;0;0;0;0;0];

n=length(txt);

if m(k)<n
for j=m(k)+1:n    %n

name=txt{j}

cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data/',folder))
P=mat2gray(imread(strcat(name,'_Nup153.tif')));
M=mat2gray(imread(strcat(name,'_Tpr.tif')));
B=zeros(size(P));
K=cat(3,M,P,B);

cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Results/',folder))
data=load(strcat(name,'_pores.mat'));
NNPC3=data.NNPC;
TNPC2=data.TNPC;

figure
imshow(K);
hold on
plot(TNPC2(:,1),TNPC2(:,2),'*y')
plot(NNPC3(:,1),NNPC3(:,2),'+c')
hold off




h1=imfreehand(gca);
pos1=getPosition(h1);
bw1=createMask(h1);

h2=imfreehand(gca);
pos2=getPosition(h2);
bw2=createMask(h2);
ibw2=~bw2;

BW=bw1.*ibw2;

NucArea=bwarea(BW)*px*px*1e-6;  % area in um2


cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data/',folder))
save(strcat(name,'_ROI.mat'),'h1','h2','pos1','pos2','NucArea');
end
end



end

