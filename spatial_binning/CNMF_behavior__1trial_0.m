% Code for analyzing and plotting speed and licking behavior 
% WS1 = WC1;

odorBin1 = 11; %identifies where the odor turns on
odorBin2 = 31;
colorMin = 10;
colorMax = 60; %sets the range for the colormap


    skipLaps = 0;       %skip the first 6 laps
    pathLength = 4000;  %length of run
    binLength = 100;    %run is divided into 40 bins of 0.1 m length
    nBin = ceil(pathLength/binLength);
    
    binThreshold = 0.5; %threshold for including bin in estimation of place
    sumThreshold = 1.0; %threshold for calling a cell a place cell
    
    
     % extract data from data matrix called WD1
    
    time = WS1(:, 2);
    odor = WS1(:, 11);
    distance = WS1(:, 8);
    lap = WS1(:, 10);
    speed = WS1(:, 12);
    lick = WS1(:, 4);
    reward = WS1(:, 7);
    inDist = [distance lap];
    preReward = [reward lap];
    
    lickdiff = diff(lick);
    lickrate = [0;lickdiff];
    
    
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
   
aBin = zeros(1, nLap, nBin); %bin the speed data
    for i=1
        for j=1:nLap
            for k=1:nBin
                iBin = find((binLength*(k-1)<=lapDistance{j})...
                    &(lapDistance{j}<binLength*k));
                if (length(iBin)>0)
                    aBin(i, j, k) = mean(speed(iLap(j)+iBin, i));
                end
            end
        end
    end
    
     %divide the speed data in odor A and odor B trials
    nLap1 = sum((odorID==1));
    nLap2 = length(odorID) - nLap1;
    speed1Bin = zeros(1, nLap1, nBin);
    speed2Bin = zeros(1, nLap2, nBin);
    iLap1 = zeros(1, 1);
    iLap2 = zeros(1, 1);
    j1 = 1;
    j2 = 1;
    
    for i=1:nLap
        if (odorID(i)==1)
            speed1Bin(:, j1, :) = aBin(:, i, :);
            iLap1(j1) = i;
            j1 = j1 + 1;
        else
            speed2Bin(:, j2, :) = aBin(:, i, :);
            j2 = j2 + 1;
            iLap2(j1) = i;
        end
    end
    
    
    
    speed1Bin_0 = speed1Bin;
    save('speed1Bin_0', 'speed1Bin_0');

    
    %computes mean speed across trials for each cell and both odor conditions
    speed1Mean = squeeze(mean(speed1Bin, 2));

    speed1Mean_0 = speed1Mean;
    save('speed1Mean_0', 'speed1Mean_0');


   
lickBin = zeros(1, nLap, nBin); %bin the lickrate data
    for i=1
        for j=1:nLap
            for k=1:nBin
                iBin = find((binLength*(k-1)<=lapDistance{j})...
                    &(lapDistance{j}<binLength*k));
                if (length(iBin)>0)
                    lickBin(i, j, k) = mean(lickrate(iLap(j)+iBin, i));
                end
            end
        end
    end
    

    
    %divide the lickrate data in odor A and odor B trials
    nLap1 = sum((odorID==1));
    nLap2 = length(odorID) - nLap1;
    lick1Bin = zeros(1, nLap1, nBin);
    lick2Bin = zeros(1, nLap2, nBin);
    iLap1 = zeros(1, 1);
    iLap2 = zeros(1, 1);
    j1 = 1;
    j2 = 1;
    
    for i=1:nLap
        if (odorID(i)==1)
            lick1Bin(:, j1, :) = lickBin(:, i, :);
            iLap1(j1) = i;
            j1 = j1 + 1;
        else
            lick2Bin(:, j2, :) = lickBin(:, i, :);
            j2 = j2 + 1;
            iLap2(j1) = i;
        end
    end
    
    lick1Bin(:,:,1)=0;
    lick2Bin(:,:,1)=0;
    
     lick1Bin_0 = lick1Bin;
 save('lick1Bin_0', 'lick1Bin_0');
      

   
    %computes mean lickrate across trials for each cell and both odor conditions
    lick1Mean = squeeze(mean(lick1Bin, 2));
    lick1Mean_0 = lick1Mean;
    save('lick1Mean_0', 'lick1Mean_0');
