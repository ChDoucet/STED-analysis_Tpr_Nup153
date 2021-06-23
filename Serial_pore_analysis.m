close all
clear all
clc



%% Get titles and define parameters

conditions={'scrambled';'siNup153';'siTpr'};


m=[0;0;0];



for k=1:3 %3
   cd('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data')

    folder=conditions{k};
    [num,txt,raw]=xlsread('FileProperties_Nup153_Tpr.xlsx',folder);
    
 
n=length(txt);

for j=m(k)+1:n    %n
close all

name=txt{j}

cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data/',folder))
P=mat2gray(imread(strcat(name,'_Nup153.tif')));
M=mat2gray(imread(strcat(name,'_Tpr.tif')));
B=zeros(size(P));
K=cat(3,M,P,B);



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



% define parameters
l=150;              % length of the intensity profile (in nm) is 2l
bin=21;             % binning of the intensity profile
px=15;              % pixel size in nm

%% analyze Nup153 & Tpr profiles in mature NPCs
%
N=length(NNPCs);

Nup153_Profile=[];
Tpr_Profile=[];

diameter=[];
Nup153_results=[];
Nup153_FWHM=[];
Tpr_results=[];
Tpr_FWHM=[];
Nup153_amplitude=[];
Tpr_amplitude=[];

%figure
%subplot(1,2,1)
%imshow(P)


