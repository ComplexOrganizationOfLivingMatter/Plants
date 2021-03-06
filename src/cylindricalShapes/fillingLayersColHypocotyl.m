function [labelOuterSurface1,labelInnerSurface1,labelOuterSurface2,labelInnerSurface2] = fillingLayersColHypocotyl(layer1,layer2,rangeY,resizedFactor,path2save)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %%first layer Hypocotyl A
%     tipValueInn=35;
%     tipValueOut=35;
    %%second layer Hypocotyl A    
%     tipValueInn=24;
%     tipValueOut=37;
    %first layer Hypocotyl B
    tipValueInn=24;
    tipValueOut=37;
    %%second layer Hypocotyl B    
%     tipValueInn=24;
%     tipValueOut=37;
%     openValue=10;

    volumeFilter=100;
    
   
    if exist([path2save 'surfacesLayer1ClosestPoint.mat'],'file')
        load([path2save 'surfacesLayer1ClosestPoint.mat'],'labelOuterSurface1','labelInnerSurface1')
    else
         %% resize 3d
        layOut1Resized=imresize3(layer1.outerSurface,resizedFactor,'Method','nearest');
        layInn1Resized=imresize3(layer1.innerSurface,resizedFactor,'Method','nearest');
        
        %% filter by volume
        layOut1Resized=filterByVolume(layOut1Resized,volumeFilter);
        layInn1Resized=filterByVolume(layInn1Resized,volumeFilter);
        
        %% add zeros tips for possible 
        layOut1Resized=addTipsImg3D(tipValueOut,layOut1Resized);
        layInn1Resized=addTipsImg3D(tipValueInn,layInn1Resized);
        
        %% get closest coordinates to wrapping surface
        [labelOuterSurface1,labelInnerSurface1] = getFilledMaskHyp(layOut1Resized,layInn1Resized,tipValueInn,tipValueOut,rangeY);
        save([path2save 'surfacesLayer1ClosestPoint.mat'],'labelOuterSurface1','labelInnerSurface1')
    end

    if exist([path2save 'surfacesLayer2ClosestPoint.mat'],'file')
        load([path2save 'surfacesLayer2ClosestPoint.mat'],'labelOuterSurface2','labelInnerSurface2')
    else
         %% resize 3d
        layOut2Resized=imresize3(layer2.outerSurface,resizedFactor,'Method','nearest');
        layInn2Resized=imresize3(layer2.innerSurface,resizedFactor,'Method','nearest');

        %% filter by volume
        layOut2Resized=filterByVolume(layOut2Resized,volumeFilter);
        layInn2Resized=filterByVolume(layInn2Resized,volumeFilter);

        %% add zeros tips for possible 
        layOut2Resized=addTipsImg3D(tipValueOut,layOut2Resized);
        layInn2Resized=addTipsImg3D(tipValueInn,layInn2Resized);

        %% get closest coordinates to wrapping surface
        [labelOuterSurface2,labelInnerSurface2] = getFilledMaskHyp(layOut2Resized,layInn2Resized,tipValueInn,tipValueOut,rangeY);
        save([path2save 'surfacesLayer2ClosestPoint.mat'],'labelOuterSurface2','labelInnerSurface2')
    end
    
    
end

