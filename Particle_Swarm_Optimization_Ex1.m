% PSO Algo Implementation
% Clear workspace
clc
clear
close all
rng(1,"twister");

% Define the objective function
syms x1 x2
f_def = 1 + x1.^2 / 4000 + x2.^2 / 4000 - cos(x1) .* cos(x2 / sqrt(2));
f = matlabFunction(f_def);

% Define the range of x1 and x2
x1_range = linspace(-7, 7, 100);
x2_range = linspace(-7, 7, 100);

% Define the PSO parameters
num_particles = 50;          % Size of swarm
i_max_iter = 100;            % Max number of iterations
inertia_w = 0.7;             % Intertial constant < 1.0
cognitive_c1 = 2.0;          % Cognitive constant, usually 2.0
social_c2 = 2.0;             % Social constant, usually 2.0

% Empty arrays to store best, average, and worst objective function values
best_val = zeros(i_max_iter, 1);
ave_val = zeros(i_max_iter, 1);
worst_val = zeros(i_max_iter, 1);

% Initiate random positions for particles within specified ranges
x1_pos = rand(num_particles, 1) * (max(x1_range) - min(x1_range)) + min(x1_range);
x2_pos = rand(num_particles, 1) * (max(x2_range) - min(x2_range)) + min(x2_range);

% Define article position and particle velocity
p_pos = [x1_pos, x2_pos];
p_vel = rand(num_particles, 2);

% Initialize the best particle position and best global position
p_best = p_pos;
gbest_pos = p_pos(1,:);
gbest_val = f(gbest_pos(1), gbest_pos(2));

% Initialize the figure for subplots
figure('Position', [0, 0, 800 , 350]);
ax1 = subplot(1, 2, 1);
xlabel('x1');
ylabel('x2');
zlabel('Objective Function Value');
title('PSO Optimization Progress');
hold(ax1, 'on');

% Initialize the surface plot
[x1_grid, x2_grid] = meshgrid(x1_range, x2_range);
f_values = f(x1_grid, x2_grid);

% Initialize the contour and particle plot 
contourf(x1_grid, x2_grid, f_values, 'LevelStep', 0.3, 'LineWidth', 0.2, 'LineStyle', '--', 'ShowText','on', 'LabelFormat','%0.1f');

p_plot = scatter([], [], 20, 'r', 'filled');  % Empty scatter plot with red filled circles
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
        p_pos(i,:) = p_pos(i,:) + p_vel(i,:);
        
        
        % Correction factor
        if p_pos(i,1) > max(x1_range)
            p_pos(i,1) = max(x1_range); 
        elseif p_pos(i,1) < min(x1_range)
            p_pos(i,1) = min(x1_range); 
        end
        
        if p_pos(i,2) > max(x2_range)
            p_pos(i,2) = max(x2_range); 
        elseif p_pos(i,2) < min(x2_range)
            p_pos(i,2) = min(x2_range); 
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
disp(['Best solution found: x1 = ', num2str(gbest_pos(1)), ', x2 = ', num2str(gbest_pos(2))]);
disp(['Minimum value: ', num2str(gbest_val)]);

% Plotting the best, average, and worst objective function values
generation = 1:i_max_iter;
ax2 = subplot(1, 2, 2);
% plot(ax2, generation, best_gbest_val, 'blue', generation, best_val, 'g', generation, ave_val, 'b', generation, worst_val, 'r');
plot(ax2, generation, best_gbest_val, 'greeno-', generation, best_val, 'blueo-', generation, ave_val, 'blacko-', generation, worst_val, 'redo-', 'MarkerSize', 2);
title(ax2, 'PSO of Griwank Function');
xlabel(ax2, 'Generation');
ylabel(ax2, 'Objective Function Value');
legend(ax2, 'Global Best', 'Best', 'Average', 'Worst');
grid(ax2, 'on');
