%% Compilation of Tpr - Nup153 analysis

clear all
close all
clc


px = 15;        % px in nm
pxarea = 225;   % px area in nm2

captionFontSize = 12;
format compact;

%%

cd('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data/scrambled/8bit')
[num,txt,raw]=xlsread('FileProperties.xls');
n=length(txt);

TprCircularity=[];
Nup153Circularity=[];
distances=[];

for k=1:n    %n
name=txt{k};

TprData = load(strcat(name, '_Tpr.mat'));
TprCircularity=[TprCircularity; TprData.keeperBlobsCircularityTpr'];

Nup153Data = load(strcat(name, '_Nup153.mat'));
Nup153Circularity = [Nup153Circularity; Nup153Data.keeperBlobsCircularityNup153'];

dist = load(strcat(name, '_distances.mat'));
distances = [distances; dist.d];

end

figure
subplot(1,2,1)
cEdges = 0:0.1:3;
histogram(Nup153Circularity, cEdges);
hold on
histogram(TprCircularity, cEdges);
hold off

subplot(1,2,2)
dEdges = 0:5:80;
histogram(distances, dEdges)

T1=table(TprCircularity);
writetable(T1, 'TprCircularity.txt');

T2=table(Nup153Circularity);
writetable(T2, 'Nup153Circularity.txt');

T3=table(distances);
writetable(T3, 'distances.txt');

