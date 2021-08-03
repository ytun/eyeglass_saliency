function [ dist_cost ] = dist_cost(salmaps, sigma, gaze_points, true_points, num_of_train )
%DIST_COST Summary of this function goes here
%   Detailed explanation goes here
% 
% max_point_x = fix(1600*rand(100,1));
% max_point_y = fix(900*rand(100,1));
% max_points = [max_point_x, max_point_y];

distances = zeros(size(true_points,1),1); %n by 1 matrix
for i=1:num_of_train,
    true_point = true_points(i,:);
    true_point_x = true_point(1,1);
    true_point_y = true_point(1,2); 
    [max_x, max_y] = getMaxPosition(salmaps{i},sigma,gaze_points(i,:)); 
    %max_point = max_points(i,:);
    %max_x = max_x(1);
    %max_y = max_y(2);
    distances(i,1) = sqrt((max_x-true_point_x).^2 + (max_y-true_point_y).^2);
end
dist_cost = mean(distances);
end

