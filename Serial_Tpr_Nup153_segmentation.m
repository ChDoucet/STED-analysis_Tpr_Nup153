%% Segmentation procedure for Nup153 and Tpr images


close all
clear all
clc

px = 15;        % px in nm
pxarea = 225;   % px area in nm2

captionFontSize = 12;
format compact;

%%

cd('/Users/christine/Documents/Data/STED/Pore_analysis_Nup153_Tpr/Data/scrambled/8bit')
[num,txt,raw]=xlsread('FileProperties.xls');
n=length(txt);

for k=10:n    %n
name=txt{k};


%% Nup153 analysis

Nup153Image = mat2gray(imread(strcat(name,'_Nup153.tif')));
filteredImage1 = imgaussfilt(Nup153Image);

% show original image
figure
title('Nup153', 'FontSize', captionFontSize)

subplot(2,4,1)
imshow(Nup153Image); 
title('Original', 'FontSize', captionFontSize)

axis image

% converting to binary
level1 = graythresh(filteredImage1);
BW1=im2bw(filteredImage1, level1);
BW1 = imfill(BW1, 'holes');

% watershed segmentation
D1 = -bwdist(~BW1);
D1(~BW1) = -Inf;
L1 = watershed(D1);
labeledImage1 = bwlabel(L1, 8); 

subplot(2,4,2)
imshow(BW1)
title('Binary', 'FontSize', captionFontSize)


subplot(2,4,3)
imshow(label2rgb(L1, 'jet','w'))
title('Segmentation', 'FontSize', captionFontSize)




% getting region properties of the segmented particles
blobMeasurementsNup153 = regionprops(labeledImage1, Nup153Image, 'all');

allBlobCentroidsNup153 = [blobMeasurementsNup153.Centroid];
CentroidsNup153X = allBlobCentroidsNup153(1:2:end-1);
CentroidsNup153Y = allBlobCentroidsNup153(2:2:end);

allBlobAreasNup153 = [blobMeasurementsNup153.Area];
allBlobIntensityNup153 = [blobMeasurementsNup153.MeanIntensity];
allBlobCircularityNup153 = [blobMeasurementsNup153.Circularity];


% filter results

allowableAreaIndexesNup153 = (allBlobAreasNup153 >10) & (allBlobAreasNup153 < 50); 
allowableIntensityIndexesNup153 = (allBlobIntensityNup153 >10) & (allBlobIntensityNup153 < 60);

keeperIndexesNup153 = find(allowableAreaIndexesNup153); % & allowableIntensityIndexesNup153);

keeperBlobsImageNup153 = ismember(labeledImage1,keeperIndexesNup153);
keeperBlobsMeasurementsNup153 = regionprops(keeperBlobsImageNup153, Nup153Image, 'all');

keeperCentroidsNup153 = [keeperBlobsMeasurementsNup153.Centroid];
keeperCentroidsNup153X = keeperCentroidsNup153(1:2:end-1);
keeperCentroidsNup153Y = keeperCentroidsNup153(2:2:end);

keeperBlobsAreasNup153 = pxarea.*allBlobAreasNup153(keeperIndexesNup153);
keeperBlobsIntensityNup153 = allBlobIntensityNup153(keeperIndexesNup153);
keeperBlobsCircularityNup153 = allBlobCircularityNup153(keeperIndexesNup153);



subplot(2,4,4)
imshow(Nup153Image);
hold on
plot(CentroidsNup153X, CentroidsNup153Y, 'b+')
plot(keeperCentroidsNup153X, keeperCentroidsNup153Y, 'r.')
title('Centroids', 'FontSize', captionFontSize)

hold off 

% plot histograms

subplot(2,4,5)
histogram(keeperBlobsAreasNup153);
title('Area', 'FontSize', captionFontSize)

subplot(2,4,6)
histogram(keeperBlobsCircularityNup153)
title('Circularity', 'FontSize', captionFontSize)

subplot(2,4,7)
histogram(keeperBlobsIntensityNup153)
title('MeanIntensity', 'FontSize', captionFontSize)

saveas(gca,strcat(name,'_Nup153_analysis.tif'),'tiff');

% store region properties
save(strcat(name,'_Nup153.mat'),'keeperBlobsImageNup153','keeperCentroidsNup153X','keeperCentroidsNup153Y','keeperBlobsAreasNup153','keeperBlobsCircularityNup153', 'keeperBlobsIntensityNup153');


%% Tpr Analysis


TprImage = mat2gray(imread(strcat(name,'_Tpr.tif')));
filteredImage2 = imgaussfilt(TprImage);

% show original image
figure
title('Tpr', 'FontSize', captionFontSize)

subplot(2,4,1)
imshow(TprImage); 
title('Original', 'FontSize', captionFontSize)

axis image

% converting to binary
level2 = graythresh(filteredImage2);
BW2=im2bw(filteredImage2, level2);
BW2 = imfill(BW2, 'holes');

