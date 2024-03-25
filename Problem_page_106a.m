% Define the function
f = @(x) 8*exp(1-x) + 7*log(x);

% Define the range of x values
x = linspace(1, 2, 1000);

% Calculate the corresponding y values
y = f(x);

% Plot the function
plot(x, y)
xlabel('x')
ylabel('f(x)')
title('Plot of f(x) over [1, 2]')

% Verify unimodality
% Find the minimum value of f(x) within the interval [1, 2]
[min_y, min_index] = min(y);
min_x = x(min_index);
disp(['Minimum value of f(x) is ', num2str(min_y), ' at x = ', num2str(min_x)])

% Check if the function is unimodal over the interval [1, 2]
if min_index == 1 || min_index == length(x)
    disp('Function is not unimodal over the interval [1, 2]')
else
    disp('Function is unimodal over the interval [1, 2]')
end
