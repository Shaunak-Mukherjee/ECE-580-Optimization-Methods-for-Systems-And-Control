% An Introduction to Optimization with Applications to Machine Learning,
% E.Chong, W.S.Lu, S.H. Zak, 5e
% Solution to Page 107 Question 7.12 b)

% Define the function 
f = @ (x) 0.5 * x' * [2, 1; 1, 2] * x; % Quadratic form

% Define the interval [a, b] 
a = [0.1062; -0.1250]; % bracket- from problem 7.12 a)
b = [-0.1188;  -0.1835]; % bracket+ from problem 7.12 a)

% Define the golden ratio
rho = (3 - sqrt(5)) / 2;

% Define the uncertainty
uncertainty = 0.01;

% Display table header
fprintf('k\t\t  a\t\t\t  b\t\t\t  a_k\t\t\t  b_k\t\t  f(a_k)\t  f(b_k)\t  |b – a|\t\n');
dashes = repmat('-', 1, 150); % Create a string of dashes
disp(dashes); % Display the string of dashes

% Initialize iteration counter
k = 1;

% Initialize the variables for k=1
a1 = a + rho*(b - a); 
b1 = a + (1-rho)*(b - a); 
f_a1 = f(a1);
f_b1 = f(b1); 


% Output result for k=1
fprintf('%d\t[%.6f, %.6f]\t[%.6f, %.6f]\t[%.6f, %.6f]\t[%.6f, %.6f]\t%.6f\t%.6f\t%.6f\n', k, a(1), a(2), b(1), b(2), a1(1), a1(2), b1(1), b1(2), f_a1, f_b1, norm(b - a));


% Loop until the interval size is within the uncertainty
while norm(b - a) > uncertainty

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
    
% Output results
fprintf('%d\t[%.6f, %.6f]\t[%.6f, %.6f]\t[%.6f, %.6f]\t[%.6f, %.6f]\t%.6f\t%.6f\t%.6f\n', k, a(1), a(2), b(1), b(2), a1(1), a1(2), b1(1), b1(2), f_a1, f_b1, norm(b - a));

end
% Output results
x_min = (a1+b1)/2;
f_min = f(x_min);
disp(['The approx minimum point is: (', num2str(x_min(1)), ', ', num2str(x_min(2)), ')']);
disp(['The approx minimum function value is: ',num2str(f_min)])

