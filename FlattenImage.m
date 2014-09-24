%% Determin size of mouth for rescale

size(mustache.gray);
mustache.width = size(mustache.gray,2);
mouth_width = xTR - xTL;
rescale = 2*mouth_width / mustache.width;

%% Resize the image

h_newStache = image( ...
                'CData',imresize(mustache.rgb,rescale), ...
                'Parent',gca, ...
                'XData',xTL-.5*mouth_width, ...
                'YData',y);

%% Identify alpha for resized

newStache.rgb = get(h_newStache,'CData');
[newStache.height, newStache.width, ~] = size(newStache.rgb);
newStache.gray = rgb2gray(newStache.rgb);
newStache.alpha = newStache.gray < 125;

picSection = I(y : y + newStache.height-1, xTL - adj +1: xTL - adj + newStache.width,:);

alpha3 = nan(size(picSection));
for i =1:3
    alpha3(1:end,1:end,i) = newStache.alpha;
end
picX = picSection;
picX(logical(alpha3)) = 0;

I(y : y + newStache.height-1, xTL - adj +1: xTL - adj + newStache.width,1:end) = picX;