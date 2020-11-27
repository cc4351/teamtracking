rootdir = 'E:\signe_170622_Gi1-halo-ins4a-ptxs-D2wt sulp\sim4';
% dir = strcat(rootdir, '\ImageData');
groundTruth = load(truthDir).receptorInfoLabeledPB.receptorTraj;
firstFrame = groundTruth(:,:,1);
pixelSize = 80;
sideLen = 236*pixelSize/1000;
% flip along x axis, change y coords
% likely to be caused by bottom left (0,0) changing to top left (0, 0)
% firstFrame(:,2) = sideLen - firstFrame(:,2);
for i = 1:length(firstFrame)
    ty = sideLen - firstFrame(i,1);
    tx = firstFrame(i, 2);
    firstFrame(i,1) = tx;
    firstFrame(i,2) = ty; 
end 





% %3D visualization of all tracks
% traj = groundTruth;
% for i = 1: size(traj, 1)
%     tmp = traj(i,:,:);
%     tmp = reshape(tmp, 2, [])';
%     plot3(tmp(:,1), tmp(:, 2), 1:4001);
%     hold on
% end 
% hold off


% cd(dir);
% h = figure;
% axis tight manual % this ensures that getframe() returns a consistent size
% filename = 'testAnimated.gif';
% len = min(length(dir), 100);
% % u-track generated output
% movieInfo = load('E:\signe_170622_Gi1-halo-ins4a-ptxs-D2wt sulp\sim4\movieInfo').movieInfo;
% truthDir = strcat(rootdir, '\groundTruth');
% groundTruth = load(truthDir).receptorInfoLabeledPB.receptorTraj;
% groundTruth = groundTruth / 80 * 1000;
% x = 0;
% for i = 1:len
%     t = Tiff(sprintf('fov1_%05d.tif', i),'r');
%     imageData = read(t);
%     imshow(imageData,[]); 
%     hold on;
%     axis on;
%     tmpFrame = movieInfo(i);
%     for j = 1:length(tmpFrame.xCoord)
%         cx = tmpFrame.xCoord(j,1);
%         cy = tmpFrame.yCoord(j,1);
%         pos = [cx-2.5, cy-2.5, 5, 5];
%         rectangle('Position',pos,'EdgeColor','r');
%     end
%     truthFrame = groundTruth(:, :, i);
%     for j = 1:length(truthFrame)
%         tx = truthFrame(j, 1);
%         ty = truthFrame(j, 2);
%         pos_t = [tx-2.5, ty-2.5, 5, 5];
%         rectangle('Position',pos_t,'EdgeColor','g');
%     end
%     hold off;
%     frame = getframe(h); 
%     im = frame2im(frame); 
%     [imind,cm] = rgb2ind(im,256); 
% %     Write to the GIF File 
%     if i == 1 
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
%     else
%         imwrite(imind,cm,filename,'gif','WriteMode','append');
%     end 
% end 
