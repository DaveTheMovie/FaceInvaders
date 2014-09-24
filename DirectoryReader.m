%% Read through all images in a set of directories

% dirs = {'C:\Users\David\Pictures\Ava\'};
n.dirs = length(dirs);
container_dirs = cell(n.dirs,1);
i_adj = 0;

tic
for i_dir  = 1:n.dirs
    dname = dirs{i_dir};
    if ~strcmp(dname(end),'\');dname = [dname '\'];end %#ok<AGROW>
    fnames = cellstr(ls(dname));
    fnames(strcmp(fnames,'.' )) = [];
    fnames(strcmp(fnames,'..')) = [];  
    n.fnames = length(fnames);    
    n.pics = nan(n.fnames);
    container_fnames = cell(n.fnames,2);
    for i_fname = 1:n.fnames        
        ImportFile([dname fnames{i_fname}])
        X = cdata;        
        faceDetector = vision.CascadeObjectDetector;
        I = rgb2gray(X);
        bboxes = step(faceDetector, I); 
        n.pics(i_fname) = length(bboxes);
        if isempty(bboxes)
            i_adj = i_adj + 1;
        else            
            figure
            [container_fnames{i_fname-i_adj,1:2}] = EllipseIt(X,bboxes,'all');
        end
    end
    container_dirs{i_dir} = container_fnames(1:i_fname-i_adj);
end
toc

%% Collect count of faces per picture
count = nan(i_fname-i_adj,1);
for i = 1:i_fname-i_adj
    count(i) = size(container_fnames{i},1);
end

%% Unpack collected faces in each picture

faces = cell(sum(count),2);
k = 1;
for i = 1:i_fname-i_adj
    for j = 1:count(i);
        faces(k,1) = container_fnames{i,1}(j);
        faces(k,2) = container_fnames{i,2}(j);
        k = k+1;
    end
end


%% Save Faces
save('facesLive.mat','faces')
