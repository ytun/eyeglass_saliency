close all;
clear


datadir='/Users/ytun/Google Drive/CS670Project/Matlab_code/bak_dec_1';
addpath(datadir)

filename='dvid.mat';
data=load(fullfile(datadir,filename));
image=data.Out;
gazeMat=data.gaze_est;


imArr=reshape(image',111, 112,[]);
nImages=size(imArr,3);

%%
% shuttleVideo = VideoReader('shuttle.avi');
% 
% outputVideo = VideoWriter(fullfile(datadir,strcat(filename,'rotate2_59-110_Video.avi')));
% outputVideo.FrameRate = shuttleVideo.FrameRate;
% open(outputVideo)
% 
% nImages=size(imArr,3);

%%
plotOn1=0;
bestSigma = 30; %* (1:6);

Background=mat2gray(imArr(:,:,110));
%index=100;
plotOn=1;

gaze_sal=zeros(nImages,2);

maxShift=[10 10];
maxtheta=8;
thres=0.1;
areathres=10;

%59, 94, 100, 110
for index=69
    
    index
    
    CurrentFrame=mat2gray(imArr(:,:,index));
    gaze_est=gazeMat(index,:);
    [motionSal]=getMotionSaliency(Background,CurrentFrame, plotOn,maxShift,maxtheta,thres,areathres);
%       [motionSal, CurrentFrame]=getMotionSaliency(Background,CurrentFrame, plotOn);
 
    
    finalSal=motionSal;
    
    
%     
%     
%         [intenSal,im_size] = getSaliency(CurrentFrame,plotOn);
% 
%         finalSal=mat2gray(0.8*motionSal+0.5*intenSal);
% 
%     [max_x, max_y] = getMaxPosition(finalSal,bestSigma,round(gaze_est));
    %gaze_sal(index,:)=[max_x, max_y];
    
    %h = figure('visible', 'off');
    %a = axes('parent', h);
    
    subplot(1,2,1)
    imagesc(CurrentFrame);
    axis square
    axis off
    colormap gray;
    
    
    subplot(1,2,2)
    
    C = imfuse(zeros(size(finalSal)),finalSal,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
    % for i=1:3
    %    C11=C(:,:,i);
    %    C11(finalSal<0.1)=30;
    %     C(:,:,i)=C11;
    % end
    
    C1=imfuse(CurrentFrame,C,'blend','Scaling','joint');
    C_green=1.7*C1(:,:,2);
    C_green(finalSal<0.1)=255*CurrentFrame(finalSal<0.1);
    
    C1(:,:,1)=255*CurrentFrame;
    C1(:,:,2)=C_green;
    C1(:,:,3)=255*CurrentFrame;
    
    
    imshow(C1);
    hold on;
    %scatter(max_x, max_y,'xr');
    %scatter(gaze_est(1),gaze_est(2),'oy');
    
    hold off;
    %legend('new_gaze','neural_gaze');
    
%     
%     
%     title(sprintf('%i',index));
%     
%     img = frame2im(getframe(h));
%     
%     writeVideo(outputVideo,img);
%     
%     fprintf('%i\n',index);
%     
%     
%     
%     
end

%close(outputVideo)


%59-110





%%


%% Testing with plots
% plotOn1=0;
% bestSigma = 30; %* (1:6);
% 
% Background=mat2gray(imArr(:,:,110));
% %index=100;
% plotOn=0;
% 
% gaze_sal=zeros(nImages,2);
% 
% maxShift=[10 10];
% maxtheta=8;
% thres=0.1;
% 
% figure;
% 
% for index=59:110
%     
%     CurrentFrame=mat2gray(imArr(:,:,index));
%     gaze_est=gazeMat(index,:);
%     [motionSal]=getMotionSaliency(Background,CurrentFrame, plotOn,maxShift,maxtheta,thres);
% %       [motionSal, CurrentFrame]=getMotionSaliency(Background,CurrentFrame, plotOn);
%  
%     
%     %CurrentFrame=mat2gray(imArr(:,:,100)); %(imread('/Users/ytun/Google Drive/CS670Project/Matlab_code/bak_dec_1/img_new/il_340x270.610964969_t8jr.jpg'));
%     
%     %weigh motion more than intensity
%     
%     
%     
%     
%     C = imfuse(zeros(size(motionSal)),motionSal,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
%     % for i=1:3
%     %    C11=C(:,:,i);
%     %    C11(finalSal<0.1)=30;
%     %     C(:,:,i)=C11;
%     % end
%     
%     C1=imfuse(CurrentFrame,C,'blend','Scaling','joint');
%     C_green=1.7*C1(:,:,2);
%     C_green(motionSal<0.1)=255*CurrentFrame(motionSal<0.1);
%     
%     C1(:,:,1)=255*CurrentFrame;
%     C1(:,:,2)=C_green;
%     C1(:,:,3)=255*CurrentFrame;
%     
%     
%     subplot(5,5,index-58)
%     imshow(C1);
%     hold on;
%     %scatter(max_x, max_y,'xr');
%     scatter(gaze_est(1),gaze_est(2),'oy');
%     
%     hold off;
%     
%     
%     
%     
% end
