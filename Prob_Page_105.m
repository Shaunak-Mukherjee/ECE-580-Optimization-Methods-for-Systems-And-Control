clear
clc
% Define the function f(x)
f = @(x) x.^2 + 4 * cos(x);

% f = @(x) x^4 -14*x^3 +60*x^2 -70*x

% Define the interval [a, b]
a = 1; 
b = 2;

% Define the golden ratio
rho = (3 - sqrt(5)) / 2;

% Define the uncertainty
uncertainty = 0.2;

% Display table header
fprintf('N\t  a\t\t  b\t\t  a_k\t\t  b_k\t\t  f(a_k)\t  f(b_k)\t  |b – a|\t\n');
fprintf('----------------------------------------------------------------------------------------------------------------\n');

% Initialize iteration counter
k = 1;

% Initialize the variables for k=1
a1 = a + rho*(b - a); 
b1 = a + (1-rho)*(b - a); 
f_a1 = f(a1);
f_b1 = f(b1); 


fprintf('%d\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', k, a, b, a1, b1, f_a1, f_b1, abs(b - a))

% Loop until the interval size is within the uncertainty
while abs(b - a) > uncertainty

    k = k + 1;

    if f_a1 < f_b1
        b = b1; 
        b1 = a1;
        f_b1 = f_a1;
        a1 = a + rho*(b-a); 
        f_a1 = f(a1);
    else
        a = a1;
        a1 = b1;
        f_a1 = f_b1;
        b1 = a + (1 - rho)*(b-a);
        f_b1 = f(b1);
    end
    
fprintf('%d\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', k, a, b, a1, b1, f_a1, f_b1, abs(b - a))

end
