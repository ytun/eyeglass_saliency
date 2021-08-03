ori_folder = 'img_ori/';

new_folder = 'img_new/';

srcFiles = dir('img_ori/*');  % the folder in which ur images exists
% first three elements are not image
for i = 4 : length(srcFiles)
    filename = strcat(ori_folder,srcFiles(i).name);
    I = imread(filename);
    [row, col, cha] = size(I);
    I = rgb2gray(I);
    if row > col
        diff = round((row-col)/2);
        I = I(diff:diff+row-1,:);
    else
        diff = round((col-row)/2);
        I = I(:,diff:diff+row-1);
    end
    im_gray = imresize(I,[112,112]);
    im(:,:,1)=im_gray;
    im(:,:,2)=im_gray;
    im(:,:,3)=im_gray;
%     figure
%     subplot(1,2,1);
%     imshow(im);
%     [salmap,im_size] = getSaliency(im);
%     subplot(1,2,2);
%     imshow(salmap);
    filename = strcat(new_folder,srcFiles(i).name);
    imwrite(im,filename);
end
