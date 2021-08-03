% Loading data
clear;
data = importdata('y1sm4.mat');
% Loading images
allImage = data.Out;

% Loading gazed positions
gaze_est = round(data.gaze_est);
gaze_est = [gaze_est(:,1), gaze_est(:,2)];

%Loading true positions
gaze_true = round(data.gaze_true);
gaze_true = [gaze_true(:,1),gaze_true(:,2)];

%Result
gaze_new = zeros(size(gaze_true,1),2);

% Control number of images to plot
num_of_test = 0;
fstIm = 150;
figure;

for i=fstIm:size(allImage,1),
    image = allImage(i,:);
    image = reshape(image,[],112);
    subplot(1,2,i-fstIm+1);
    imshow(image);
    num_of_test = num_of_test + 1;
    if num_of_test == 2
        break
    end
end

figure;
num_of_test = 0;
for i=fstIm:size(allImage,1),
    image = allImage(i,:);
    image = reshape(image,[],112);
    rgb_im(:,:,1) = image;
    rgb_im(:,:,2) = image;
    rgb_im(:,:,3) = image;
    [salmap,im_size] = getSaliency(rgb_im);
    bestSigma = 5;
    
    %bestSigma(salmap, gaze_points, true_points);

    [max_x, max_y] = getMaxPosition(salmap,bestSigma,gaze_est(i,:));
    %gaze = gaze_est(i,:)
    %gaze_true(i,:);
    %points=[max_x, max_y;gaze_est(i,:);gaze_true(i,:)];

    %figure;
    %subplot(1,3,1);
    %imshow(rgb_im);
    %subplot(1,3,2);
    %C = imfuse(rgb_im,salmap,'falsecolor','Scaling','joint');%,'ColorChannels',[1 2 0]);
    %imshow(C);
    
    subplot(1,2,i-fstIm+1);
    imshow(salmap);
    hold on;
    scatter(max_x, max_y,'g','filled');
    scatter(gaze_est(i,1),gaze_est(i,2),'r','filled');
    scatter(gaze_true(i,1),gaze_true(i,2),'b','filled');

    hold off;
    num_of_test = num_of_test + 1;
    if num_of_test == 2
        break
    end
end
legend('gaze new','gaze est','gaze true');
%comparing error
fst = 1;
lst = 500;
for i=fst:lst%size(allImage,1),
    image = allImage(i,:);
    image = reshape(image,[],112);
    rgb_im(:,:,1) = image;
    rgb_im(:,:,2) = image;
    rgb_im(:,:,3) = image;
    [salmap,im_size] = getSaliency(rgb_im);
    bestSigma = 5;
    
    [max_x, max_y] = getMaxPosition(salmap,bestSigma,gaze_est(i,:));
    gaze_new(i,1) = max_x;
    gaze_new(i,2) = max_y;
end

% dist = sqrt((gaze_est(fst:lst,1)-gaze_true(fst:lst,1)).^2 ...
%     + (gaze_est(fst:lst,2)-gaze_true(fst:lst,2)).^2);
% minDistance = min(dist);
% maxDistance = max(dist);
% meanDistance = mean(dist);
% [min(dist) max(dist) mean(dist) var(dist) std(dist)]
% 
% dist = sqrt((gaze_new(fst:lst,1)-gaze_true(fst:lst,1)).^2 ...
%     + (gaze_new(fst:lst,2)-gaze_true(fst:lst,2)).^2);
% minDistance = min(dist);
% maxDistance = max(dist);
% meanDistance = mean(dist);
% [min(dist) max(dist) mean(dist) var(dist) std(dist)]


dist1 = sqrt((gaze_est(fst:lst,1)-gaze_true(fst:lst,1)).^2 ...
    + (gaze_est(fst:lst,2)-gaze_true(fst:lst,2)).^2);
minDistance = min(dist1);
maxDistance = max(dist1);
meanDistance = mean(dist1);
[min(dist1) max(dist1) mean(dist1) var(dist1) std(dist1)]

counts1=hist(dist1,20);

dist2 = sqrt((gaze_new(fst:lst,1)-gaze_true(fst:lst,1)).^2 ...
    + (gaze_new(fst:lst,2)-gaze_true(fst:lst,2)).^2);
minDistance = min(dist2);
maxDistance = max(dist2);
meanDistance = mean(dist2);
counts2=hist(dist2,20);

figure;
subplot(1,2,1);
histfit(dist1,20);
hold on 
scatter(mean(dist1), 0, 'xr')
hold off
ylim([0 max(max(counts1(:)),max(counts2(:)))]);
title('Original Error Distribution of Gaze Estimate')

subplot(1,2,2);
histfit(dist2,20);
hold on 
scatter(mean(dist2), 0, 'xr')
hold off
ylim([0 max(max(counts1(:)),max(counts2(:)))]);
title('Our Error Distribution of Gaze Estimate')
[min(dist2) max(dist2) mean(dist2) var(dist2) std(dist2)]


%legend('new_gaze','neural_gaze','true_gaze');