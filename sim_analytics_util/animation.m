rootdir = 'E:\signe_170622_Gi1-halo-ins4a-ptxs-D2wt sulp\sim4';
dir = strcat(rootdir, '\ImageData');
cd(dir);
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'testAnimated.gif';
len = min(length(dir), 100);
% u-track generated output
movieInfo = load('E:\signe_170622_Gi1-halo-ins4a-ptxs-D2wt sulp\sim4\movieInfo').movieInfo;
truthDir = strcat(rootdir, '\groundTruth');
groundTruth = load(truthDir).receptorInfoLabeledPB.receptorTraj;
tmpY = groundTruth(:, 1, :);
groundTruth(:, 1, :) = groundTruth(:, 2, :);
groundTruth(:, 2, :) = tmpY;
groundTruth = groundTruth / 80 * 1000 + 10;
x = 0;
for i = 1:len
    t = Tiff(sprintf('fov1_%05d.tif', i),'r');
    imageData = read(t);
    imshow(imageData,[]); 
    hold on;
    axis on;
    tmpFrame = movieInfo(i);
    for j = 1:length(tmpFrame.xCoord)
        cx = tmpFrame.xCoord(j,1);
        cy = tmpFrame.yCoord(j,1);
        pos = [cx-2.5, cy-2.5, 5, 5];
        rectangle('Position',pos,'EdgeColor','r');
    end
    truthFrame = groundTruth(:, :, i);
    for j = 1:length(truthFrame)
        tx = truthFrame(j, 1);
        ty = truthFrame(j, 2);
        pos_t = [tx-2.5, ty-2.5, 5, 5];
        rectangle('Position',pos_t,'EdgeColor','g');
    end
    hold off;
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
%     Write to the GIF File 
    if i == 1 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end 
end 
