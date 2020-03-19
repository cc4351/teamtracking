% In MATLAB:

addpath('C:\teamtracking');

[movieParam,detectionParam] = makeParams( 'C:\teamtracking\uTrackSettings-1.txt' )

% Except replace the C:\u-track\ with the location where you placed the data we downloaded today

% You can then execute the following, but I'd recommend placing a red dot at line 908 in detectSubResFeatures2D_StandAlone.m

%%

[movieInfo,exceptions,localMaxima,background,psfSigma] = detectSubResFeatures2D_StandAlone(movieParam,detectionParam,0,1);

%%

% Once you're in there, you'll see all your workspace variables on the
% right. You can obtain an image of the current frame going through the
% loop with the following code:

figure; imagesc( imageRaw )

% See if you can use patch or plot to draw an ROI around the current object
% (featuresInfo contains the x- and y- coordinates and the uncertainty)

% Take a look at how the least squares, non-linear fitting is done. 
% You can find this on lines 320-329 of the similarily named file: detectSubResFeatures2D_V2

edit detectSubResFeatures2D_V2

% This routine tries to optimize an objective function, the difference
% between a theoretical image and the image of the point in the frame. You
% can find the objective function here:

edit fitNGaussians2DVarSigma

% See if you can output some quality-control parameters from the function,
% add any other constraints, distance transformation info...
% 
% We can talk about the rest next week!