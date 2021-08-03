function [motionSal]=getMotionSaliency(Background,CurrentFrame, plotOn, maxShift, maxtheta, thres,areathres)

%citation: https://www.pantechsolutions.net/blog/matlab-code-for-background-subtraction/
%Read Background Image
%Background=imArr(:,:,110);%(rgb2gray(imread('background.png')));
%Read Current Frame

%CurrentFrame=rgb2gray(imread('curr.png'));
%CurrentFrame=imArr(:,:,100); %circshift(imresize(rgb2gray(imread('curr.png')),size(Background)),[4 4]);
method='edg';


%[CurrentFrame, predShift] = alignImages((Background), (CurrentFrame), [15 15], method);
[CurrentFrame, predShift, theta] = alignImages(Background, CurrentFrame, maxShift,maxtheta, method);

if plotOn
    figure;
    subplot(1,3,1);imshow(edge(CurrentFrame,'canny'));title('Edge of BackGround');
    subplot(1,3,2);imshow(edge(Background,'canny'));title('Edge of Current Frame');
    subplot(1,3,3);imshow(edge(CurrentFrame,'canny')-edge(Background,'canny'));title('Difference of Background Edge and Current Frame Edge');
end
CurrentFrame=(mat2gray(CurrentFrame));
Background=(mat2gray(Background));

Out=logical(abs(CurrentFrame- Background)>=thres);

if plotOn
    figure;
    %Display Background and Foreground
    subplot(1,4,1);imshow(Background);title('BackGround');
    subplot(1,4,2);imshow(CurrentFrame);title('Current Frame');
    
    %Convert RGB 2 HSV Color conversion
    %[Background_hsv]=round(rgb2hsv(Background));
    %[CurrentFrame_hsv]=round(rgb2hsv(CurrentFrame));
    %Out = abs(CurrentFrame- Background);
    %Out = xor(CurrentFrame, Background);
    
    %Convert RGB 2 GRAY
    %Out=rgb2gray(Out);
    
    subplot(1,4,3);
    imshow(Out);
    title('Binary Image of the Difference of Current Frame and Background Frame');
    
    subplot(1,4,4);
    imagesc(abs(CurrentFrame- Background));
    title('Difference of Current Frame and Background Frame');
    axis square;
    axis off;
    colormap gray;
end
%Read Rows and Columns of the Image
[rows columns]=size(Out);
%Convert to Binary Image
% for i=1:rows
%     for j=1:columns
%         if Out(i,j) >0
%             BinaryImage(i,j)=1;
%         else
%             BinaryImage(i,j)=0;
%         end
%     end
% end


%Apply Median filter to remove Noise
FilteredImage=medfilt2(Out,[5 5]);
%Boundary Label the Filtered Image
[L num]=bwlabel(FilteredImage);
STATS=regionprops(L,'all');
cc=[];
removed=0;
%Remove the noisy regions
for i=1:num
    dd=STATS(i).Area;
    if (dd < areathres)
        L(L==i)=0;
        removed = removed + 1;
        num=num-1;
    else
    end
end
[L2 num2]=bwlabel(L);

%fprintf('Number of segments found: %i',num2);

% Trace region boundaries in a binary image.
[B,L,N,A] = bwboundaries(L2);
%Display results

if plotOn
    figure;
    subplot(2,3,1),  imshow(1-L2);title('BackGround Detected');
    subplot(2,3,2),  imshow(L2);title('Blob Detected');
    hold on;
    for k=1:length(B),
        if(~sum(A(k,:)))
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
            for l=find(A(:,k))'
                boundary = B{l};
                plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
            end
        end
    end
    
end

motionSal=L2;

