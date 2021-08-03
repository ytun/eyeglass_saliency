function [im2Shift, predShift, thetafit] = alignImages(im1, im2, maxShift,maxtheta, method)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first)
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 1: Color images
%   Author: Subhransu Maji
%   Edited: Yamin Tun

%Please choose alignment method:
% 'edg'= Edge detection
%'cro'= Normalized cross-correlation
%'dot'=Finding max dot product
%method='dot';

% Sanity check
% assert(size(im1,3) == 3);
% assert(size(im2,3) == 3);

assert(all(maxShift > 0));

% Dummy implementation (replace this with your own)
%predShift = zeros(2, 2);
%imShift = im;

%Extract color channels
R=im1;  %Red Channel
G=im2; %Green Channel

[height,width]=size(R);
ycrop=round(height*(1/10));
xcrop=round(width*(1/10));

%Crop 1/10 of image size in both direction to eliminate border
% Rcrop=R( ycrop+1 : (height-ycrop) , xcrop+1 :(width-xcrop) );
% Gcrop=G( ycrop+1 : (height-ycrop) , xcrop+1 :(width-xcrop) );
Rcrop=R;
Gcrop=G;

% 1. Using Edge Detection for Alignment
if method=='edg'
    
    R_edg = edge(Rcrop,'canny');
    G_edg = edge(Gcrop,'canny');
    
    %if the two color edges are correctly aligned,
    %sum(abs(R-G)) and sum(abs(R-B)) has to be close to zero. (minimum)
    
    minSumG=2147483647;
    
    
    for i=-maxShift(1):2:maxShift(2)
        for j=-maxShift(1):2:maxShift(2)
            
            for theta=-maxtheta:1:maxtheta
                
                   % fprintf('i=%i,j=%i, theta=%i\n',i,j,theta);
                %for scale=0.5:0.1:1.5
                    %size(Gshift_edgOri)
                    Gshift_edg=imrotate(G_edg,theta,'bilinear','crop');
                    %size(Gshift_edg)
% 
%                     if abs(theta)>0
%                     [h w]= size(G_edg);
%                     [hd wd]=size(Gshift_edg);
%                     wstart=round(wd/2)-floor(w/2);
%                     hstart=round(hd/2)-floor(h/2);
%                     Gshift_edg=Gshift_edg(hstart:hstart+(h-1), wstart:wstart+(w-1));
%                     end
%                     
                    Gshift_edg=circshift(Gshift_edg,[i j]);  %need to be a vector

                    %isequal(size(Gshift_edgOri),size(Gshift_edg))

                    %Gshift_edg = imresize(Gshift_edg,scale);
                    
                    diffG=abs(R_edg-Gshift_edg);
                    
                    sumG=sum(diffG(:));
                    
                    if sumG<minSumG
                        minSumG=sumG;
                        ig=i;
                        jg=j;
                        thetafit=theta;
                    end
                    
                %end
            end
        end
    end
    
    % 2. Using Dot Product for Alignment
elseif method=='dot'
    maxDotG=0;
    
    for i=-maxShift(1):maxShift(2)
        for j=-maxShift(1):maxShift(2)
            
            Gshift=circshift(Gcrop,[i j]);  %need to be a vector
            
            dotG=dot(double(Rcrop(:)),double(Gshift(:)));
            
            if dotG>maxDotG
                maxDotG=dotG;
                ig=i;
                jg=j;
            end
            
        end
    end
    
elseif method=='cro'
    
    maxDotG=0;
    
    Rnorm=(1/norm(Rcrop(:)))*Rcrop(:);
    
    
    for i=-maxShift(1):maxShift(2)
        for j=-maxShift(1):maxShift(2)
            
            Gshift=circshift(Gcrop,[i j]);  %need to be a vector
            
            dotG=dot(Rnorm,(1/norm(Gshift(:)))*Gshift(:));
            
            
            if dotG>maxDotG
                maxDotG=dotG;
                ig=i;
                jg=j;
            end
            
            
        end
    end
end

predShift = [ig jg];

G=imrotate(G,thetafit,'bilinear','crop');

Gshift=circshift(G,[ig jg]);  %need to be a vector

%Handling boundaries- doesn't not work
% if ig>0
%     Gshift(1:ig,1:size(Gshift,2))=0;
%     R(1:ig,1:size(R,2))=0;
%         Bshift(1:ig,1:size(Bshift,2))=0;
%
% else
%     Gshift((size(Gshift,1)-jg):size(Gshift,1), 1:size(Gshift,2))=0;
%         R((size(R,1)-jg):size(R,1), 1:size(R,2))=0;
%     Bshift((size(Bshift,1)-jg):size(Bshift,1), 1:size(Bshift,2))=0;
%
% end

% if jg>0
%     Gshift(1:size(Gshift,1), (size(Gshift,2)-jg):size(Gshift,2))=0;
%         R(1:size(R,1), (size(R,2)-jg):size(R,2))=0;
%         Bshift(1:size(Bshift,1), (size(Bshift,2)-jg):size(Bshift,2))=0;
%
% else
%     Gshift(1:size(Gshift,1),1:jg)=0;
%        R(1:size(R,1),1:jg)=0;
%     Bshift(1:size(Bshift,1),1:jg)=0;
%
% end
%
% if ib>0
%     Bshift(1:ib,1:size(Bshift,2))=0;
%         Gshift(1:ib,1:size(Gshift,2))=0;
%     R(1:ib,1:size(R,2))=0;
%
% else
%    Bshift((size(Bshift,1)-jb):size(Bshift,1), 1:size(Bshift,2))=0;
%       R((size(R,1)-jb):size(R,1), 1:size(R,2))=0;
%    Gshift((size(Gshift,1)-jb):size(Gshift,1), 1:size(Gshift,2))=0;
%
% end
%
% if jb>0
%     Bshift(1:size(Bshift,1), (size(Bshift,2)-jb):size(Bshift,2))=0;
%         R(1:size(R,1), (size(R,2)-jb):size(R,2))=0;
%     Gshift(1:size(Gshift,1), (size(Gshift,2)-jb):size(Gshift,2))=0;
%
%
% else
%     Bshift(1:size(Bshift,1),1:jb)=0;
%         R(1:size(R,1),1:jb)=0;
%     Gshift(1:size(Gshift,1),1:jb)=0;
%
%
% end

im2Shift=Gshift;