% watershed segmentation
D2 = -bwdist(~BW2);
D2(~BW2) = -Inf;
L2 = watershed(D2);
labeledImage2 = bwlabel(L2, 8); 

subplot(2,4,2)
imshow(BW2)
title('Binary', 'FontSize', captionFontSize)


subplot(2,4,3)
imshow(label2rgb(L2, 'jet','w'))
title('Segmentation', 'FontSize', captionFontSize)




% getting region properties of the segmented particles
blobMeasurementsTpr = regionprops(labeledImage2, TprImage, 'all');

allBlobCentroidsTpr = [blobMeasurementsTpr.Centroid];
CentroidsTprX = allBlobCentroidsTpr(1:2:end-1);
CentroidsTprY = allBlobCentroidsTpr(2:2:end);

allBlobAreasTpr = [blobMeasurementsTpr.Area];
allBlobIntensityTpr = [blobMeasurementsTpr.MeanIntensity];
allBlobCircularityTpr = [blobMeasurementsTpr.Circularity];


% filter results

allowableAreaIndexesTpr = (allBlobAreasTpr >2) & (allBlobAreasTpr < 50); 
allowableIntensityIndexesTpr = (allBlobIntensityTpr >20);

keeperIndexesTpr = find(allowableAreaIndexesTpr); % & allowableIntensityIndexesTpr);

keeperBlobsImageTpr = ismember(labeledImage2,keeperIndexesTpr);
keeperBlobsMeasurementsTpr = regionprops(keeperBlobsImageTpr, TprImage, 'all');

keeperCentroidsTpr = [keeperBlobsMeasurementsTpr.Centroid];
keeperCentroidsTprX = keeperCentroidsTpr(1:2:end-1);
keeperCentroidsTprY = keeperCentroidsTpr(2:2:end);

keeperBlobsAreasTpr = pxarea.*allBlobAreasTpr(keeperIndexesTpr);
keeperBlobsIntensityTpr = allBlobIntensityTpr(keeperIndexesTpr);
keeperBlobsCircularityTpr = allBlobCircularityTpr(keeperIndexesTpr);



subplot(2,4,4)
imshow(TprImage);
hold on
plot(CentroidsTprX, CentroidsTprY, 'b+')
plot(keeperCentroidsTprX, keeperCentroidsTprY, 'r.')
title('Centroids', 'FontSize', captionFontSize)

hold off 

% plot histograms

subplot(2,4,5)
histogram(keeperBlobsAreasTpr);
title('Area', 'FontSize', captionFontSize)

subplot(2,4,6)
histogram(keeperBlobsCircularityTpr)
title('Circularity', 'FontSize', captionFontSize)

subplot(2,4,7)
histogram(keeperBlobsIntensityTpr)
title('MeanIntensity', 'FontSize', captionFontSize)

saveas(gca,strcat(name,'_Tpr_analysis.tif'),'tiff');

% store region properties
save(strcat(name,'_Tpr.mat'),'keeperBlobsImageTpr','keeperCentroidsTprX','keeperCentroidsTprY','keeperBlobsAreasTpr','keeperBlobsCircularityTpr', 'keeperBlobsIntensityTpr');

%% Summary + distances

figure
B=zeros(size(Nup153Image));
RGB = cat(3,Nup153Image, TprImage, B);


imshow(RGB);
hold on
plot(keeperCentroidsNup153X,keeperCentroidsNup153Y,'r+')
plot(keeperCentroidsTprX,keeperCentroidsTprY,'y+')

figure
subplot(2,2,1)
histogram(keeperBlobsAreasNup153, 'Normalization', 'probability')
hold on
histogram(keeperBlobsAreasTpr,'Normalization', 'probability')
title('Areas (nm^2)','FontSize', captionFontSize)
hold off

subplot(2,2,2)
histogram(keeperBlobsIntensityNup153,'Normalization', 'probability')
hold on
histogram(keeperBlobsIntensityTpr,'Normalization', 'probability')
hold off
title('Intensity','FontSize', captionFontSize)


subplot(2,2,3)
histogram(keeperBlobsCircularityNup153,'Normalization', 'probability')
hold on
histogram(keeperBlobsCircularityTpr,'Normalization', 'probability')
hold off
title('Circularity','FontSize', captionFontSize)

% Calculate the distance between Nup153 and Tpr centroids
d=[];

Nup153Centers=[keeperCentroidsNup153X',keeperCentroidsNup153Y'];
TprCenters=[keeperCentroidsTprX',keeperCentroidsTprY'];

[ID, dist]=knnsearch(TprCenters, Nup153Centers);
d=[d;dist.*px];

subplot(2,2,4)
edges=0:5:80;
histogram(d,edges)
title('Nup153 to Tpr distances (nm)','FontSize', captionFontSize);

saveas(gca,strcat(name,'_summary.tif'),'tiff');

end