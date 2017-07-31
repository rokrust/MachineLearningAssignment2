load('A.txt'); 
load('B.txt'); 
load('pi.txt'); 
load('Test.txt');

N = size(B, 2);
[T, N_reps] = size(Test);
gestures = [];

for n = 1:N_reps
    o_t = Test(1, n);
    alpha = pi .* B(o_t, :);
    
    for t = 2:T
        o_t = Test(t, n);
        alpha = alpha * A .* B(o_t, :); 
        
    end
    
    log_alpha = log(sum(alpha));
    gestures = [gestures, (log_alpha <= -120) + 1];
    
end