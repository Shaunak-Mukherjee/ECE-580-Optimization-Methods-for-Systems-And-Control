% Steepest Descent Algorithm Implementation Example
clear 
clc

syms x1 x2 
% Define the function
f_def = (x2 - x1).^4 + 12*x1.*x2 - x1 + x2 + 3;
f = matlabFunction(f_def);

% compute gradient of function
grad_def = gradient(f_def);
grad = matlabFunction(grad_def);
display(grad_def)

% Define the range of x and y
x1_range = linspace(-1, 1, 100);
x2_range = linspace(-1, 1, 100);

% Create a grid of x and y values
[x1_grid, x2_grid] = meshgrid(x1_range, x2_range);

% Compute the function values on the grid
f_values = f(x1_grid, x2_grid);

% x1 = -0.9;
% x2 = -0.5;

x1 = 0.55;
x2 = 0.7;

x_iter = [x1,x2]; % Initial guess

% Define  objective function that needs to be minimized to get next x
phi = @(alpha, x_iter) f((x_iter(1) - alpha*(12*x_iter(2) + 4*(x_iter(1) - x_iter(2)).^3 - 1)), (x_iter(2) - alpha*(12*x_iter(1) - 4*(x_iter(1) - x_iter(2)).^3 + 1)));

% Define the interval [a, b]
a = 0; 
b = 5;

% Define the golden ratio
rho = (3 - sqrt(5)) / 2;

% Define the uncertainty
uncertainty = 1e-4;


% Initialize iteration counter
k_iter = 1; 
tol = 1e-4;
figure;

%%%%%%%%%%%%%%%%%%%%%   SDG Loop    %%%%%%%%%%%%%%%%%%%%%

while norm(grad(x_iter(1),x_iter(2))) > tol

    
    % Golden search loop
    % Initialize the variables for k=1
    a = 0; 
    b = 5;

    a1 = a + rho*(b - a); 
    b1 = a + (1-rho)*(b - a); 
    phi_a1 = phi(a1,x_iter);
    phi_b1 = phi(b1,x_iter); 
    k = 1;
    
          
    % Loop until the interval size is within the uncertainty
    while norm(b - a) > uncertainty
    
        k = k + 1;
    
        if phi_a1 < phi_b1
            b = b1; 
            b1 = a1;
            phi_b1 = phi_a1;
            a1 = a + rho*(b-a); 
            phi_a1 = phi(a1,x_iter);
        else
            a = a1;
            a1 = b1;
            phi_a1 = phi_b1;
            b1 = a + (1 - rho)*(b-a);
            phi_b1 = phi(b1,x_iter);
        end
        
    
    end
    % Output results
    alpha = (a1+b1)/2;
    % display(alpha)
    phi_val = phi(alpha,x_iter);
    % display(phi_val)
    fprintf('Iteration %d: alpha = %.5f, phi_val = %.5f, x_iter = [%.5f,%.5f] \n', k_iter, alpha, phi_val, x_iter(1), x_iter(2))
    
    % new x
    x_new = [(x_iter(1) - alpha*(12*x_iter(2) + 4*(x_iter(1) - x_iter(2)).^3 - 1)), (x_iter(2) - alpha*(12*x_iter(1) - 4*(x_iter(1) - x_iter(2)).^3 + 1))];

    %%%%%%%%%%%%%%%%%%%%%   end of SDG Loop    %%%%%%%%%%%%%%%%%%%%%

    % Generate contours with levels
    contour(x1_grid, x2_grid, f_values,'LevelStep',1 , 'LineWidth', 0.5, 'ShowText','on', 'LabelFormat','%0.1f');
    % contour(x1_grid, x2_grid, f_values,'ShowText','on')
    xlabel('x1');
    ylabel('x2');
    title('Contour plot of function');
    grid on
    % legend('Contour plot', 'Location', 'NorthEast');
    hold on;

    % Plot initial point
    plot(x_iter(1), x_iter(2), 'ro'); hold on;
    if k_iter == 1
        text(x_iter(1), x_iter(2),'Start')
    
    end
    D = x_new - x_iter;
    quiver( x_iter(1), x_iter(2), D(1), D(2), 0 , '--k');hold on;




    % reassign for next loop 

    x_iter = [x_new(1),x_new(2)];
    k_iter = k_iter+1;

    %%%
    


end


text(x_iter(1), x_iter(2),'End')




