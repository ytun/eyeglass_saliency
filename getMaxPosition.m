function [x,y]=getMaxPosition(salmap,sigma,gaze_hat)
%function [x,y]=getMaxPosition_edit()

%im=getSaliency(img_dir);

%salmap=im2double(imread('coins.png'));
[h,w]=size(salmap);

%gaze_hatX=round(4*w/5)
%gaze_hatY=round(1*h/5)

%[r,c]=find(im==max(im(:)));

gaze_hatX=gaze_hat(1);
gaze_hatY=gaze_hat(2);

maxWidth=max((w-gaze_hatX),gaze_hatX);
maxHeight=max((h-gaze_hatY),gaze_hatY);
hsize=2*(max(maxHeight,maxWidth));

%sigma=5;%(hsize-1)/2;%10;%w/2;%(hsize-1)/2;
gfilter = imresize(fspecial('gaussian',hsize+1,sigma),2*[ maxHeight maxWidth]);

% figure;
% imagesc(gfilter);
% hold on;
% %scatter(maxWidth+gaze_hatX, maxHeight+gaze_hatY,'xr');
% scatter(maxWidth, maxHeight, 'og');
% scatter(2*maxWidth-w+gaze_hatX, 2*maxHeight-h+gaze_hatY, 'xb');
% %imshow(salmap);
% hold off;
% figure;
% scatter(gaze_hatX, gaze_hatY,'xr');
%
% size(salmap)

[gh, gw]=size(gfilter);

%Bottom right corner patch
if gaze_hatX>=(w-gaze_hatX) && gaze_hatY>=(h-gaze_hatY)
    %fprintf('Bottom right');
    croppedfil=gfilter(1:h,1:w);
    %Top right corner
elseif gaze_hatX>=(w-gaze_hatX) && gaze_hatY<(h-gaze_hatY)
    %fprintf('Top right');
    croppedfil=gfilter((gh-h+1):gh, 1:w);
    %Top left corner
elseif gaze_hatX<(w-gaze_hatX) && gaze_hatY<(h-gaze_hatY)
    %fprintf('Top left');
    croppedfil=gfilter((gh-h+1):gh,(gw-w+1):gw);
    %Bottom left corner
else% gaze_hatX<(w-gaze_hatX) && gaze_hatY>=(h-gaze_hatY)
    %fprintf('Bottom left');
    croppedfil=gfilter(1:h,(gw-w+1):gw);
end

%[sigma gaze_hatX gaze_hatY]
scoreMat = salmap.* croppedfil;

%imagesc(scoreMat);

% range = 5;
% min_row = max(gaze_hatX - range,1);
% max_row = min(gaze_hatX + range,maxHeight);
% min_col = max(gaze_hatY - range,1);
% max_col = min(gaze_hatY + range,maxWidth);

%scoreMat(gaze_hatX,gaze_hatY)
%range_matrix = scoreMat(min_row:max_row,min_col:max_col);
% [row_scoreMax, col_scoreMax ]=find(scoreMat==max(scoreMat(:)));
% %gaze_hat;
% x=col_scoreMax(1);
% y=row_scoreMax(1);

BW=logical(scoreMat==max(scoreMat(:)));
%stat=regionprops(true(size(scoreMat)), scoreMat,  'WeightedCentroid');

stat=regionprops(true(size(BW)), BW,  'WeightedCentroid');
x=round(stat.WeightedCentroid(1));
y=round(stat.WeightedCentroid(2));

% figure;
% subplot(1,3,1);
% imagesc(scoreMat);
% hold on;
% scatter(gaze_hatX,gaze_hatY,'xb');
% scatter(x,y,'or');
% hold off;
% subplot(1,3,2);
% imagesc(croppedfil);
% hold on;
% scatter(gaze_hatX,gaze_hatY,'xb');
% scatter(x,y,'or');
% hold off;
% subplot(1,3,3);
% imagesc(salmap);
% colormap gray;
% hold on;
% scatter(gaze_hatX,gaze_hatY,'xb');
% scatter(x,y,'or');
% hold off;


