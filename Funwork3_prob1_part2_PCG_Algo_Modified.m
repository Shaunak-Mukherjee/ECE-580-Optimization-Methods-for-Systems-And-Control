% Powell Conjugate Gradient Method 
clear 
clc

syms x1 x2 
% Define the function
f_def = (x2 - x1).^4 + 12*x1.*x2 - x1 + x2 + 3;
f = matlabFunction(f_def);

% compute gradient of function
grad_def = gradient(f_def);
grad = matlabFunction(grad_def);

% Define  objective function alpha. Note here alpha is from Conjugate
% Gradient Algorithm which is dependent on direction vector 

phi = @(alpha, beta, d_iter, x_iter) f((x_iter(1) - alpha*(12*x_iter(2) + 4*(x_iter(1) - x_iter(2)).^3 - 1) + alpha*beta*d_iter(1)), ...
                                      (x_iter(2) - alpha*(12*x_iter(1) - 4*(x_iter(1) - x_iter(2)).^3 + 1) + alpha*beta*d_iter(2)));

% Define the range of x and y
x1_range = linspace(-1, 1, 100);
x2_range = linspace(-1, 1, 100);

% Create a grid of x and y values
[x1_grid, x2_grid] = meshgrid(x1_range, x2_range);

% Compute the function values on the grid
f_values = f(x1_grid, x2_grid);
figure;

% Generate contours with levels
contour(x1_grid, x2_grid, f_values, 'LevelStep',1, 'LineWidth', 1, 'ShowText','off', 'LabelFormat','%0.4f');
xlabel('x1');
ylabel('x2');
title('Contour plot of function');
grid on
hold on;


% Define Conjugate Gradient Tolerance 
tol = 1e-2;

% Define the uncertainty for golden search 
uncertainty = 1e-4;


%%% start with iniita values
x_iter1 = [0.55, 0.7]; % initial guess 1
x_iter2 = [ -0.9, -0.5]; % initial guess 2

x_iter_all = [x_iter1; x_iter2];
f_level_set =[];


for i= [1,2]
    x_iter = x_iter_all(i,:);
    k_iter = 1; 
    d_iter = - grad(x_iter(1),x_iter(2)); % initial 
    beta = 0;
    disp(x_iter)

    %%%%%%%%%%%%%%%%%%%%%   Conjugate Gradient Loop    %%%%%%%%%%%%%%%%%%%%%
    
    while norm(grad(x_iter(1),x_iter(2))) > tol
        f_level_set = [f_level_set, f(x_iter(1),x_iter(2))];
        

    
        % Golden search loop
        % Initialize the variables for k=1
        a = 0; 
        b = 5;
        % Define the golden ratio
        rho = (3 - sqrt(5)) / 2;
    
        a1 = a + rho*(b - a); 
        b1 = a + (1-rho)*(b - a); 
 
        phi_a1 = phi(a1, beta, d_iter, x_iter);
        phi_b1 = phi(b1, beta, d_iter, x_iter);
        k = 1;        
              
        % Loop until the interval size is within the uncertainty
        while norm(b - a) > uncertainty
        
            k = k + 1;
        
            if phi_a1 < phi_b1
                b = b1; 
                b1 = a1;
                phi_b1 = phi_a1;
                a1 = a + rho*(b-a); 
                phi_a1 = phi(a1, beta, d_iter, x_iter);
            else
                a = a1;
                a1 = b1;
                phi_a1 = phi_b1;
                b1 = a + (1 - rho)*(b-a);
                % phi_b1 = phi(b1,x_iter);
                phi_b1 = phi(b1, beta, d_iter, x_iter);
            end
            
        
        end
        % Output results for alpha
        alpha = (a1+b1)/2;
        
        % PCG Steps and calculation of parameters
        phi_val = phi(alpha, beta, d_iter, x_iter);
       
        x_new = [(x_iter(1) + alpha*d_iter(1)), (x_iter(2) + alpha*d_iter(2))];
        
        beta = max(0, (grad(x_new(1), x_new(2))' * (grad(x_new(1), x_new(2)) - grad(x_iter(1), x_iter(2)))) / ((grad(x_iter(1), x_iter(2)))' * grad(x_iter(1), x_iter(2))));
        
        % Reinitilize the directional vector every n = 2 
        
        if ~mod(k_iter,2) 
            beta = 0;
        end
     
        d_next= -grad(x_new(1), x_new(2)) + beta *d_iter;
      


        % Tabulate Parameters
        fprintf('Iteration %d: alpha = %.5f, phi_val = %.5f, beta = %.5f, x_iter = [%.5f,%.5f], f(x_iter(1),x_iter(2)) = [%.5f] \n', k_iter, alpha, phi_val, beta, x_iter(1), x_iter(2),f(x_iter(1),x_iter(2)))

        %%%%%%%%%%%%%%%%%%%%%   end of PCG Loop    %%%%%%%%%%%%%%%%%%%%%

    
        % Plot initial point 
        plot(x_iter(1), x_iter(2), 'ro'); hold on;
        if k_iter == 1
            text(x_iter(1), x_iter(2),'Start')
        
        end
        D = x_new - x_iter;
        quiver( x_iter(1), x_iter(2), D(1), D(2), 0 , '--k');hold on;

    
        % Reassign for next loop 
    
        x_iter = [x_new(1),x_new(2)];
        k_iter = k_iter+1;
        d_iter = d_next;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    end
    % f_level_set = [f_level_set f(x_iter(1),x_iter(2))];
    % f_level_set
    text(x_iter(1), x_iter(2),'End')
    % Plot contour and adjust level sets
    contour(x1_grid, x2_grid, f_values, [f_level_set], 'LevelStep',1, 'LineWidth', 1, 'ShowText','on', 'LabelFormat','%0.3f');

end



