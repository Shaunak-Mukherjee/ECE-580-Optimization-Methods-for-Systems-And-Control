% GAA Applied to TS Problem
% Clear workspace and command window
close All
clear
clc

% Locations of the cities
x = [0.4306 3.7094 6.9330 9.3582 4.7758 1.2910 4.8383 9.4560 3.6774 3.2849];
y = [7.7288 2.9727 1.7785 6.9080 2.6394 4.5774 8.4369 8.8150 7.0002 7.5569];

num_cities = 10; % Given

% City labels
city_labels = {'City 1', 'City 2', 'City 3', 'City 4', 'City 5', 'City 6', 'City 7', 'City 8', 'City 9', 'City 10'};

% Plot the cities
figure;
scatter(x, y, 'o', 'blue');
hold on;
text(x, y, city_labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
title('Locations of the cities');
xlabel('x');
ylabel('y');
grid on;

% Possible paths to visit the cities
possible_path = factorial(num_cities - 1);
disp(['Number of different possible paths for visiting ', num2str(num_cities), ' cities once and only once: ', num2str(possible_path)]);

% Genetic Algorithm Parameters
pop_size = 50;  % popation size
num_gens = 100; % Number of generations
p_m = 0.01;     % Rate of mutation (optional)

% Initialize population (pop)
pop = zeros(pop_size, num_cities);
for i = 1 : pop_size
    pop(i, :) = randperm(num_cities);
end

% Evaluate fitness
for generation = 1:num_gens    
    fitness = zeros(pop_size, 1);
    for i = 1:pop_size
        fitness(i) = evaluate_fitness(pop(i, :), x, y);
    end
    
    % Selection process 
    [~, sorted_indices] = sort(fitness, 'descend');
    selected_indices = sorted_indices(1:pop_size/2);
    parents = pop(selected_indices, :);
    
    % Crossover: Single-point crossover 
    for i = 1:2:pop_size
        parent1 = parents(mod(i, pop_size/2) + 1, :); % Parent #1
        parent2 = parents(mod(i + 1, pop_size/2) + 1, :); % Parent #2
        x_over = randi([1, num_cities - 1]); % Crossover
        
        offspring1 = [parent1(1:x_over), setdiff(parent2, parent1(1:x_over), 'stable')];
        offspring2 = [parent2(1:x_over), setdiff(parent1, parent2(1:x_over), 'stable')];
        pop(i, :) = mutate(offspring1, p_m); % Apply mutation
        pop(i + 1, :) = mutate(offspring2, p_m); % Apply mutation
        
        % pop(i, :) = mutate(offspring1, p_m); % No mutation
        % pop(i + 1, :) = mutate(offspring2, p_m); % No mutation
    end
    % Store best fitness of this generation
    best_fit_per_gen(generation) = max(fitness);
end


% Report the best route
best_route = pop(1, :);
total_distance = min(1./best_fit_per_gen);
best_fitness = evaluate_fitness(best_route, x, y);
disp(['Best TSP City Route: [' num2str(best_route),']']);
disp(['Best fitneess: ', num2str(best_fitness)]);
disp(['Total distance: ', num2str(total_distance)]);

% Plot the best route
plot_route(x, y, best_route);
title(['Best Fitness: ', num2str(best_fitness)]);

% Plot generation vs best fitness
figure;
plot(1:num_gens, 1./best_fit_per_gen,'blue', 'LineWidth', 1.0);
title('Generation vs Total distance');
xlabel('Generation');
ylabel('Total distance');


% Function to evaluate fitness
function fitness = evaluate_fitness(route, x, y)
    distance = 0;
    num_cities = length(route);
    for i = 1:num_cities-1
        distance = distance + sqrt((x(route(i)) - x(route(i+1)))^2 + (y(route(i)) - y(route(i+1)))^2);
    end
    distance = distance + sqrt((x(route(end)) - x(route(1)))^2 + (y(route(end)) - y(route(1)))^2); 
    fitness = 1/distance; 
end

% Function to mutate a route
function mutated_route = mutate(route, p_m_rate)
    num_cities = length(route);
    for i = 1:num_cities
        if rand < p_m_rate
            j = randi([1, num_cities]);
            route([i, j]) = route([j, i]); 
        end
    end
    mutated_route = route;
end


% Function to show the path with arrows
function plot_route(x, y, route)
    plot(x(route), y(route), 'blue', 'LineWidth', 0.1);
    scatter(x(route), y(route), 'filled', 'MarkerEdgeColor', 'blue');
end 
