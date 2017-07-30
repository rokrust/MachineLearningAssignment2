load('dataGMM.mat');
k = 4;
[dim, n] = size(Data);
Data = Data';


[mu, sigma, pi] = initGmm(Data, k);
gamma = zeros(n, k);
prev_likelihood = 0; 
threshold = 0.01;
logLikelihood = threshold+0.00000000001;

iter = 0;
while logLikelihood - prev_likelihood > threshold
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
    mu = (gamma' * Data) ./ repmat(n_k', 1, 2);

    for i = 1:k
        zeroMeanData = Data - repmat(mu(i, :), n, 1);
        sigma(:, :, i) = repmat(gamma(:, i), 1, dim)' .* zeroMeanData' * zeroMeanData / n_k(i);
    end

    pi = n_k / n;
    
    clf();
    hold on;
    scatter(Data(:, 1), Data(:, 2));
    scatter(mu(:, 1), mu(:, 2));

end

%printPoints(Data, mu);
