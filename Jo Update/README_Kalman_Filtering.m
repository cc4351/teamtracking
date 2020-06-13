% March 18
% Step 2 of U-Track
% Going from x,y positions to linked tracks

% After you obtain movieInfo, you should be able to then use it to get
% tracks

% However, you'll first need to make Param sets that need to be fed into
% the next step, these param sets are gapCloseParam and costMatrices

% I've modified makeParams so that it extracts the information for all of
% these other parameter sets

[movieParam,detectionParam,gapCloseParam,costMatrices] = makeParams( 'C:\teamtracking\uTrackSettings-1.txt' );

% Next, you should be able to run this:

[tracksFinal,kalmanInfoLink,errFlag] = trackCloseGapsKalmanSparse(movieInfo,...
costMatrices,gapCloseParam,kalmanFunctions,2,0,1);