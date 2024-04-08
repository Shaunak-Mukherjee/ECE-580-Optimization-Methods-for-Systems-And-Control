% Fibonacci Search Method
% Clear out text/screen 
clear
clc 

% Define the function f(x)
f = @(x) x.^2 + 4 * cos(x);
 
% Define the interval [a, b] & Fibonacci function as fib
a = 1; 
b = 2;
fib = @(n)fib_series(n+1);


% Define the uncertainty
uncertainty = 0.2;

% Other parameters
epsilon = 0.05;
n = 4;

 

% Display table header of list of parameters to list
fprintf('k\t  rho_k\t\t  a\t\t  b\t\t  a_k\t\t  b_k\t\t  f(a_k)\t  f(b_k)\t  |b – a|\t\n');
dashes = repmat('-', 1, 130); % Create a string of dashes
disp(dashes); % Display the string of dashes


% Initialization of parameters
k = 1;
rho = 1 - fib(n-k+1)/fib(n-k+2);
a1 = a + rho*(b - a); 
b1 = a + (1-rho)*(b - a); 
f_a1 = f(a1);
f_b1 = f(b1); 


fprintf('%d\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', k, rho, a, b, a1, b1, f_a1, f_b1, abs(b - a))

% Defining loop
while abs(b - a) > uncertainty 
 
    
    if f_a1 < f_b1
        b = b1; 
        b1 = a1;
        f_b1 = f_a1;

        k = k + 1;
        rho = 1 - fib(n-k+1)/fib(n-k+2);
        % Defining reduction limit
        if rho == 0.5
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

if abs(b - a) > uncertainty 
    fprintf('%d\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', k, rho, a, b, a1, b1, f_a1, f_b1, abs(b - a))
end

end

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