if num2>0
    motionSal(motionSal>0)=1;
    
    
    %predShift
    
    offset=6;
    if predShift(2)<0
        motionSal(:,end-(abs(predShift(2))+offset):end) =0;
    elseif predShift(2)>0
        motionSal(:,1:predShift(2)+offset) =0;
    end
    
    if predShift(1)<0
        motionSal(end-(abs(predShift(1))+offset):end,:) =0;
    elseif predShift(1)>0
        motionSal(1:predShift(1)+offset,:) =0;
    end
    
    
    if plotOn
        subplot(2,3,3),
        imshow(motionSal);
        title('Motion Saliency after eliminating borders of circshift result');
    end
    %
    se = strel('disk',10);
    motionSal = (imclose(motionSal,se));
    
    if plotOn
        subplot(2,3,4),
        imshow(motionSal);
        title('Motion Saliency after doing "close" morphological operation');
    end
    
    
    Ilabel = bwlabel(motionSal);
    %unique(Ilabel)
    
    stat=regionprops(Ilabel,'all');
    
    
    nSeg=numel(stat);
    SegMat=zeros(nSeg,6);
    
    SegBW=cell(nSeg);
    
    if plotOn
    figure;
    end

    %Remove the noisy regions
    for x=1:nSeg
        
        SegMat(x,:)= [x stat(x).Area stat(x).BoundingBox];
        SegBW{x}=stat(x).Image;
        
        
        if plotOn
            SegLog=zeros(size(Ilabel));
    
    
            SegLog(Ilabel==x)=1;
    
            subplot(3,3,x);
            imshow(SegLog);
        end
    end
    
    if nSeg>0
        SegMat=sortrows(SegMat,2);
        bbox=SegMat(end,3:end);
        
        [h w]=size(Ilabel);
        BW=padarray(SegBW{SegMat(end,1)},[h-bbox(4) w-bbox(3)],'post');
        
        
        
        motionSal=circshift(BW,floor([bbox(2) bbox(1)]));
        
        
        
        if plotOn
            subplot(2,3,5),
            imshow(motionSal);
            title('Motion Saliency- shifted to align with background');
        end
        
        % figure;
        %
        % for i=1:nSeg
        % subplot(2,4,i);
        % imshow(SegBW(:,:,i));
        % title(i);
        % end
        % figure;
        % subplot(1,2,1);
        % imshow(im2(L2==1));
        % subplot(1,2,2);
        % imshow(im2(L2==1));
    end
    
    motionSal = imrotate(motionSal,-theta,'bilinear','crop'); % Try varying the angle, theta.
    
    motionSal=circshift(motionSal,predShift*-1);  %need to be a vector
    
    
    if plotOn
        subplot(2,3,6),
        imshow(motionSal);
        title('Final Motion Saliency- unshifted');

    end
    
end
end

%%
% nSeg=numel(stat);
% SegMat=zeros(nSeg,2);
%
% SegBW=zeros([size(motionSal) nSeg]);
%
%
% figure;
% %Remove the noisy regions
% for x=1:nSeg
%
%     SegMat(x,:)= [x STATS(x).Area];
%
%    SegLog=zeros(size(motionSal));
%     SegLog(Ilabel==x)=1;
%     SegBW(:,:,x)=SegLog;
%     subplot(2,4,x);
%     imshow(SegBW(:,:,x));
%     title(sprintf('%i,%i',x,STATS(x).Area))
%
%
% end
%
% figure;
% SegMat=sortrows(SegMat,2);
%
% motionSal=SegBW(:,:,SegMat(end,1));
%
% if plotOn
%     subplot(2,3,5),
%     imshow(motionSal);
% end
%
% % figure;
% %
% % for i=1:nSeg
% % subplot(2,4,i);
% % imshow(SegBW(:,:,i));
% % title(i);
% % end
% % figure;
% % subplot(1,2,1);
% % imshow(im2(L2==1));
% % subplot(1,2,2);
% % imshow(im2(L2==1));
%
% motionSal = imrotate(motionSal,-theta,'bilinear','crop'); % Try varying the angle, theta.
%
% motionSal=circshift(motionSal,predShift*-1);  %need to be a vector
%
%
% if plotOn
%     subplot(2,3,6),
%     imshow(motionSal);
% end
%
% end

