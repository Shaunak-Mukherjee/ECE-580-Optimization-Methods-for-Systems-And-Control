% PSO Algo Implementation 
% Clear workspace
clc
clear
close all
rng(1,"twister");

% Define the objective function
syms x y
f_def = 3*(1-x).^2 .* exp(-x.^2-(y+1).^2) ...
           - 10*((x/5) - x.^3 - y.^5) .* exp(-x.^2 - y.^2) ...
           - exp(-(x+1).^2 - y.^2)/3;
f = matlabFunction(f_def);

% Define the range of x and y
x_range = linspace(-3, 3, 100);
y_range = linspace(-3, 3, 100);

% Define the PSO parameters
num_particles = 30;          % Size of swarm
i_max_iter = 100;            % Max number of iterations
inertia_w = 0.7;             % Intertial constant < 1.0
cognitive_c1 = 1.5;          % Cognitive constant, usually 2.0
social_c2 = 1.5;             % Social constant, usually 2.0
phi = 4.1;
kappa = 2/(abs(2-phi-sqrt(phi^2-4*phi)));

% Empty arrays to store best, average, and worst objective function values
best_val = zeros(i_max_iter, 1);
ave_val = zeros(i_max_iter, 1);
worst_val = zeros(i_max_iter, 1);

% Initiate random positions for particles within specified ranges
x_pos = rand(num_particles, 1) * (max(x_range) - min(x_range)) + min(x_range);
y_pos = rand(num_particles, 1) * (max(y_range) - min(y_range)) + min(y_range);

% Define article position and particle velocity
p_pos = [x_pos, y_pos];
p_vel = rand(num_particles, 2);

% Initialize the best particle position and best global position
p_best = p_pos;
gbest_pos = p_pos(1,:);
gbest_val = f(gbest_pos(1), gbest_pos(2));

% Initialize the figure for subplots
figure('Position', [0, 0, 800 , 350]);
ax = subplot(1, 2, 1);
xlabel('x');
ylabel('y');
zlabel('Objective Function Value');
title('PSO Optimization Progress');
hold(ax, 'on');

% Initialize the surface plot
[x_grid, y_grid] = meshgrid(x_range, y_range);
f_values = f(x_grid, y_grid);

% Initialize the particle plot 
contourf(x_grid, y_grid, f_values, 'LevelStep', 1, 'LineWidth', 0.1, 'LineStyle', '--', 'ShowText','On', 'LabelFormat','%0.1f');
p_plot = scatter([], [], 50, 'r', 'filled');  % Empty scatter plot with red filled circles
p_plot.MarkerEdgeColor = 'b';


% PSO main loop
for iter = 1:i_max_iter
    % Update particle positions and velocities
    for i = 1: num_particles

        % Generate vectors 
        r = rand();
        s = rand();

        % Algo implementation               
        p_vel(i,:) = inertia_w * p_vel(i,:) + cognitive_c1 * r .* (p_best(i,:) - p_pos(i,:)) + social_c2 * s .* (gbest_pos - p_pos(i,:));
        
        % Clerc's Cnstriction factor 
        % p_vel(i,:) = kappa*(p_vel(i,:) + cognitive_c1 * r .* (p_best(i,:)) - p_pos(i,:)) + social_c2 * s .* (gbest_pos - p_pos(i,:));
        p_pos(i,:) = p_pos(i,:) + p_vel(i,:);
        
        % Correction factor
        if p_pos(i,1) > max(x_range)
            p_pos(i,1) = max(x_range); 
        elseif p_pos(i,1) < min(x_range)
            p_pos(i,1) = min(x_range); 
        end
        
        if p_pos(i,2) > max(y_range)
            p_pos(i,2) = max(y_range); 
        elseif p_pos(i,2) < min(y_range)
            p_pos(i,2) = min(y_range); 
        end
        
        % Update personal best
        if f(p_pos(i,1), p_pos(i,2)) < f(p_best(i,1), p_best(i,2))
            p_best(i,:) = p_pos(i,:);
        end
    end
    
    % Update global best
    for i = 1:num_particles
        if f(p_best(i,1), p_best(i,2)) < gbest_val
            gbest_pos = p_best(i,:);
            gbest_val = f(gbest_pos(1), gbest_pos(2));
        end
    end
    
    % Update particle plot
    % set(p_plot, 'XData', p_pos(:,1), 'YData', p_pos(:,2), 'ZData', f(p_pos(:,1), p_pos(:,2)));
    set(p_plot, 'XData', p_pos(:,1), 'YData', p_pos(:,2));

    % disp(iter)

    % Pause for a short duration to create cool animation effect (optional)
    pause(0.1);
    
    % Store best, average, and worst objective function values for this iteration
    best_val(iter) = min(f(p_pos(:,1), p_pos(:,2)));
    best_gbest_val(iter) = min(gbest_val);
    ave_val(iter) = mean(f(p_pos(:,1), p_pos(:,2)));
    worst_val(iter) = max(f(p_pos(:,1), p_pos(:,2)));
    
end


% Display final result
disp('Optimization finished.');
disp(['Best solution found: x = ', num2str(gbest_pos(1)), ', y = ', num2str(gbest_pos(2))]);
disp(['Minimum value: ', num2str(gbest_val)]);

% Plotting the best, average, and worst objective function values
generation = 1:i_max_iter;
ay = subplot(1, 2, 2);
plot(ay, generation, best_gbest_val, 'greeno-', generation, best_val, 'blueo-', generation, ave_val, 'blacko-', generation, worst_val, 'redo-', 'MarkerSize', 2);
title(ay, 'PSO of Function');
xlabel(ay, 'Generation');
ylabel(ay, 'Objective Function Value');
legend(ay, 'Global Best', 'Best', 'Average', 'Worst');
grid(ay, 'on');