for i=1:N %N
    POM_Prof=[];
    Mab_Prof=[];
    
    xo=NNPCs(i,1); yo=NNPCs(i,2);

     cd('/Users/christine/Documents/Data/STED/Pore_analysis')
    for a=0:pi/20:19*pi/20      %
        
    [xi,yi,x,Profile_a1]=intensityPlot(P,xo,yo,a,l,bin,px);
    [xi,yi,x,Profile_a2]=intensityPlot(M,xo,yo,a,l,bin,px);
    
    
 POM_Prof=[POM_Prof; Profile_a1'];
 Mab_Prof=[Mab_Prof; Profile_a2'];
    
 

 %{
 figure(1)
    subplot(1,2,1)
    hold on
    plot(xi,yi)
    hold off
    
    %subplot(1,2,2)
    %hold on
    %plot(x,Profile_a1');
 %}
 
    end
    
   
    POM_Profile_i=nanmean(POM_Prof);
    Mab_Profile_i=nanmean(Mab_Prof);
    %POM_Profile_i=(Prof-min(Prof))/(max(Prof)-min(Prof));
   
    %{
   figure(1)
   subplot(1,2,2)
   hold on
   plot(x,Profile_i,'LineStyle','--')
   hold off
%}

     % Fit: 'POM121'.
     [POM_results_i, diameter_i,FWHM1_i,FWHM2_i,amplitude1_i]=TwoGaussian_fit(x,POM_Profile_i');  
    
     
     Nup153_Profile=[Nup153_Profile; POM_Profile_i];
     Nup153_FWHM=[Nup153_FWHM;FWHM1_i;FWHM2_i];
     diameter=[diameter;diameter_i];
     Nup153_results=[Nup153_results; POM_results_i];
     Nup153_amplitude=[Nup153_amplitude; amplitude1_i];
     
     %
     % Fit: 'mAb414'.
     [Mab_results_i,FWHM3_i,amplitude2_i]=Gaussian_fit(x,Mab_Profile_i');
     
     Tpr_Profile=[Tpr_Profile; Mab_Profile_i];
     Tpr_FWHM=[Tpr_FWHM;FWHM3_i];
     Tpr_results=[Tpr_results; Mab_results_i];
     Tpr_amplitude=[Tpr_amplitude; amplitude2_i];
       
    
end

meanProfile_POM=nanmean(Nup153_Profile);
meanProfile_Mab=nanmean(Tpr_Profile);

cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis/Results/',folder))
save(strcat(name,'_NPC_analysis.mat'));

figure
title(strcat(name, 'NPCs'),'FontSize',16);


D_edges=0:5:250;
F_edges=0:5:250;
A_edges=0:0.05:1;

subplot(1,4,1)
title(strcat(name,'Intensity profiles NPCs'),'FontSize',16);
hold on
plot(x,meanProfile_POM,'LineStyle','--','Color','g','LineWidth',2)
plot(x,meanProfile_Mab,'LineStyle','--','Color','r','LineWidth',2)
hold off

subplot(1,4,2)
histogram(diameter,D_edges);
title('Diameter NPCs (nm)','FontSize',16);

subplot(1,4,4)
histogram(Nup153_FWHM,F_edges);
title('POM121 FWHM NPCs (nm)','FontSize',16);
%{
subplot(3,2,1);
histogram(POM121_amplitude,A_edges);
title('POM121 Amplitude');
subplot(3,2,2);

histogram(Mab_amplitude,A_edges);
title('mAb414 Amplitude');
%}
subplot(1,4,3)
histogram(Tpr_FWHM,F_edges);
title('mAb414 FWHM NPCs (nm)','FontSize',16);
%
saveas(gca,strcat(name,'_NPCs.fig'),'fig');

%}

%% analyze POM121 & mAb414 profiles in pore intermediates

I=length(TNPCs);

Nup153_Profile=[];
Tpr_Profile=[];

diameter=[];
Nup153_results=[];
Nup153_FWHM=[];
Tpr_results=[];
Tpr_FWHM=[];
Nup153_amplitude=[];
Tpr_amplitude=[];

%figure
%subplot(1,2,1)
%imshow(P)


for i=1:I %I
    POM_Prof=[];
    Mab_Prof=[];
    
    xo=TNPCs(i,1); yo=TNPCs(i,2);

     cd('/Users/christine/Documents/Data/STED/Pore_analysis')
    for a=0:pi/20:19*pi/20      %
        
    [xi,yi,x,Profile_a1]=intensityPlot(P,xo,yo,a,l,bin,px);
    [xi,yi,x,Profile_a2]=intensityPlot(M,xo,yo,a,l,bin,px);
    
    
 POM_Prof=[POM_Prof; Profile_a1'];
 Mab_Prof=[Mab_Prof; Profile_a2'];
    
 

 %{
 figure(1)
    subplot(1,2,1)
    hold on
    plot(xi,yi)
    hold off
    
    %subplot(1,2,2)
    %hold on
    %plot(x,Profile_a1');
 %}
 
    end
    
   
    POM_Profile_i=nanmean(POM_Prof);
    Mab_Profile_i=nanmean(Mab_Prof);
    %POM_Profile_i=(Prof-min(Prof))/(max(Prof)-min(Prof));
   
    %{
   figure(1)
   subplot(1,2,2)
   hold on
   plot(x,Profile_i,'LineStyle','--')
   hold off
%}

     % Fit: 'POM121'.
     [POM_results_i,FWHM1_i,amplitude1_i]=Gaussian_fit(x,POM_Profile_i');  

     
     Nup153_Profile=[Nup153_Profile; POM_Profile_i];
     Nup153_FWHM=[Nup153_FWHM;FWHM1_i];
     %diameter=[diameter;diameter_i];
     Nup153_results=[Nup153_results; POM_results_i];
     Nup153_amplitude=[Nup153_amplitude; amplitude1_i];
     
     %
     % Fit: 'mAb414'.
     %[Mab_results_i,FWHM3_i,amplitude2_i]=Gaussian_fit(x,Mab_Profile_i');
     
     Tpr_Profile=[Tpr_Profile; Mab_Profile_i];
     %Mab_FWHM=[Mab_FWHM;FWHM3_i];
     %Mab_results=[Mab_results; Mab_results_i];
     %Mab_amplitude=[Mab_amplitude; amplitude2_i];
    
     %}
end

meanProfile_POM=nanmean(Nup153_Profile);
meanProfile_Mab=nanmean(Tpr_Profile);

cd(strcat('/Users/christine/Documents/Data/STED/Pore_analysis/Results/',folder))
save(strcat(name,'_PI_analysis.mat'));

%{
figure
title(strcat(name, 'PIs'));
hold on
plot(x,meanProfile_POM,'LineStyle','--','Color','g')
plot(x,meanProfile_Mab,'LineStyle','--','Color','r')
hold off
%}

D_edges=0:5:250;
F_edges=0:5:250;
A_edges=0:0.05:1;

figure
title(strcat(name,' results PIs'),'FontSize',16);
%subplot(3,2,5)
%histogram(diameter,D_edges);
%title('Diameter (nm)');
subplot(1,2,2)
histogram(Nup153_FWHM,F_edges);
title('POM121 FWHM PIs (nm)','FontSize',16);
subplot(1,2,1)
title(strcat(name,'Intensity Profiles PIs'),'FontSize',16);
hold on
plot(x,meanProfile_POM,'LineStyle','--','Color','g','LineWidth',2)
plot(x,meanProfile_Mab,'LineStyle','--','Color','r','LineWidth',2)
hold off

%{
subplot(1,3,1);
histogram(POM121_amplitude,A_edges);
title('POM121 Amplitude');
subplot(3,2,2);

histogram(Mab_amplitude,A_edges);
title('mAb414 Amplitude');
subplot(3,2,4)
histogram(Mab_FWHM,F_edges);
title('mAb414 FWHM (nm)');
%}
saveas(gca,strcat(name,'_PIs.fig'),'fig');



end
end




