% February 19-25 %
%
% In MATLAB:
%
% For now, this file will function as a log of what we do during our in-person meetings

[movieParam,detectionParam] = makeParams( 'C:\u-track\#03Ch1\uTrackSettings.txt' )

% Edit: 2/26/2020
%
% You need to edit the uTrackSettings.txt file to set maskLoc to the location of mask.tif

% Except replace the C:\u-track\ with the location where you placed the data we downloaded today

% You can then execute the following, but I'd recommend placing a red dot at line 908 in detectSubResFeatures2D_StandAlone.m

detectSubResFeatures2D_StandAlone(movieParam,detectionParam,0,0)

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

% February 26-Mar 3
%
% We went through detectSubResFeatures2D_StandAlone (focusing on lines 315-673)

% Mainly, we looked at several of the important images that are generated in the pipeline:

figure; imagesc(bgMeanInteg) % Generated at line 426 using spatialMovAveBG.m
figure; imagesc(fImg) % Generated at line 453 using locmax2d.m
figure; imagesc(imageIntegF) % Generated at line 417 using filterGauss2D.m

% We looked at the "first filter" for passing potential molecules along to the next stage:
% This creates an array of p-values (lower is more likely to be a real signal), 
pValue = 1 - normcdf(localMaxAmp,bgMeanMaxF,bgStdMaxF); % At line 469

% If you debug into the code once the cands structure has been produced, you can look at the imageIntegF
% with the cands (candidates for signal) structure data plotted on top

figure; imagesc(imageIntegF)
hold on; arrayfun( @(x) plot(x.Lmax(2),x.Lmax(1),'wo'), cands )

% Please check out the doc about structfun and arrayfun - we use these pretty extensively and they
% save dozens of lines of code + time per day. 

% myrandmovie = rand(100,100,1000);
% figure; for i = 1:1000; imagesc( myrandmovie(:,:,i) ); pause(0.03); end
