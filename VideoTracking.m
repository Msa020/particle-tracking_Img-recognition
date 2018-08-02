clear all;
close all; 
clc;

%% Choose the file

[Data.File,Data.Path] = uigetfile('*.avi');

disp(['** File: ' Data.File])
disp(['** Path: ' Data.Path])

Video = VideoReader([Data.Path Data.File]);

%% Predefine parameters

begframe = 1; % first frame to track
endframe = Video.NumberOfFrames-2;% last frame to track
channel1 = 2; % RGB channel
level1 = .5; % BW threshold level
minarea1 = 20; % minimun size for detected area
Allowedistance = 50; % maximum distance between objects
ParticleArea = 4.053; % particle area
plots = 1; % 1 = plots active, 0 = plots inactive

%% Loop on video frames

for a = begframe:1:20 %Video.NumberOfFrames
    disp(['** Progress: ' int2str(a) ' of ' int2str(Video.NumberOfFrames) ' frames tracked'])
    Data.Frame.Number = a;
    A = read(Video,a); % Original image
    
    %% Analysis Passive (1)
    F1 = fspecial('gaussian',30,10); % filter type, size, sigma
    B1 = imfilter(A,F1,'replicate'); % Background
    
    A1 = A-B1; % Image - Background
    S1 = imadjust(A1, stretchlim(A1),[]); % Image with stretched colors
    
    BW1 = im2bw(S1(:,:,channel1),level1); % Image in BW

    dilate1 = strel('disk',1);
    BW1 = imdilate(BW1,dilate1);

    % erode1 = strel('disk',1);
    % BW1 = imerode(BW1,erode1);
%     regions1 = bwlabel(BW1,8);
    
    regions1 = logical(BW1); % this is faster than bwlabel
    props1 = regionprops(regions1, 'Centroid', 'Area');

    X1 = [];
    Y1 = [];
    for n = 1:size(props1)
        %Index = find(sqrt((X1-props1(n).Centroid(1)).^2+(Y1-props1(n).Centroid(2)).^2)<Allowedistance); 
        if (props1(n).Area > minarea1)
            %if isempty(Index)
            X1 = [X1; props1(n).Centroid(1)];
            Y1 = [Y1; props1(n).Centroid(2)];
            %else
            %X1(Index)= (X1(Index)+props1(n).Centroid(1))/2;
            %Y1(Index)= (Y1(Index)+props1(n).Centroid(2))/2; 
            %end
        end
    end
    Data.Frame.X1 = X1;
    Data.Frame.Y1 = Y1;
    
    NumberOfParticles=length(X1);
    AreaFraction=(NumberOfParticles*ParticleArea)/(161*175);
    
    if plots == 1
%     %% Plots
    figure(1)
    set(gcf,'Position',[0 0 1600 1200])
    
% 
    subplot(2,2,1)
    image(A)
    hold on
    scatter(X1,Y1,16,'+r')
    hold off        
    box on
    axis equal tight ij
    title(['Frame number ' int2str(a)])

    subplot(2,2,2)
    % image(B1)
    % image(A1)
    % image(S1)
    imshow(BW1)
    hold on
    scatter(X1,Y1,16,'+b')
    hold off        
    box on
    axis equal tight ij
    title(['Total number of frames ' int2str(Video.NumberOfFrames)])
    
    subplot(2,2,3)
    % image(A2)
    % image(S2)
    %imshow(BW2)
    hold on
    scatter(X1,Y1,16,'+b')
    %scatter(X2,Y2,16,'+r')
    hold off        
    box on
    axis equal tight ij
    title(['** File: ' Data.File])

    subplot(2,2,4)
    imagesc(imadjust(A,stretchlim(A),[]))
    hold on
    scatter(X1,Y1,16,'+b')
    %scatter(X2,Y2,16,'+r')
    hold off        
    box on
    axis equal tight ij
 

    drawnow();
    end
    
    %% SAVE
    d = [Data.Path Data.File(1:end-4)];
    if (isdir(d)==0)
        mkdir(d)
    end
    save([Data.Path Data.File(1:end-4) '\' Data.File(1:end-4) '_' int2str(a) '.mat'],'Data')
    
           end

%% Save


FRAMEDATA.File = Data.File;
FRAMEDATA.Path = Data.Path;
FRAMEDATA.FrameRate = Video.FrameRate;

for a = begframe:1:5
    load([Data.Path Data.File(1:end-4) '\' Data.File(1:end-4) '_' int2str(a) '.mat'])
    disp(['** Progress: ' int2str(a) ' of ' int2str(Video.NumberOfFrames) ' frames saved'])
    FRAMEDATA.Frame(a).X1 = Data.Frame.X1;
    FRAMEDATA.Frame(a).Y1 = Data.Frame.Y1;
end
save([Data.Path Data.File(1:end-4) '.mat'],'FRAMEDATA')
close all
rmdir([Data.Path Data.File(1:end-4)],'s')