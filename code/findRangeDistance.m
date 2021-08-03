data = importdata('y1sm4.mat');
% Loading images
allImage = data.Out;

% Loading gazed positions
gaze_est = round(data.gaze_est);
gaze_est = [gaze_est(:,1), gaze_est(:,2)];

%Loading true positions
gaze_true = round(data.gaze_true);
gaze_true = [gaze_true(:,1),gaze_true(:,2)];

dist = sqrt((gaze_est(:,1)-gaze_true(:,1)).^2 + (gaze_est(:,2)-gaze_true(:,2)).^2);

minDistance = min(dist)
maxDistance = max(dist)
meanDistance = mean(dist)
