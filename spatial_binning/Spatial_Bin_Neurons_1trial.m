% Start by loading the data.  Drag one of the data files to the Matlab
% command window.  This will open a window.  From the top of the window
% choose "Numerical Matrix".  Just above the data array, there will be
% a file name like "wfnjC1920150217combinedbehaviorandtraces".  Select
% this and change it to "WD1".  Then click on "Import Selection".  Next
% run the program once with new = 1.  If you want to run it again using 
% the same data, set new = 0 so it doesn't waste time reprocessing the
% same data.

    skipLaps = 0;       %skip the first 6 laps
    pathLength = 4000;  %length of run
    binLength = 100;    %run is divided into 40 bins of 0.1 m length
    nBin = ceil(pathLength/binLength);
   
    % extract data from data matrix called WD1
    nCell = size(WD1, 2) - 12;
    time = WD1(:, 2);
    odor = WD1(:, 11);
    distance = WD1(:, 8);
    lap = WD1(:, 10);
    cell = WD1(:, 13:end);

    
    nLap = max(lap) - skipLaps; %number of laps being studied
    iLast = max(find(lap==nLap)); %last time bin on lap
    iLap = find(lap(1:iLast-1)<lap(2:iLast)); %finds where laps start
    iLap = [0; iLap]; %adds a 0 for the first lap

    odorID = zeros(nLap, 1); %which odor is presented on each lap
    % lapDistance{i} is cummulative distance traveled for each bin on lap i
    for i=1:nLap
        lapDistance{i} = distance(iLap(i)+1:iLap(i+1)); 
        odorID(i) = max(odor(iLap(i)+1:iLap(i+1)));
    end
    
    aBin = zeros(nCell, nLap, nBin); %bin the data
    for i=1:nCell
        for j=1:nLap
            for k=1:nBin
                iBin = find((binLength*(k-1)<=lapDistance{j})...
                    &(lapDistance{j}<binLength*k));
                if (length(iBin)>0)
                    aBin(i, j, k) = mean(cell(iLap(j)+iBin, i));
                end
            end
        end
    end
    
    %divide the data in odor A and odor B trials
    nLap1 = sum((odorID==1));
    nLap2 = length(odorID) - nLap1;
    a1Bin = zeros(nCell, nLap1, nBin);
    a2Bin = zeros(nCell, nLap2, nBin);
    iLap1 = zeros(nCell, 1);
    iLap2 = zeros(nCell, 1);
    j1 = 1;
    j2 = 1;
    
    for i=1:nLap
        if (odorID(i)==1)
            a1Bin(:, j1, :) = aBin(:, i, :);
            iLap1(j1) = i;
            j1 = j1 + 1;
        else    
            a2Bin(:, j2, :) = aBin(:, i, :);
            j2 = j2 + 1;
            iLap2(j1) = i;
       
        end
    end

      
    %computes means across trials for each cell and both odor conditions
    %gaussian smoothing

    a1Mean = squeeze(mean(a1Bin, 2));

