%% EEC 201 Final Project | C. Vector Quantization | 2B or not 2B

%-------------------------------------------------------------------------%
% Function Definition: lbg.m
% Apply vector quantization to MFCCs using the LBG algorithm

% Inputs:
% MFCC           - MFCCs extracted from melfb_own.
% max_splits     - Maximum number of Centroid Doubling
% max_iterations - Threshold for max interations
% min_split_gain - Minimum performance increase for centroid doubling

% Outputs:
% C            - Codebook with cluster information

% Dependencies:
% 
%-------------------------------------------------------------------------%

%[MFCC_own, MFCC_MATLAB] = melfb_own("s1.wav", 256, 40, 13);

function [clusters] = lbg(MFCC_own, MFCC_MATLAB, show)

    % Initializations
    MFCC = MFCC_MATLAB;
    %% MFCC = MFCC_own';
    
    epsilon = 0.1;

    clusters = mean(MFCC(:,:));
    cost_prev = disteu(clusters', MFCC');
    mean_cost_prev = mean(cost_prev);
    %sprintf("Initilization mean distance (K = 1) is %d.\n",mean_cost_prev)

    % Check if splitting is possible
    % We should abort if the number of clusters is larger than the number of
    % available data

    for i = (1:3)

        % Increase codebook size
        clusters = [clusters; clusters];

        % Add offsets to clusters
        % Note: Can make unique later.
        og_cluster = clusters;

        for j = (1:i)
            if mod(j,2) == 1
                clusters(j,:) = clusters(j,:) + epsilon;
            else
                clusters(j,:) = clusters(j,:) - epsilon;
            end
        end

        % Codebook correction
        num_clusters = length(clusters(:,1));
        %sprintf("Optimize for K = %d.\n", num_clusters) %counts rows

        % K-means algorithm
        [idx, clusters, cost, D] = kmeans(MFCC, num_clusters, 'Start', clusters);
        cost_current = disteu(clusters', MFCC');
        mean_cost_current = mean(min(cost_current));
        
        
        %sprintf("Current mean distance (K = %d) is %d.\n",num_clusters, mean_cost_current)

        % Determine Convergence to terminate LBG algorithm
        threshold = abs(mean_cost_current - mean_cost_prev);
        if (threshold) < .3
            sprintf("Terminate LBG algorithm: minimum gain threshold satisfied")
            size(clusters)
            break
        else
            cost_prev = cost_current;
            mean_cost_prev = mean_cost_current;
        end
    end

    if show == true
        figure
        gscatter(MFCC(:,1),MFCC(:,2),idx,'bgmr')
        hold on
        plot(clusters(:,1),clusters(:,2),'kx')
        legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster Centroid')
    end
    
end