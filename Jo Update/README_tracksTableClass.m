%% April 3, 2020 %%

% The following is a light introduction to using tracksTableClass

% If you have saved the output variables from trackCloseGapsKalmanSparse in
% a MATLAB workspace, this should be easy to run. If you didn't take that
% step, you'll have to re-run the trackCloseGapsKalmanSparse algorithm.
% Once complete, run: save('Tracking.mat') to save all your workspace
% variables.

myTracks = tracksTableClass('C:\\teamtracking\\'); % This folder should be the location where you saved your Tracking.mat file

% At this point you should be able to obtain the trackBoundaries by using
% the in-place method for this class

myTracks.getTrackBoundaries();

% Now myTracks will contain values in myTracks.tracksTable for the shortest
% distance between the start and the end of the track from the boundary of
% the cell

myTracks.tracksTable([1:10],:).D_start_to_edge % Would give you ten trajectories with the distance between their starting x,y and the nearest edge
myTracks.tracksTable([1:10],:).D_end_to_edge % Would give you ten trajectories with the distance between their ending x,y and the nearest edge

% You can plot a random subset of tracks against a background containing
% the boundary by entering:

plot( t, 'bounds' )

% A disclaimer and an area of active work -- we see that the boundaries can
% be very irregular for some cells and this is an issue for us. A quick explanation for 
% how the boundaries are located: every trajectory is projected down into a 2-d image
% and a single mask is drawn around the largest continuous area of trajectory-covered pixels. 
% 
% This means that a cell could be very round and regular in the mask.tif
% image but that when you plot the bounds above, it may exclude large
% regions of the cell. This is likely because the cell is 'detached' from
% the surface of the coverslip where imaging occurs or because molecules
% cannot go into those areas. We're not sure yet. I am going to add a short
% function to also get the distances from the mask.tif boundaries of the
% cell and the trajectory start and finishes.