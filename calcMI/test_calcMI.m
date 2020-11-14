function MI = test_calcMI(cellEvents,externalTrace)

% get parameters
nCells=size(cellEvents,1);
nFrames=size(cellEvents,2);
MI = nan(nCells,1);

if length(externalTrace)~=nFrames
    display('length of response and stimulus are not equal');
    return
else
    % divide y to have nYvalues discrete values, range 0 to nYvalues-1
    %Y=round((stimulusSignal-min(stimulusSignal))*(nYvalues-1)/(max(stimulusSignal)-min(stimulusSignal)));
    Y=round(externalTrace-min(externalTrace));
    nYvalues=max(Y)+1;
end
% put X data into logical matrix
X=logical(cellEvents);

% calculate empirical probability distributions
logProbY=zeros(1,nYvalues);
logProbX0givenY=zeros(nCells, nYvalues);
logProbX1givenY=zeros(nCells, nYvalues);
for yVal=0:nYvalues-1
    logProbY(yVal+1)=log(sum(Y==yVal))-log(nFrames);
    theseX=X(:,Y==yVal);
    logProbX0givenY(:,yVal+1)=log(sum(1-theseX,2)+1)-log(size(theseX,2)+2);
    logProbX1givenY(:, yVal+1)=log(sum(theseX,2)+1)-log(size(theseX,2)+2);
end
logProbX0=log(sum(1-X,2))-log(nFrames);
logProbX1=log(sum(X,2))-log(nFrames);
logProbX0andY=log(exp(logProbX0givenY).*repmat(exp(logProbY),nCells,1));
logProbX1andY=log(exp(logProbX1givenY).*repmat(exp(logProbY),nCells,1));

% calculate MI
MI=sum(exp(logProbX0andY).*(logProbX0andY-repmat(logProbX0,1,nYvalues)-repmat(logProbY,nCells,1)),2)+...
    sum(exp(logProbX1andY).*(logProbX1andY-repmat(logProbX1,1,nYvalues)-repmat(logProbY,nCells,1)),2);