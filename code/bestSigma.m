function [ bestSigma ] = bestSigma( salmaps, gaze_points, true_points, num_of_train )

%gaze_points is n by 2 matrix
%true_points is n by 2 matrix

% finding the maximum score point
% sigmaIni = 0.2; %initial value of sigma
% numTesting = 100;
% factor = sqrt(sqrt(sqrt(2)));
% range = 0:numTesting-1;
% sigma_range = sigmaIni*factor.^range;
% [h w] = size(salmap);
% sigma_range = fix(h/3):fix(h);
sigma_range = 1:0.5:100;
average = arrayfun(@(sigma) dist_cost(salmaps, sigma, gaze_points, ...
    true_points, num_of_train), sigma_range);
bestSigma = sigma_range(find(average==min(average)));
end

