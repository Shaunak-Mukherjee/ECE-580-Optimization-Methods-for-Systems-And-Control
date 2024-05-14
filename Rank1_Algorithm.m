% Rank1 Correction Algorithm Implementation
clear 
clc

syms x1 x2 
% Define the function
f_def = (x2 - x1).^4 + 12*x1.*x2 - x1 + x2 + 3;
f = matlabFunction(f_def);

% Define gradient & Hessian
grad_def = gradient(f_def);
grad = matlabFunction(grad_def);
hessian_f = hessian(f_def, [x1, x2]);
hessian_f_func = matlabFunction(hessian_f);


% Define  objective function alpha for line search
phi = @(alpha, x_iter) f((x_iter(1) - alpha*(12*x_iter(2) + 4*(x_iter(1) - x_iter(2)).^3 - 1)), (x_iter(2) - alpha*(12*x_iter(1) - 4*(x_iter(1) - x_iter(2)).^3 + 1)));

% Define the range of x and y for plotting 
x1_range = linspace(-1, 1, 100);
x2_range = linspace(-1, 1, 100);

% Create a grid of x and y values
[x1_grid, x2_grid] = meshgrid(x1_range, x2_range);

% Compute the function values on the grid
f_values = f(x1_grid, x2_grid);
figure;

% Generate contours with levels
contour(x1_grid, x2_grid, f_values, 'LevelStep',2, 'LineWidth', 1, 'LineStyle', '--', 'ShowText','off', 'LabelFormat','%0.4f');
xlabel('x1');
ylabel('x2');
title('Rank One Correcion Algorithm');
grid on
hold on;

% Define Conjugate Gradient Tolerance 
tol = 1e-2;

% Define the uncertainty for golden search 
uncertainty = 1e-4;


% Start with initial values
x_iter1 = [0.55, 0.7]; % initial guess 1
x_iter2 = [ -0.9, -0.5]; % initial guess 2
x_iter_all = [x_iter1; x_iter2];

f_level_set =[]; % Defining level set array 

for i= [1,2]
    x_iter = x_iter_all(i,:);
    Hk = eye(2); % defining symm pos def Id matrix  
    d_iter = - Hk * grad(x_iter(1),x_iter(2));   
    k_iter = 1; 
    % disp(x_iter)
    fprintf('Starting point, x0 = [%.5f,%.5f] \n', x_iter(1), x_iter(2))
    

    %%%%%%%%%%%%%%%%%%%%%   Rank One Algo    %%%%%%%%%%%%%%%%%%%%%
    
    while norm(grad(x_iter(1),x_iter(2))) > tol 
                
        f_level_set = [f_level_set, f(x_iter(1),x_iter(2))]; 
        
        % Golden search loop
        a = 0; 
        b = 5;
        % Define the golden ratio
        rho = (3 - sqrt(5)) / 2;
    
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
        % Output results for alpha
        alpha = (a1+b1)/2;
        
        phi_val = phi(alpha,x_iter);
                      
              
        % Compute next x
        x_new = [(x_iter(1) + alpha * d_iter(1)), (x_iter(2) + alpha * d_iter(2))];
        
        % Compute Algorithm parameters
        grad_new = grad(x_new(1), x_new(2)); 
      
        grad_prev = grad(x_iter(1), x_iter(2));
        
        del_grad = grad_new - grad_prev;
        
        del_x = alpha * d_iter;
        
       
        % Correction factor              
         Hk_new = Hk + (((del_x - Hk * del_grad) * (del_x - Hk * del_grad)')/(del_grad'*(del_x - Hk * del_grad)));
         
         % Applying numerical tolerance
         % if norm((del_grad'*(del_x - Hk * del_grad))) <1e-8 % Tolerance added to denominator to avoid its approach to zero
         %     break
         % end  
         
        
         % Applying Reinitilization the directional vector every n = 2 
        
        % if ~mod(k_iter,2) 
        % 
        %     Hk_new = eye(2);
        % 
        % end

        % Tabulate Parameters
        fprintf('Iteration %d: alpha = %.5f, phi_val = %.5f, x_iter = [%.5f,%.5f], f(x_iter(1),x_iter(2)) = [%.5f] \n', k_iter, alpha, phi_val, x_iter(1), x_iter(2),f(x_iter(1),x_iter(2)));

        %%%%%%%%%%%%%%%%%%%%%   end of Rank one Loop    %%%%%%%%%%%%%%%%%%%%%
        
        % Plot initial point 
                
        if k_iter == 1
            text(x_iter(1), x_iter(2),'Start')
        
        end
        D = x_new - x_iter;
        quiver( x_iter(1), x_iter(2), D(1), D(2), 0 , '--k');hold on;

        % reassign for next loop 
         
        x_iter = [x_new(1),x_new(2)];
        k_iter = k_iter+1;
        Hk = Hk_new;
        d_iter = - Hk * grad(x_iter(1),x_iter(2));
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    end
    
    
    text(x_iter(1), x_iter(2),'End')
    % Plot contour and adjust level sets
    contour(x1_grid, x2_grid, f_values, [f_level_set], 'LevelStep',1, 'LineWidth', 1, 'ShowText','on', 'LabelFormat','%0.3f');
end


