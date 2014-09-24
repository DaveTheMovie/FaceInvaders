
%% Add Mustaches

% Import the mustache image
% The mustache image is never displayed
% It is used to resize and set alpha
ImportFile('m1.png')
mustache.rgb = cdata;
mustache.gray = rgb2gray(mustache.rgb);
mustache.alpha = mustache.gray < 125;

facesNew = faces;
ISFACE = 1;

figure('units','normalized','outerposition',[0 0 1 1])
for i = 1:min(n.row*n.col,n.faces)
    subplot(n.row,n.col,i)
    I = faces{i};
    [x, y, xTL, yTL, xTR, yTR] = FindMustache(I,'Mouth',ISFACE);
    y = round(y);
    x = round(x);
    if x+y ~= 0
        % Determin size of mouth for rescale
        mustache.width = size(mustache.gray,2);
        I_mouth_width = xTR - xTL;
        rescale = 2*I_mouth_width / mustache.width;

        % Resize the image
        h_newStache = image( ...
                        'CData',imresize(mustache.rgb,rescale), ...
                        'Parent',gca, ...
                        'Visible','off');

        % Identify alpha
        newStache.rgb = get(h_newStache,'CData');
        [newStache.height, newStache.width, ~] = size(newStache.rgb);
        newStache.gray = rgb2gray(newStache.rgb);
        newStache.alpha = newStache.gray < 125;
        
        h_newStache = [];

        % Flatten image
        [max_height,max_width,~] = size(I);
        range_width         = x - round(newStache.width/2) +1: x - round(newStache.width/2)+ newStache.width;
        range_height        = y : y + newStache.height-1;         

        newStart_w  = range_width(1);  
        newEnd_w    = range_width(end); 

        if range_width(1) < 1
            newStart_w = max(1,-range_width(1));
        end
        if range_width(end) > max_width
            newEnd_w = max_width;
        end

        range_new_w = newStart_w:newEnd_w;

        if range_height(end) > max_height
            range_new_h = range_height(1:end-(range_height(end)-max_height));
        else
            range_new_h = range_height;
        end

        picSection = I(range_new_h,range_new_w,:);

        alpha3 = nan(size(picSection));
        for i_dim =1:3
            alpha3(1:end,1:end,i_dim) = newStache.alpha(1:length(range_new_h),1:length(range_new_w));
        end
        picX = picSection;
        picX(logical(alpha3)) = 0;

        I(range_new_h,range_new_w,:) = picX;
        imshow(I);
        facesNew{i,1} = I;

    end
end