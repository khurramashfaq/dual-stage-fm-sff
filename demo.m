clc
clear all
close all

%% [PR'2025] A Dual Stage Focus Measure for Shape from Focus - Official Implementation


addpath(genpath('Datasets'));
addpath(genpath('Functions'));

Results = struct('Depths', {}, 'Quant', {}, 'GT', {});


rootDir = 'Datasets\HCI14'; 
totalScenes= 14;
                       
for i = 1:totalScenes
    fprintf('Processing scene %d/%d\n', i, totalScenes);

    scene_folders = dir(rootDir);
    scene_folders = scene_folders([scene_folders.isdir]);
    scene_folders = scene_folders(~ismember({scene_folders.name}, {'.', '..'})); 
    sceneDir = fullfile(rootDir, scene_folders(i).name); 

   
    numImages = 30;  
    images = cell(numImages,1);
    for j = 1:numImages
        imageName = fullfile(sceneDir, sprintf('%s%d.png', scene_folders(i).name, j));
        images{j} = im2double(imread(imageName));
    end
    
   
    depthFile = fullfile(sceneDir, sprintf('%sD.mat', scene_folders(i).name));
    data = load(depthFile);
    Depth_Name = sprintf('%sD', scene_folders(i).name);
    Depth_GT = data.(Depth_Name);


    %% Our Method - Dual Stage Focus Measure
    
    FVScalar = SVIV(images); 
    FocVolScalarDRDF = single(FVDRDF(FVScalar, 1, 1, 1));  
    WeightedScalarDRDF = single(WeightedFV(FocVolScalarDRDF));  
    SVIV_DRDF = single(DepthMap(WeightedScalarDRDF));

    [RMSE, CORR] = QuantMeasure(Depth_GT, SVIV_DRDF);
    
    
    Depths = struct();
    Quant = struct();
    
    Depths.('SVIV_DRDF') = SVIV_DRDF;
    Quant.('SVIV_DRDF') = single([RMSE, CORR]);
    
    Results(i).Depths = Depths;
    Results(i).Quant = Quant;
    Results(i).GT = Depth_GT;
   
end

%% Visualization

sceneIndex = 1; 

figure;
subplot(1,2,1);
imshow(Results(sceneIndex).GT, []);
colormap('parula');
title('Depth GT');

subplot(1,2,2);
imshow(Results(sceneIndex).Depths.SVIV_DRDF, []);
colormap('parula');
title('Depth SVIV-DRDF');

