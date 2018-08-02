function TRAJECTORIES = mtrajectories(TRACES)

TRAJECTORIES = TRACES;
Trajectory=[]; %*******
FileName = TRACES.File;
FilePath = TRACES.Path;

Pixel2MicronsX = TRACES.Trajectories.Pixel2MicronsX; % Conversion factor from pixels to um
Pixel2MicronsY = TRACES.Trajectories.Pixel2MicronsY; % Conversion factor from pixels to um
MaxDistance = TRACES.Trajectories.MaxDistance; % Maximum distance (Pixels) between objects in consecutive frames
MaxTime = TRACES.Trajectories.MaxTime; % Maximum number of frames that can be skipped
MinLength = TRACES.Trajectories.MinLength; % Minimum length of trajectories (in frames)
FrameRate = TRACES.Trajectories.FrameRate; % Video Frame Rate (in fps)
FigNumber = TRACES.Trajectories.FigNumber;


Trace = TRACES.Traces.Trace;

tic
i = 0;
for k = 2:1:length(Trace)  %********************************************
    if length(Trace(k).X)>MinLength
    disp(['** TRAJECTORIES (' FileName ')- trace ' int2str(i) '/' int2str(length(Trace)) ' - ' int2str(toc) '.' int2str(mod(toc,1)*10) 's'])
    
    if (Trace(k).T~=Inf)
        i = i+1;
        Trajectory(i).T = Trace(k).T;
        Trajectory(i).X = Trace(k).X;
        Trajectory(i).Y = Trace(k).Y;
        for j = 2:1:length(Trace)

            TEnd = Trajectory(i).T(end);
            XEnd = Trajectory(i).X(end);
            YEnd = Trajectory(i).Y(end);

            TStart = Trace(j).T(1);
            XStart = Trace(j).X(1);
            YStart = Trace(j).Y(1);

            if ( (TStart>TEnd) && ...
                    (TStart<(TEnd+MaxTime*FrameRate)) && ...
                    ( (((XStart-XEnd)*Pixel2MicronsX)^2+((YStart-YEnd)*Pixel2MicronsY)^2) < MaxDistance^2 ) )
                Trajectory(i).T = [Trajectory(i).T Trace(j).T];
                Trajectory(i).X = [Trajectory(i).X Trace(j).X];
                Trajectory(i).Y = [Trajectory(i).Y Trace(j).Y];
                Trace(j).T = Inf;
                Trace(j).X = Inf;
                Trace(j).Y = Inf;
            end
            end
        end
    end
    
end

for i = 1:1:length(Trajectory)
    Trajectory(i).T = Trajectory(i).T/FrameRate;
    Trajectory(i).X = Trajectory(i).X*Pixel2MicronsX;
    Trajectory(i).Y = Trajectory(i).Y*Pixel2MicronsY;
end

TRAJECTORIES.Trajectories.Trajectory = Trajectory;

if (FigNumber>0)
    figure(FigNumber)
   
    set(gcf,'Units','normalized','Position',[0 0 1 1])

    axes('Position',[.05 .1 .8 .8])
    
    hold on
    for j = 1:1:length(Trajectory)
        
        switch (mod(j,5))
            case 0
                plot(Trajectory(j).X,Trajectory(j).Y,'r')
                text(Trajectory(j).X(1),Trajectory(j).Y(1),num2str(j),'Color','green')
            case 1
                plot(Trajectory(j).X,Trajectory(j).Y,'k')
                 text(Trajectory(j).X(1),Trajectory(j).Y(1),num2str(j),'Color','green')
            case 2
                plot(Trajectory(j).X,Trajectory(j).Y,'m')
                 text(Trajectory(j).X(1),Trajectory(j).Y(1),num2str(j),'Color','green')
            case 3
                plot(Trajectory(j).X,Trajectory(j).Y,'b')
                 text(Trajectory(j).X(1),Trajectory(j).Y(1),num2str(j),'Color','green')
            case 4
                plot(Trajectory(j).X,Trajectory(j).Y,'c')
                 text(Trajectory(j).X(1),Trajectory(j).Y(1),num2str(j),'Color','green')
        
        end
   
    end
    text(50,50,FileName, 'Color','r','BackgroundColor',[1 1 1],'Interpreter','none')
    hold off
    axis equal
    xlabel('Microns')
    ylabel('Microns')

    axes('Position',[.88 .1 .1 .8])
    hold on
    for j = 1:1:length(Trajectory)
       
        switch (mod(j,5))
            case 0
                plot(Trajectory(j).T,j*ones(size(Trajectory(j).T)),'r')
            case 1
                plot(Trajectory(j).T,j*ones(size(Trajectory(j).T)),'k')
            case 2
                plot(Trajectory(j).T,j*ones(size(Trajectory(j).T)),'m')
            case 3
                plot(Trajectory(j).T,j*ones(size(Trajectory(j).T)),'b')
            case 4
                plot(Trajectory(j).T,j*ones(size(Trajectory(j).T)),'c')
        end
        
    end
    hold off
	xlabel('Seconds')

    colormap(bone)
        
end