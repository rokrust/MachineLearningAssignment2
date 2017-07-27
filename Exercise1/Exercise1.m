load('dataGMM.mat');
k = 4;
n = size(Data, 2);
DataT = Data';


[~, mu] = kmeans(DataT, k);
clusterData = cell(1, k);

for i = 1:size(Data, 2)
    smallest_distance = 100000;
    index = 0;
    
    for j = 1:k
        d = dist(mu(j, :), DataT(i, :));

        if smallest_distance > d
            smallest_distance = d;
            index = j;
        end

    end
    clusterData{index} = [clusterData{index}; DataT(i, :)];
end

scatter(DataT(:, 1), DataT(:, 2));
hold on;
scatter(mu(:, 1), mu(:, 2), 'red');


sigma = cell(1, k);
p = zeros(1, k);
gmm = zeros(1, k);
x1 = -3:1e-1:3;
x = [x1' x1'];

for i = 1:k
    p(i) = size(clusterData{index}, 1) / n;
    sigma{i} = cov(clusterData{i});
    
    l = mvnpdf(x, mu(i, :), sigma{i});%, mu(i, :), sigma{i});
    plot(x, l)
end
