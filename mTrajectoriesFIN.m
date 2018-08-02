clear all;
close all;
clc;

%% Choose the file
[FRAMEDATA.File,FRAMEDATA.Path] = uigetfile('*.mat');

disp(['** File: ' FRAMEDATA.File])
disp(['** Path: ' FRAMEDATA.Path])

load([FRAMEDATA.Path FRAMEDATA.File]);

FRAMEDATA.Position = FRAMEDATA.Frame; 

%% Predefine parameters
FRAMEDATA.Traces.MaxDistance = 5; % Maximum distance (Pixels) between objects in consecutive frames (default: 5)
FRAMEDATA.Traces.FigNumber = 0; % Switch Figures on/off

%% TRACES
FileTraces = cat(2,FRAMEDATA.Path,FRAMEDATA.File(1:end-4),'_traces');
if exist([FileTraces '.mat']) 
    load([FileTraces '.mat'])
    disp(['** Loaded Traces - ' FileTraces])
else
    TRACES = mtraces(FRAMEDATA);
    save([FileTraces '.mat'],'TRACES')
    if FRAMEDATA.Traces.FigNumber > 0
        saveas(gcf,[FileTraces '.fig'],'fig')
        saveas(gcf,[FileTraces '.jpg'],'jpg')
    end
end

%% Predefine parameters
TRACES.Trajectories.Pixel2MicronsX = 0.2815; % Conversion factor from pixels to um
TRACES.Trajectories.Pixel2MicronsY = 0.2815; % Conversion factor from pixels to um
TRACES.Trajectories.MaxDistance = 2; % Maximum distance (microns) between objects in consecutive frames
TRACES.Trajectories.MaxTime = 1; % Maximum time (seconds) that can be skipped
TRACES.Trajectories.MinLength = 50; % Minimum length of trajectories (in frames)
TRACES.Trajectories.FrameRate = 5; % Video Frame Rate (in fps)
TRACES.Trajectories.FigNumber = 1; % Switch figures on/off

%% TRAJECTORIES
FileTrajectories = cat(2,TRACES.Path,TRACES.File(1:end-4),'_trajectories');
if exist([FileTrajectories '.mat']) 
    load([FileTrajectories '.mat'])
    disp(['** Loaded Trajectories - ' FileTrajectories])
else
    TRAJECTORIES = mtrajectories(TRACES);
    save([FileTrajectories '.mat'],'TRAJECTORIES')
    if TRACES.Trajectories.FigNumber > 0
        saveas(gcf,[FileTrajectories '.fig'],'fig')
        saveas(gcf,[FileTrajectories '.jpg'],'jpg')
    end
end
