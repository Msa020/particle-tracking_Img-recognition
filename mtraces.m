function TRACES = mtraces(FRAMEDATA)

TRACES = FRAMEDATA;

FileName = FRAMEDATA.File;
FilePath = FRAMEDATA.Path;

MaxDistance = FRAMEDATA.Traces.MaxDistance; % Maximum distance (Pixels) between objects in consecutive frames
FigNumber = FRAMEDATA.Traces.FigNumber;

Position = FRAMEDATA.Position;


tic
X = Position(1).X1;
Y = Position(1).Y1;
Trace(1).T = [0];
Trace(1).X = [0];
Trace(1).Y = [0];
for j = 1:1:length(X)
    Trace(j).T = [0];
    Trace(j).X = [X(j)];
    
    
    
    
    
    
    
    
    Trace(j).Y = [Y(j)];
end
for i = 2:1:length(Position)  %****************************
    disp(['** TRACES (' FileName ')- position ' int2str(i) '/' int2str(length(Position)) ' - ' int2str(toc) '.' int2str(mod(toc,1)*10) 's'])
    X = Position(i).X1;
    Y = Position(i).Y1;
    
    for j = 1:1:length(Trace)
        Distance = sqrt( (X-Trace(j).X(end)).^2 + (Y-Trace(j).Y(end)).^2 );
        MinDistanceIndex = find(Distance==min(Distance));
        if (length(MinDistanceIndex)>0)
            MinDistanceIndex = MinDistanceIndex(1);
            if (Distance(MinDistanceIndex)<MaxDistance)
                Trace(j).T = [Trace(j).T (i-1)];
                Trace(j).X = [Trace(j).X X(MinDistanceIndex)];
                Trace(j).Y = [Trace(j).Y Y(MinDistanceIndex)];
                X(MinDistanceIndex) = Inf;
                Y(MinDistanceIndex) = Inf;
            end
        end
    end
    for k = 1:1:length(X)
        if (X(k)<Inf && Y(k)<Inf) 
            j = j+1;
            Trace(j).T = [(i-1)];
            Trace(j).X = [X(k)];
            Trace(j).Y = [Y(k)];
        end
    end
end

TRACES.Traces.Trace = Trace;

if (FigNumber>0)
    figure(FigNumber)
    set(gcf,'Units','normalized','Position',[0 0 1 1])

    
    
    
    axes('Position',[.05 .1 .8 .8])
    hold on
    for j = 1:1:length(Trace)
        switch (mod(j,5))
            case 0
                plot(Trace(j).X,Trace(j).Y,'r')
            case 1
                plot(Trace(j).X,Trace(j).Y,'k')
            case 2
                plot(Trace(j).X,Trace(j).Y,'m')
            case 3
                plot(Trace(j).X,Trace(j).Y,'b')
            case 4
                plot(Trace(j).X,Trace(j).Y,'c')
        end
    end
    text(50,50,FileName, 'Color','r','BackgroundColor',[1 1 1],'Interpreter','none')
    hold off
    axis equal
    xlabel('Pixels')
    ylabel('Pixels')

    axes('Position',[.88 .1 .1 .8])
    hold on
    for j = 1:1:length(Trace)
        switch (mod(j,5))
            case 0
                plot(Trace(j).T,j*ones(size(Trace(j).T)),'r')
            case 1
                plot(Trace(j).T,j*ones(size(Trace(j).T)),'k')
            case 2
                plot(Trace(j).T,j*ones(size(Trace(j).T)),'m')
            case 3
                plot(Trace(j).T,j*ones(size(Trace(j).T)),'b')
            case 4
                plot(Trace(j).T,j*ones(size(Trace(j).T)),'c')
        end
    end
    hold off
    xlabel('Frames')

    colormap(bone)
end