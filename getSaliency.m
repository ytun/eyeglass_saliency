function [ salmap_combo,im_size ] = getSaliency(rgb_im,plotOn)

%im_gray = imread(img_path);
[h w d] = size(rgb_im);
%im=rgb_im;

scale= 5;

salmap_combo=zeros(h,w);

initsize=[h w];

if plotOn
    figure;
    
end
for i=1:scale
    
    im = imresize(rgb_im,initsize*2^(i-1));
    
    for j=1:3
        im(:,:,j)=im(:,:,1);
    end
    
    
    
    %im(:,:,1)=im_gray;
    %im(:,:,2)=im_gray;
    %im(:,:,3)=im_gray;*2
    
    %im = (im2double(medfilt2(im))).^.5;
    imwrite(im,'tmp_image.jpg');
    img_path = 'tmp_image.jpg';
    
    %(im2double(medfilt2(im))).^.5
    im_size=size(rgb_im,1);
    img = initializeImage(img_path);
    params = defaultSaliencyParams;
    salmap = makeSaliencyMap(img,params);
    salmap = imresize(salmap.data,[h w]);
    
    if plotOn
        
%         subplot(2,4,i);
%         imagesc(salmap);
%         colormap gray
%         axis off;
%         axis square;
%         
        subplot(2,4,i)
        C = imfuse(zeros(size(salmap)),salmap,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
        C1=imfuse(1.5*rgb_im,C,'blend','Scaling','joint');
        imshow(C1);
        
    end
    
%     if i==3 || i==4
%         wt=3;
%     else
%         wt=1;
%     end
    wt= i;
    salmap_combo=(salmap_combo+wt*salmap);
end

salmap_combo=mat2gray(salmap_combo);

%%

% function [ salmap_combo,im_size ] = getSaliency(rgb_im,plotOn)
% 
% %im_gray = imread(img_path);
% [h w d] = size(rgb_im);
% %im=rgb_im;
% 
% scale= 4;
% 
% salmap_combo=zeros(h,w);
% 
% initsize=2*[h w];
% 
% if plotOn
%     figure;
%     
% end
% for i=1:scale
%     
%     im = imresize(rgb_im,initsize*sqrt(2)^i);
%     
%     for j=1:3
%         im(:,:,j)=im(:,:,1);
%     end
%     
%     
%     
%     %im(:,:,1)=im_gray;
%     %im(:,:,2)=im_gray;
%     %im(:,:,3)=im_gray;*2
%     
%     %im = (im2double(medfilt2(im))).^.5;
%     imwrite(im,'tmp_image.jpg');
%     img_path = 'tmp_image.jpg';
%     
%     %(im2double(medfilt2(im))).^.5
%     im_size=size(rgb_im,1);
%     img = initializeImage(img_path);
%     params = defaultSaliencyParams;
%     salmap = makeSaliencyMap(img,params);
%     salmap = imresize(salmap.data,[h w]);
%     
%     if plotOn
%         
% %         subplot(2,4,i);
% %         imagesc(salmap);
% %         colormap gray
% %         axis off;
% %         axis square;
% %         
%         subplot(2,4,i)
%         C = imfuse(zeros(size(salmap)),salmap,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
%         C1=imfuse(1.5*rgb_im,C,'blend','Scaling','joint');
%         imshow(C1);
%         
%     end
%     
%     if i==3 || i==4
%         wt=3;
%     else
%         wt=1;
%     end
%     salmap_combo=mat2gray(salmap_combo+wt*salmap);
% end
% 

