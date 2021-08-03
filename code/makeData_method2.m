% read images, get saliency map, find local maxima, finding responding
% points from data set, get gaze_true and gaze_est data, save to mat files

% Loading data
data = importdata('y1sm4.mat');
% Loading images
allImage = data.Out;

% Loading gazed positions
gaze_est = round(data.gaze_est);
gaze_est = [gaze_est(:,1), gaze_est(:,2)];

%Loading true positions
gaze_true = round(data.gaze_true);
gaze_true = [gaze_true(:,1),gaze_true(:,2)];


new_folder = 'img_new/';
data_folder = 'img_data/';
srcFiles = dir('img_new/*');
sze = 2*1+1;
threshold = 0.05;
for j = 4 : length(srcFiles)
    
    filename = strcat(new_folder,srcFiles(j).name);
    I = imread(filename);
    [salmap,im_size] = getSaliency(I);
    
    
    mx = ordfilt2(salmap,sze^2,ones(sze));
    convolved = ((salmap(:,:)>threshold));% & ...
        %salmap(:,:)==mx(:,:));
    [c,r] = find(convolved);

    size(r);

    figure
    imshow(salmap);
    
    est = [];
    true = [];
    
    hold on;
    num = 0;
    for i=1:size(r,1)
        row = find(ismember(gaze_true,[r(i),c(i)],'rows'));
%         if size(row,1) == 0
%             row = find(ismember(gaze_true,[r(i)-1,c(i)-1],'rows'));
%         end
%         if size(row,1) == 0
%             row = find(ismember(gaze_true,[r(i)+1,c(i)-1],'rows'));
%         end
%         if size(row,1) == 0
%             row = find(ismember(gaze_true,[r(i)-1,c(i)+1],'rows'));
%         end
%         if size(row,1) == 0
%             row = find(ismember(gaze_true,[r(i)+1,c(i)+1],'rows'));
%         end
%         if size(row,1) == 0
%             row = find(ismember(gaze_true,[r(i)-1,c(i)],'rows'));
%         end
%         if size(row,1) == 0
%             row = find(ismember(gaze_true,[r(i),c(i)-1],'rows'));
%         end
%         if size(row,1) == 0
%             row = find(ismember(gaze_true,[r(i)+1,c(i)],'rows'));
%         end
%         if size(row,1) == 0
%             row = find(ismember(gaze_true,[r(i),c(i)+1],'rows'));
%         end
        if size(row,1) == 0
            continue
        end
        t = gaze_true(row,:);
        t = [t(1,1) t(1,2)];
        e = gaze_est(row,:);
        true = [true; t(1,:)];
        e = [e(1,1) e(1,2)];
        est = [est; e(1,:)];
        scatter(t(1,1), t(1,2),'xg');
        scatter(e(1,1), e(1,2),'or');
        num = num + 1;
    end
    num;
    hold off;
    
    imdata.Out = I(:,:,1);
    imdata.gaze_est = est;
    imdata.gaze_true = true;
    filename = strcat(data_folder,srcFiles(j).name,'.mat');
    save(filename,'imdata');
    %break
end
