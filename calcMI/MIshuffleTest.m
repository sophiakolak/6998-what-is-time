function [pValues, MIscores] = MIshuffleTest(cellEvents, binnedTrace, nShuffles, varargin)


%%%%%% performs a shuffle test to find cells with significant mutual
%%%%%% information.

%%%%%% INPUTS:
% cellEvents - event times for cells. can have two forms:
%   *a matlab cell array, where each entry is a list of event times. for
%       example, cellEvents{81} = [1,10,19] means that cell 81 had Ca2+ events
%       at frame 1, 10, and 19. This is as output by EM_CellFind_Wrapper in
%       output.dsEventTimes
%   *a matrix of zeros and ones, size [nCells nFrames], where a 0 indicates
%       no event at that frame, and a 1 indicates an event
% binnedTrace - position, or other variable to find mutual information
%   with. It should have length equal to the number of frames, and be binned
%   into discrete values.
% nShuffles - number of shuffles to perform. 10000 is a good safe choice,
%   though this will take awhile to run.

%%%%% OUTPUTS:
% pValues - probability that that cell's mutual information is due to
%   chance. select coding cells by requiring p<0.05 or p<0.01
% MIscores - raw mutual information scores, in bits


options.suppressOutput=0;
options=getOptions(options,varargin);

if iscell(cellEvents)
    cellEventMat=zeros(length(cellEvents),length(binnedTrace));
    for cInd=1:length(cellEvents)
        cellEventMat(cInd,cellEvents{cInd})=1;
    end
end

nCells=size(cellEvents,1);
nFrames=length(binnedTrace);
MIscores = calcMI(cellEvents,binnedTrace);

shufInc=round(nShuffles/10);

shufMI=zeros(nShuffles,nCells);
for shufInd=1:nShuffles
    
    if ~options.suppressOutput && mod(shufInd,shufInc)==0
        disp(['Shuffle ' num2str(shufInd) ' of ' num2str(nShuffles)])
    end
    
    shufEvents=cellEvents(:,randperm(nFrames));
    shufMI(shufInd,:)=calcMI(shufEvents,binnedTrace);
end

pValues=zeros(nCells,1);
for cInd=1:nCells
    pValues(cInd)=sum(shufMI(:,cInd)>=MIscores(cInd))/nShuffles;
end