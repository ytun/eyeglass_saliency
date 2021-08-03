% Loading data
data = importdata('img_data/1450670_10153184863345353_4007921978950760685_n.jpg.mat');
% Loading images
allImage = data.Out;

% Loading gazed positions
gaze_est = round(data.gaze_est);
%gaze_est = [gaze_est(:,1), gaze_est(:,2)];

%Loading true positions
gaze_true = round(data.gaze_true);
%gaze_true = [gaze_true(:,1),gaze_true(:,2)];
%true_points(:,2)= repmat(max(true_points(:,2),1),size(true_points,1))-true_points(:,2);
num_of_train = round(0.75*size(gaze_est,1));
salmaps = cell(num_of_train,1);



for i=1:num_of_train%size(allImage,1),
    image = allImage;
    i
    %image = reshape(image,[],112);
    rgb_im(:,:,1) = image;
    rgb_im(:,:,2) = image;
    rgb_im(:,:,3) = image;
    [salmap,im_size] = getSaliency(rgb_im);
    salmaps{i} = salmap;
    
end

% figure
% imshow(salmap);
% hold on;
% for i=1:num_of_train
% 	scatter(gaze_est(i,1), gaze_est(i,2),'xg');
% 	scatter(gaze_true(i,1), gaze_true(i,2),'or');
% end
% hold off
sigma = bestSigma( salmaps, gaze_est, gaze_true, num_of_train)
