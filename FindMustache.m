function [x, y, xTL, yTL, xTR, yTR] = FindMustache(I, feature, varargin)
% I is an image
% feature = 'Mouth' 'Nose' 'EyePairSmall'
% isFace = 0 or 1

if isempty(varargin)
    isFace = 0;
else
    isFace = 1;
end


faceDetector = vision.CascadeObjectDetector(feature);
himage = imshow(I);
bboxes = step(faceDetector, I); %note: returns upper left point and width and height
if ~isempty(bboxes)
%     IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, features{i_feature});
%     imshow(IFaces)
else
    x=0;
    y=0;
    xTL=0;
    yTL=0;
    xTR=0;
    yTR=0;
    return;
end
    

%% Display Points

hold on
if ~isempty(bboxes)
    bbox = bboxes;
    if strcmp(feature,'Mouth')
        ypos = bbox(:,2);
        [~,idx_r] = max(ypos);
    else
        idx_r = 1;
%         idx_r = 1:size(bbox,1);
    end

    % bboxes
    xpos = bbox(idx_r,1);
    ypos = bbox(idx_r,2);
    wide = bbox(idx_r,3);
    high = bbox(idx_r,4);
    xmid = xpos+wide/2;
    ymid = ypos+high/2; %#ok<NASGU>
%     scatter(xmid,ymid,'Marker','.')
%     scatter(xpos,ypos,'Marker','.')
%     scatter(xpos+wide,ypos,'Marker','.')
%     scatter(xpos+wide,ypos+ high,'Marker','.')
%     scatter(xpos,ypos+high,'Marker','.')
end

%% Find Mustache Center
    
if ~isempty(bboxes)

    if strcmp(feature,'Mouth')
        downAdjust = -high * .05;
    end
    if strcmp(feature,'EyePairSmall')    
        downAdjust = wide * .45;
    end
    
    x = xmid;
    y = ypos+downAdjust;
    xTL = xpos;
    yTL = ypos;
    xTR = xpos+wide;
    yTR = ypos;
    
    if isFace
        imageHeight = get(himage,'yData');
        if y < imageHeight(2) * .5 || y > imageHeight(2) * .80
            x=0;
            y=0;
            return
        end
    end
    scatter(x,y,'Marker','.')
end