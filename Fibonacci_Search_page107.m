% An Introduction to Optimization with Applications to Machine Learning,
% E.Chong, W.S.Lu, S.H. Zak, 5e
% Solution to Page 107 Question 7.12 c)

% Fibonacci Search Method
% Clear out text/screen 
clear
clc 

% Define the function 
f = @ (x) 0.5 * x' * [2, 1; 1, 2] * x; % Quadratic form

% Define the interval [a, b] and Fibonnaci function as fib
a = [0.1062; -0.1250]; % bracket- from problem 7.12 a)
b = [-0.1188;  -0.1835]; % bracket+ from problem 7.12 a)
fib = @(n)fib_series(n+1);
 
% Define the uncertainty
uncertainty = 0.01;

% Other parameters and Max Iterations
epsilon = 0.075;
n = 100;
 
% Display table header
fprintf('k\t  rho_k\t\t\t  a\t\t\t  b\t\t\t  a_k\t\t\t  b_k\t\t  f(a_k)\t  f(b_k)\t  |b – a|\t\n');
dashes = repmat('-', 1, 160); % Create a string of dashes
disp(dashes); % Display the string of dashes

% Initialization of parameters
k = 1;
rho = 1 - fib(n-k+1)/fib(n-k+2);
a1 = a + rho*(b - a); 
b1 = a + (1-rho)*(b - a); 
f_a1 = f(a1);
f_b1 = f(b1); 

% Output result for k=1
fprintf('%d\t%.6f\t[%.6f, %.6f]\t[%.6f, %.6f]\t[%.6f, %.6f]\t[%.6f, %.6f]\t%.6f\t%.6f\t%.6f\n', k, rho, a(1), a(2), b(1), b(2), a1(1), a1(2), b1(1), b1(2), f_a1, f_b1, norm(b - a));

% Defining loop
while norm(b - a) > uncertainty 
 
    
    if f_a1 < f_b1
        b = b1; 
        b1 = a1;
        f_b1 = f_a1;

        k = k + 1;
        rho = 1 - fib(n-k+1)/fib(n-k+2);
        % Defining reduction limit
        if rho  == 0.5
            rho = rho - epsilon; 
        end    
       a1 = a + rho*(b-a); 
        f_a1 = f(a1);
    else
        a = a1;
        a1 = b1;
        f_a1 = f_b1;

        k = k + 1;
        rho = 1 - fib(n-k+1)/fib(n-k+2);
        % Defining reduction limit
        if rho == 0.5
            rho = rho - epsilon;
        end
        b1 = a + (1 - rho)*(b-a);
        f_b1 = f(b1);


    end 
    
    
if norm(b - a) > uncertainty 
    
    fprintf('%d\t%.6f\t[%.6f, %.6f]\t[%.6f, %.6f]\t[%.6f, %.6f]\t[%.6f, %.6f]\t%.6f\t%.6f\t%.6f\n', k, rho, a(1), a(2), b(1), b(2), a1(1), a1(2), b1(1), b1(2), f_a1, f_b1, norm(b - a));


end

end
x_min = (a1+b1)/2;
f_min = f(x_min);
disp(['The approx minimum point is: (', num2str(x_min(1)), ', ', num2str(x_min(2)), ')']);
disp(['The approx minimum function value is: ',num2str(f_min)])


% Define Fibonnaci Function
function fib = fib_series(n)

    if n <= 1
        fib = n;
    else
        fib = zeros(1, n+1);
        fib(1) = 0;
        fib(2) = 1;
        for i = 3:n+1
            fib(i) = fib(i-1) + fib(i-2);
        end
        fib = fib(n+1);
    end
end