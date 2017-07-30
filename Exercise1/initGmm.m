function [mu, sigma, pi] = initGmm(Data, k)
    [n, dim] = size(Data);
    
    sigma = zeros(dim, dim, k);
    pi = zeros(1, k);

    [~, mu] = kmeans(Data, k);
    
    clusterData = cell(1, k);
    
    %Split data by closest cluster
    for i = 1:n
        smallest_distance = 100000;
        index = 0;
    
        x_i = Data(i, :);
        for j = 1:k
            mu_j = mu(j, :);
            d = pdist2(mu_j, x_i);

            if smallest_distance > d
                smallest_distance = d;
                index = j;
            end

        end
        
        clusterData{index} = [clusterData{index}; x_i];
    end

    %estimate parameters
    for i = 1:k
        n_c = size(clusterData{i}, 1);
        pi(i) = n_c / n;
        sigma(:, :, i) = cov(clusterData{i});
    end

end