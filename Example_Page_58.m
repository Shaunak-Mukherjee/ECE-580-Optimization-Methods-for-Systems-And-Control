% % Define the function f(x)
f = @(x1, x2) 100*(x2 - x1.^2).^2 + (1 - x1).^2;

% Define the range for x1 and x2 & create meshgrid
x1_range = linspace(-2, 2, 100);
x2_range = linspace(-1, 3, 100);
[x1, x2] = meshgrid(x1_range, x2_range);

% Define Z as function of f each combination of x1 and x2
z = f(x1, x2);

% Plot the 3D surface
figure;
mesh(x1, x2, z);
xlabel('x_1');
ylabel('x_2');
zlabel('f(x)');
title('3D Plot of Rosenbrock banana function f(x)');

% Add levels 
hold on;
contour3(x1, x2, z, [0.7, 7, 70, 200, 700], 'k', 'LineWidth', 1);
hold off;
legend('f(x)', 'Level Sets: 0.7, 7, 70, 200, 700', 'Location', 'NorthEast');
colorbar


% Define the range for x1 and x2
x1_range = linspace(-2, 2, 100);
x2_range = linspace(-1, 3, 100);
%  Define Z as function of f each combination of x1 and x2
z = f(x1, x2);

% Generate contours with levels
figure;
contour(x1, x2, z, [0.7, 7, 70, 200, 700], 'LineWidth', 2);
xlabel('x_1');
ylabel('x_2');
title('Contours of the Function f(x)');
legend('Level Sets: 0.7, 7, 70, 200, 700', 'Location', 'NorthEast');
colorbar