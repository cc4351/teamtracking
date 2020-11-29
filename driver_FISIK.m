%%%%%%%%%%%%%%%%%%
% simulated data %
%%%%%%%%%%%%%%%%%%

modelParam = struct('diffCoef',[], 'receptorDensity', [],...
    'aggregationProb', [], 'aggregationDist', [],'dissociationRate', [],...
    'labelRatio', [], 'intensityQuantum', [], 'initPositions', []);

simParam = struct('probDim', [], 'observeSideLen', [], 'timeStep', [],...
    'simTime', [], 'initTime', [], 'randNumGenSeeds', []);


%know for sure
modelParam.diffCoef = 0.44;
modelParam.stdDiff = 0.13;
modelParam.intensityQuantum = [9, 0];%assumes uniform fluorescence
simParam.probDim = 2;
simParam.timeStep = 0.015;
simParam.simTime = 4000*0.015;
simParam.initTime = 1000*0.015;
simParam.randNumGenSeeds = 100;

%some guesses
pixelSize = 80;
simParam.observeSideLen = 236*pixelSize/1000;
modelParam.receptorDensity = 160/simParam.observeSideLen^2;
modelParam.labelRatio = 0.4;
% assumption: single pixel size 9nm x 9nm, with 256 x 256 px per frame

%trivial params
modelParam.aggregationProb = 0.0;
modelParam.aggregationDist = 10;
modelParam.dissociationRate = 0.5;


[receptorInfoAll,receptorInfoLabeled,timeIterArray,errFlag]...
    = receptorAggregationVaryDiffCoef(modelParam, simParam);

fracSurvive =  0.9996;
receptorInfoLabeledPB = genReceptorInfoLabeledPhotobleaching(receptorInfoAll,...
                        modelParam.labelRatio,modelParam.intensityQuantum,fracSurvive)

traj = receptorInfoLabeledPB.receptorTraj;
for i = 1: size(traj, 1)
    tmp = traj(i,:,:);
    tmp = reshape(tmp, 2, [])';
    plot3(tmp(:,1), tmp(:, 2), 1:4001);
    hold on
end 
hold off


step2Output = aggregStateFromCompIntensity(receptorInfoLabeledPB.compTracks);

spaceTimeSpec = struct('probDim', [], 'areaSideLen', [], 'timeStep', []);

spaceTimeSpec.probDim = 2;
spaceTimeSpec.areaSideLen = simParam.observeSideLen;
spaceTimeSpec.timeStep = 0.015;

% 
% [rateOn_sim, rateOff_sim, density_sim,numClust_sim, clustHist_sim, ...
%     clustStats_sim] = clusterOnOffRatesAndDensity(step2Output.defaultFormatTracks,spaceTimeSpec);


%%%%%%%%%%%%%%%%%%%%%%
% real data analysis %
%%%%%%%%%%%%%%%%%%%%%%


% [movieParam,detectionParam,gapCloseParam,costMatrices] = ...
%     makeParams( 'C:\Users\User\Desktop\Single Molecule\FISIK\uTrack_FISIK_settings.txt' );


% [movieInfo,exceptions,localMaxima,background,psfSigma] = detectSubResFeatures2D_StandAlone(movieParam,detectionParam,0)
% movieInfo = load('C:\Users\User\Desktop\Columbia\Sophomore Spring\Single Molecule\Info&Graphs\movieInfo').movieInfo;
% 
% [tracksFinal,kalmanInfoLink,errFlag] = trackCloseGapsKalmanSparse(movieInfo,...
% costMatrices,gapCloseParam,kalmanFunctions,2,0,[], 1);

% 
% tracksFinal = load('C:\Users\User\Desktop\Single Molecule\Info&Graphs\tracksFinal.mat').tracksFinal;
% 
% for i = 1:length(tracksFinal)
%     row = tracksFinal(i);
%     tracksFinal(i).tracksFeatIndxCG = sparse(row.tracksFeatIndxCG);
%     tracksFinal(i).tracksCoordAmpCG = sparse(row.tracksCoordAmpCG);
% end
% step2exp = aggregStateFromCompIntensity(tracksFinal);
% 
% defaultTracks = step2exp.defaultFormatTracks;
% for i = 1:length(defaultTracks)
%     row = defaultTracks(i).aggregState;
%     for j = 1:length(row)
%        row(j)= max([1 row(j)]);
%     end
%     defaultTracks(i).aggregState = row;
% end
% [rateOn_exp, rateOff_exp, density_exp,numClust_exp, clustHist_exp, ...
%     clustStats_exp] = clusterOnOffRatesAndDensity(defaultTracks,spaceTimeSpec);

% 
% 
% % this func needs some input checking mechanism
% function [rateOnPerClust,rateOffPerClust,densityPerClust,...
%     numClustForRateCalc,clustHistory,clustStats] = steps23(compTracks, spaceTimeSpec)
% 
% compTracksOut = aggregStateFromCompIntensity(compTracks);
% 
% [rateOnPerClust,rateOffPerClust,densityPerClust,...
%     numClustForRateCalc,clustHistory,clustStats] = ...
%     clusterOnOffRatesAndDensity(compTracksOut.defaultFormatTracks, spaceTimeSpec);
% end
% 
% .sampleStep     : Sampling time step, in same units as
      %                       timeStep. Mostly relevant for
      %                       simulated data where simulation time step
      %                       might be 0.01 s but sampling time step of
      %                       interest is e.g. 0.1 s.
      %     .cutOffTime     : Total time of simulation (s) to be considered.

timeInfo = struct('simTimeStep',[], 'sampleStep', [], 'cutOffTime', []);
timeInfo.simTimeStep = spaceTimeSpec.timeStep;
timeInfo.sampleStep = spaceTimeSpec.timeStep;
timeInfo.cutOffTime = simParam.simTime;



bitDepthPow = 2^7
intensityInfo = struct('bgav', 18.7714*bitDepthPow, 'bgnoise', 1.8077*bitDepthPow, 'scaleFactor', []);
%scaleFactor: scale factor for particle intensities to
      %                       convert to grayscale units, assuming a 16-bit
      %                       camera.
intensityInfo.scaleFactor = 2^16/bitDepthPow;

%psfSigma?
spaceInfo = struct('pixelSize', 80/1000, 'psfSigma', round(1.1100), 'imsize', []);

spaceInfo.imsize = [236*pixelSize/1000, 236*pixelSize/1000];
root = 'E:\signe_170622_Gi1-halo-ins4a-ptxs-D2wt sulp\';
saveInfo = struct('saveVar', 1, 'saveDir', root);
    

getImageStackFromTracksDirect_New(receptorInfoLabeledPB.compTracks, timeInfo, ...
    intensityInfo, spaceInfo, saveInfo);

save(strat(root, 'groundTruth'), 'receptorInfoLabeledPB');




