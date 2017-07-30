load('dataGMM.mat');
k = 4;
[dim, n] = size(Data);
Data = Data';


[mu, sigma, pi] = initGmm(Data, k);
gamma = zeros(n, k);
prev_likelihood = 0; 
threshold = 0.0001;
logLikelihood = threshold+0.00000000001;

iter = 0;
while logLikelihood - prev_likelihood > threshold
    iter = iter + 1;
    prev_likelihood = logLikelihood;
    logLikelihood = 0;
    
    for i = 1:n
    
        x_i = Data(i, :);
    
        x_i = repmat(x_i, k, 1);        
        pdf = mvnpdf(x_i, mu, sigma);
        pdfsum = pi*pdf;
        
        %Stopping condition
        logLikelihood = logLikelihood + log(pdfsum);
    
        gamma(i, :) = (pi' .* pdf) / pdfsum;
     
    end
    
    n_k = sum(gamma);

    for i = 1:k
        mu(i, :) = gamma(:, i)' * Data / n_k(i);
        zeroMeanData = Data - repmat(mu(i, :), n, 1);
        
        cov_sum = zeros(dim, dim);
        for j = 1:n
            blurg = zeroMeanData(j, :)' * zeroMeanData(j, :);
            cov_sum = cov_sum + gamma(j, i) * (zeroMeanData(j, :)' * zeroMeanData(j, :));
            %sigma(:, :, i) = (repmat(gamma(:, i), 1, dim) .* zeroMeanData)' * zeroMeanData;
        end
        
        sigma(:, :, i) = cov_sum / n_k(i);
    end

    pi = n_k / n;
    
    clf();
    hold on;
    scatter(Data(:, 1), Data(:, 2));
    scatter(mu(:, 1), mu(:, 2));

end

%printPoints(Data, mu);
