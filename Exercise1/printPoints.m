function printPoints(Data, clusters)
    scatter(Data(:, 1), Data(:, 2));
    hold on;
    
    scatter(clusters(:, 1), clusters(:, 2), 'red');
end