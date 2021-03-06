function [layer1,layer2] = assingCells2maskPerim(folder,sampleName,rangeY,cellsLayer1,cellsLayer2)

    load([folder sampleName '\rotatedImage3d_' strrep(sampleName,' ','_') '.mat'],'img3d');
    nameMaskInner1=[folder sampleName '\maskLayers\innerMaskLayer1\'];
    nameMaskInner2=[folder sampleName '\maskLayers\innerMaskLayer2\'];
    nameMaskOuter1=[folder sampleName '\maskLayers\outerMaskLayer1\'];
    nameMaskOuter2=[folder sampleName '\maskLayers\outerMaskLayer2\'];
    
    img3d=uint16(img3d);
%     img3dResized=imresize3(img3d,resizeFactor,'Method','nearest');
    img3dResizedLimits=img3d(rangeY(1):rangeY(2),:,:);
    totalCells=unique(img3dResizedLimits);
    
    cellsNoLayer1=setdiff(totalCells,cellsLayer1);
    cellsNoLayer2=setdiff(totalCells,cellsLayer2);
    
    maskLayer1=img3dResizedLimits;
    maskLayer2=img3dResizedLimits;

    maskLayer1(ismember(img3dResizedLimits,cellsNoLayer1))=0;
    maskLayer2(ismember(img3dResizedLimits,cellsNoLayer2))=0;
    
    
    labelOuterLayer1 = cell(size(img3dResizedLimits,1),1);
    labelInnerLayer1 = cell(size(img3dResizedLimits,1),1);
    labelOuterLayer2 = cell(size(img3dResizedLimits,1),1);
    labelInnerLayer2 = cell(size(img3dResizedLimits,1),1);

    for nY = 1 : size(img3dResizedLimits,1)
        
        maskInner1=imread([nameMaskInner1 num2str(nY+rangeY(1)-1) '.bmp']);
        maskInner2=imread([nameMaskInner2 num2str(nY+rangeY(1)-1) '.bmp']);
        maskOuter1=imread([nameMaskOuter1 num2str(nY+rangeY(1)-1) '.bmp']);
        maskOuter2=imread([nameMaskOuter2 num2str(nY+rangeY(1)-1) '.bmp']);
        
        %permute and resize for matching size 
        imgYLayer1 = imresize(permute(maskLayer1(nY,:,:),[3,2,1]),size(maskInner1),'nearest'); 
        imgYLayer2 = imresize(permute(maskLayer2(nY,:,:),[3,2,1]),size(maskInner1),'nearest'); 

        labelOuterLayer1{nY} = assingPixelValuesFromNormalVector(maskOuter1,imgYLayer1,'outer');
        labelInnerLayer1{nY} = assingPixelValuesFromNormalVector(maskInner1,imgYLayer1,'inner');
        labelOuterLayer2{nY} = assingPixelValuesFromNormalVector(maskOuter2,imgYLayer2,'outer');
        labelInnerLayer2{nY} = assingPixelValuesFromNormalVector(maskInner2,imgYLayer2,'inner');
        
        
    end
    
    layer1.outerSurface = cat(3,labelOuterLayer1{:});
    layer1.innerSurface = cat(3,labelInnerLayer1{:});
    layer2.outerSurface = cat(3,labelOuterLayer2{:});
    layer2.innerSurface = cat(3,labelInnerLayer2{:});


end

