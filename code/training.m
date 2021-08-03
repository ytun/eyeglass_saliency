% Loading data
data = importdata('y1sm4.mat');
% Loading images
allImage = data.Out;

% Loading gazed positions
gaze_points = round(data.gaze_est);
gaze_points = [gaze_points(:,1), gaze_points(:,2)];

%Loading true positions
true_points = round(data.gaze_true);
true_points = [true_points(:,1),true_points(:,2)];
%true_points(:,2)= repmat(max(true_points(:,2),1),size(true_points,1))-true_points(:,2);
num_of_train = 50;
salmaps = cell(num_of_train,1);
for i=1:num_of_train%size(allImage,1),
    image = allImage(i,:);
    i
    image = reshape(image,[],112);
    rgb_im(:,:,1) = image;
    rgb_im(:,:,2) = image;
    rgb_im(:,:,3) = image;
    [salmap,im_size] = getSaliency(rgb_im);
    salmaps{i} = salmap;
    
end

sigma = bestSigma( salmaps, gaze_points, true_points, num_of_train)
