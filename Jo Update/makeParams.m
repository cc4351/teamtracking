function [movieParam,detectionParam,varargout] = makeParams( utracksettingsfile )

tld_ = regexp( utracksettingsfile,'(.*)(?<=\\)','match'); tld_ = tld_{1};

movieParam.('filenameBase') = 'fov1_';
movieParam.('imageDir') = strcat( tld_, 'ImageData\\' );
movieParam.('firstImageNum') = 1;
movieParam.('lastImageNum') = numel(dir( movieParam.('imageDir') ))-2;
movieParam.('digits4Enum') = 5;

% detectionParam
detectionParam_str = {'psfSigma',...
            'visual',...
            'doMMF',...
            'bitDepth',...
            'alphaLocMax',...
            'numSigmaIter',...
            'integWindow',...
            'maskLoc',...
            'calcMethod',...
            'testAlphaR',...
            'testAlphaA',...
            'testAlphaD',...
            'testAlphaF'};
% trackingParam
gapCloseParam_str = {'timeWindow',...
            'mergeSplit',...
            'minTrackLen',...
            'diagnostics'};
% Tracking cost matrix for frame-to-frame linking params (costMatrices 1)
costMatrices_f2f_str = {'linearMotion',...
            'minSearchRadius',...
            'maxSearchRadius',...
            'brownStdMult',...
            'useLocalDensity',...
            'nnWindow',...
            'kalmanInitParam',...
            'diagnostics'};
% Tracking cost matrix for gap closing params (costMatrices 2)
costMatrices_gapclosing_str = {'linearMotion',...
            'minSearchRadius',...
            'maxSearchRadius',...
            'brownStdMult',...
            'brownScaling',...
            'timeReachConfB',...
            'ampRatioLimit',...
            'lenForClassify',...
            'useLocalDensity',...
            'nnWindow',...
            'linStdMult',...
            'linScaling',...
            'timeReachConfL',...
            'maxAngleVV',...
            'gapPenalty',...
            'resLimit',...
            };

    fid = fopen( utracksettingsfile );
    all_text = textscan( fid, '%s' );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create the structure for the detectionParams  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    detectionParam = struct();
    for param = detectionParam_str
       detectionParam.(param{1}) = str2double(all_text{1}{find(cellfun( @(x) numel(x)>0, strfind(all_text{1},param{1}) )==1)+1});
    end

    % Workaround in case of linebreaks (folders should always use //)
    detectionParam.('maskLoc') = join( all_text{1}(find(cellfun( @(x) numel(x)>0, strfind(all_text{1},'maskLoc') ) == 1)+1 : find(cellfun( @(x) numel(x)>0, strfind(all_text{1},'calcMethod') ) == 1)-1) );
    detectionParam.('maskLoc') = detectionParam.('maskLoc'){1};
    if eq( exist( detectionParam.('maskLoc') ), 0 ); detectionParam.('maskLoc') = strcat( tld_, 'mask.tif' ); end
    if eq( exist( detectionParam.('maskLoc') ), 0 ); fprintf('No suitable mask file located!\n'); return; end;
    detectionParam.('calcMethod') = all_text{1}{find(cellfun( @(x) numel(x)>0, strfind(all_text{1},'calcMethod') ) == 1)+1};

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create the structure for gap closing parameters       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    gapCloseParam = struct();
    for param = gapCloseParam_str
        if strcmp( param{1}, 'diagnostics' )
            tmp = all_text{1}{find(cellfun( @(x) numel(x)>0, strfind(all_text{1},param{1}) )==1)+1};
            gapCloseParam.(param{1}) = str2double( tmp(1) );
        else
            gapCloseParam.(param{1}) = str2double(all_text{1}{find(cellfun( @(x) numel(x)>0, strfind(all_text{1},param{1}) )==1)+1});
        end
    end    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create the structure for costMatrices                 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    costMatrices = [ struct(); struct(); ];
    
    % Gap closing
    for param = costMatrices_f2f_str
        tmp = all_text{1}{find(cellfun( @(x) numel(x)>0, strfind(all_text{1},param{1}) )==1)+1};
        costMatrices(1).parameters.(param{1}) = str2double( tmp );
    end    
      
    % Frame to Frame linking
    for param = costMatrices_gapclosing_str
        
        matches = find(cellfun( @(x) numel(x)>0, strfind(all_text{1},param{1}) )==1);
        
        % Take the second entry
        if numel( matches ) > 1
            tmp = all_text{1}{ matches(2)+1 };
            costMatrices(2).parameters.(param{1}) = str2double( tmp );
            continue;
        end
        
        % Handle empty parameters
        if gt(find(cellfun( @(x) numel(x)>0, strfind(all_text{1},param{1}) )==1)+1,size(all_text{1},1));
            costMatrices(2).parameters.(param{1}) = [];
            continue;
        else
        end
        
        % Handle parameters with arrays
        if regexp( param{1}, 'brownScaling|ampRatioLimit|linScaling' )
            [costMatrices(2).parameters.(param{1})(1),costMatrices(2).parameters.(param{1})(2)] = deal( str2double(all_text{1}{find(cellfun( @(x) numel(x)>0, strfind(all_text{1},param{1}) )==1)+1}), ...
                str2double(all_text{1}{find(cellfun( @(x) numel(x)>0, strfind(all_text{1},param{1}) )==1)+1}) );
            continue;
        else
        end
        
        tmp = all_text{1}{ matches+1 };
        costMatrices(2).parameters.(param{1}) = str2double( tmp );
    end    
    
    costMatrices(1).parameters.funcName = 'costMatRandomDirectedSwitchingMotionLink';
    costMatrices(2).parameters.funcName = 'costMatRandomDirectedSwitchingMotionCloseGaps';
    costMatrices(1).funcName = 'costMatRandomDirectedSwitchingMotionLink';
    costMatrices(2).funcName = 'costMatRandomDirectedSwitchingMotionCloseGaps';
    if isnan( costMatrices(1).parameters.kalmanInitParam ); costMatrices(1).parameters.kalmanInitParam = []; end;
    
    % Patch -- go back and fix later %
    costMatrices(2).parameters.brownStdMult = 4 * ones(costMatrices(2).parameters.nnWindow, 1 ); 
    costMatrices(2).parameters.linStdMult = 1 * ones(costMatrices(2).parameters.nnWindow, 1 );
    
    varargout{1} = gapCloseParam;
    varargout{2} = costMatrices;
    assignin('base','probDim',2);
    
    kalmanFunctions.reserveMem  = 'kalmanResMemLM';
    kalmanFunctions.initialize  = 'kalmanInitLinearMotion';
    kalmanFunctions.calcGain    = 'kalmanGainLinearMotion';
    kalmanFunctions.timeReverse = 'kalmanReverseLinearMotion';
    assignin('base','kalmanFunctions',kalmanFunctions);
    
end