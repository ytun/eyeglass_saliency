

data = importdata('y1sm4.mat');
allImage = data.Out;
gaze_points = round(data.gaze);
true_points = round(data.gaze);

num_of_test = 0
figure
for i=1:size(allImage,1),
    image = allImage(i,:);
    image = reshape(image,[],111);
    rgb_im(:,:,1) = image;
    rgb_im(:,:,2) = image;
    rgb_im(:,:,3) = image;
%imwrite(rgb_im,'b.png');
    [salmap,im_size] = getSaliency(rgb_im);
%[salmap,im_size] = getSaliency('addison_circle.png');




%[gaze_points, true_points] = load_data ...
%    ('data/subset_l1_init_strips_k7_lambda0.001000/v7_rep1.mat',im_size);

%salmap = getSaliency('addison_circle_3d.jpg');
    bestSigma = 56;
%bestSigma( salmap, gaze_points, true_points);

    [max_x, max_y] = getMaxPosition(salmap,bestSigma,gaze_points(i,:));
    max = [max_x, max_y]
    gaze = gaze_points(i,:)
    true_points(i,:);

    points=[max_x, max_y;gaze_points(i,:);true_points(i,:)];

    %figure;
    %subplot(1,3,1);
    %imshow(rgb_im);
    %subplot(1,3,2);
    %C = imfuse(rgb_im,salmap,'falsecolor','Scaling','joint');%,'ColorChannels',[1 2 0]);
    %imshow(C);
    subplot(3,3,i);
    imshow(salmap);
    hold on;
    scatter(max_x, max_y,'xg');
    scatter(gaze_points(i,1),gaze_points(i,2),'or');
    scatter(true_points(i,1),true_points(i,2),'+b');

    hold off;
    num_of_test = num_of_test + 1;
    if num_of_test == 9
        break
    end
end
%legend('new_gaze','neural_gaze','true_gaze');
