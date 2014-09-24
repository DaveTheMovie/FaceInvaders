function [I_faces, I_alpha] = EllipseIt(I,bbox,varargin)


n.faces = size(bbox,1);

if ~isempty(varargin)
    if strcmp(varargin{1},'all')
        faceLoop = 1:n.faces;
    else
        faceLoop = varargin{1};
    end
else
    faceLoop = 0;
end

hold off
imshow(I)
if numel(bbox)==0; return;end
hold on
%% bboxes
xpos = bbox(:,1);
ypos = bbox(:,2);
wide = bbox(:,3);
high = bbox(:,4);
xmid = xpos+wide/2;
ymid = ypos+high/2;
scatter(xmid,ymid,'Marker','.')
scatter(xpos,ypos,'Marker','.')
scatter(xpos+wide,ypos,'Marker','.')
scatter(xpos+wide,ypos+ high,'Marker','.')
scatter(xpos,ypos+high,'Marker','.')

%%  Ellipse Work
% notes:
% imshow('Ellipse.png')

yAdjust = 1.4;
xAdjust = 1.1;

k = ymid;
h = xmid;
a = wide/2 * xAdjust;
b = high/2 * yAdjust;

[n.rows,n.cols,~] = size(I);
x = (1:n.cols)';

if ~faceLoop
    xvec = repmat(x,n.faces,1);
    kvec = repmat(k,n.cols,1);
    hvec = repmat(h,n.cols,1);
    avec = repmat(a,n.cols,1);
    bvec = repmat(b,n.cols,1);

    temp = real((bvec.^2 .* (1- (xvec-hvec).^2 ./ avec.^2)).^.5);
    temp(temp == 0) = nan;

    ybot = kvec + temp;
    ytop = kvec - temp;

    scatter(xvec,ybot,'Marker','.')
    scatter(xvec,ytop,'Marker','.')

else
    I_faces = cell(length(faceLoop),1);
    I_alpha = cell(length(faceLoop),1);
    i_count = 1;
    for i = faceLoop
        temp = real((b(i)^2 * (1- (x - h(i)).^2 / a(i)^2)).^.5);
        temp(temp == 0) = nan;
        ybot = k(i) + temp;
        ytop = k(i) - temp;
        scatter(x,ybot,'Marker','.')
        scatter(x,ytop,'Marker','.')
        ind = ~isnan(temp);
        bot_ellipse = ybot(ind);
        top_ellipse = ytop(ind);
        bot = min(ceil (max(bot_ellipse)),n.rows); 
        top = max(floor(min(top_ellipse)),1);
        
        ind_bot = bsxfun(@lt,(1:(bot-top+1))',top_ellipse'-top);
        ind_top = bsxfun(@gt,(1:(bot-top+1))',bot_ellipse'-top);
        
        if length(size(I)) == 2
            box = I(top:bot,ind);      
            ind_topbot = ind_bot + ind_top;  
            box(ind_topbot) = 0;
%             box(ind_bot) = 0;
%             box(ind_top) = 0;
            imshow(box)        
        end
        
        if length(size(I)) == 3
            box = I(top:bot,ind,:);  
            ind3_bot = ones(size(box));
            ind_topbot = ind_bot + ind_top;
            for i_dim = 1:3
                ind3_bot(:,:,i_dim) = ind_topbot;
            end
            box(logical(ind3_bot)) = 0;
            imshow(box)        
        end
        
        I_faces{i_count} = box;
        I_alpha{i_count} = ind_topbot;
        i_count = i_count + 1;
        
        
    end
end