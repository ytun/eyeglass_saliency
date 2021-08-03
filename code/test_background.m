clc;
close all;
clear;

datadir='/Users/ytun/Documents/Dropbox/Vision/Saliency';
data=load(fullfile(datadir,'dvid.mat'));
image=data.Out;
imArr=reshape(image',111, 112,[]);
nImages=size(imArr,3);

figure;
imagesc(imArr(:,:,100));
figure;
imagesc(imArr(:,:,105));


%%
close all

%citation: https://www.pantechsolutions.net/blog/matlab-code-for-background-subtraction/
%Read Background Image
Background=imArr(:,:,110);%(rgb2gray(imread('background.png')));
%Read Current Frame

%CurrentFrame=rgb2gray(imread('curr.png'));
CurrentFrame=imArr(:,:,100); %circshift(imresize(rgb2gray(imread('curr.png')),size(Background)),[4 4]);
method='edg';
[CurrentFrame, predShift] = alignImages((Background), (CurrentFrame), [15 15], method);

figure;
subplot(1,3,1);imshow(edge(CurrentFrame,'canny'));title('BackGround');
subplot(1,3,2);imshow(edge(Background,'canny'));title('Current Frame');
subplot(1,3,3);imshow(edge(CurrentFrame,'canny')+edge(Background,'canny'));
CurrentFrame=(mat2gray(CurrentFrame));
Background=(mat2gray(Background));
figure;
%Display Background and Foreground
subplot(1,3,1);imshow(Background);title('BackGround');
subplot(1,3,2);imshow(CurrentFrame);title('Current Frame');
%Convert RGB 2 HSV Color conversion
%[Background_hsv]=round(rgb2hsv(Background));
%[CurrentFrame_hsv]=round(rgb2hsv(CurrentFrame));
Out=logical(abs(CurrentFrame- Background)>=0.08);
%Out = abs(CurrentFrame- Background);
%Out = xor(CurrentFrame, Background);

%Convert RGB 2 GRAY
%Out=rgb2gray(Out);
subplot(1,3,3);
imshow(Out);
%Read Rows and Columns of the Image
[rows columns]=size(Out);
%Convert to Binary Image
for i=1:rows
    for j=1:columns
        if Out(i,j) >0
            BinaryImage(i,j)=1;
        else
            BinaryImage(i,j)=0;
        end
    end
end
%Apply Median filter to remove Noise
FilteredImage=medfilt2(BinaryImage,[5 5]);
%Boundary Label the Filtered Image
[L num]=bwlabel(FilteredImage);
STATS=regionprops(L,'all');
cc=[];
removed=0;
%Remove the noisy regions
for i=1:num
    dd=STATS(i).Area;
    if (dd < 50)
        L(L==i)=0;
        removed = removed + 1;
        num=num-1;
    else
    end
end
[L2 num2]=bwlabel(L);
% Trace region boundaries in a binary image.
[B,L,N,A] = bwboundaries(L2);
%Display results
figure;
subplot(2,2,1),  imshow(L2);title('BackGround Detected');
subplot(2,2,2),  imshow(L2);title('Blob Detected');
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


se = strel('disk',10);
closeBW = imclose(L2,se);
subplot(2,2,3),
imshow(closeBW);
% figure;
% subplot(1,2,1);
% imshow(im2(L2==1));
% subplot(1,2,2);
% imshow(im2(L2==1));

