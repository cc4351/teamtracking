% April 1-2020 %
%
% In MATLAB:
%

addpath('C:\teamtracking');

[movieParam,detectionParam,gapCloseParam,costMatrices] = makeParams( 'E:\\#BackupMicData\\2017 May-Jun\\170511_WA-MH_SNAPf-mGlu2-Cy3AC-Cy5AC_w&wo Glu_Live FRET\\333 nM Cy3AC_666 nM Cy5AC_PassX_100 ngmL tet_50 PCA PCD\\Track_Opt28-TW5_52418\\#01Ch1\\uTrackSettings.txt' )

[movieInfo,exceptions,localMaxima,background,psfSigma] = detectSubResFeatures2D_StandAlone(movieParam,detectionParam,0,1);

%%

[tracksFinal,kalmanInfoLink,errFlag] = trackCloseGapsKalmanSparse(movieInfo,...
costMatrices,gapCloseParam,kalmanFunctions,2,0,1);