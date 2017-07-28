load('dataGMM.mat');
k = 4;
n = size(Data, 2);
DataT = Data';


[~, mu] = kmeans(DataT, k);
clusterData = cell(1, k);

for i = 1:size(Data, 2)
    smallest_distance = 100000;
    index = 0;
    
    x = DataT(i, :);
    for j = 1:k
        m = mu(j, :);
        d = pdist2(m, x);

        if smallest_distance > d
            smallest_distance = d;
            index = j;
        end

    end
    clusterData{index} = [clusterData{index}; x];
end

scatter3(DataT(:, 1), DataT(:, 2), zeros(1, n));
hold on;
scatter3(mu(:, 1), mu(:, 2), zeros(1, k), 'red');


sigma = cell(1, k);
p = zeros(1, k);
gmm = zeros(1, k);

for i = 1:k
    p(i) = size(clusterData{index}, 1) / n;
    sigma{i} = cov(clusterData{i});
    
    l = mvnpdf(clusterData{i}, mu(i, :), sigma{i});
    plot(clusterData{i}, l);
end
