%% Get Data
dirsInput = char(inputdlg(sprintf('Please enter the directory where your pictures are.\nDefault directory:  C:\\Temp_FaceInvaders')));

if isempty(dirsInput)
    dirsInput = 'C:\Temp_FaceInvaders';
end
dirs = {dirsInput};

DirectoryReader

%% Identify Faces

n.faces = size(faces,1);
msgbox([num2str(n.faces) ' faces identified.'])

n.row = ceil(sqrt(n.faces));
n.col = n.row;

figure('units','normalized','outerposition',[0 0 1 1])
for i = 1:n.faces
    subplot(n.row,n.col,i)
    imshow(faces{i})
end

%% Add Mustaches
addMustacheYN = inputdlg('Would you like to add mustaches?(y/n)');
if strcmp(addMustacheYN,'y')
    AddMustache
    faces = facesNew;
end
save('FacesNew.mat','faces')

%% Play Game
playYN = inputdlg('Would you like to play FaceInvaders?(y/n)');
if strcmp(addMustacheYN,'y')
    shooter03
end