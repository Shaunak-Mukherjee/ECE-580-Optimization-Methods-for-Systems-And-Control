% Steepest Descent Algorithm
clear 
clc

syms x1 x2 
% Define the function
f_def = (x2 - x1).^4 + 12*x1.*x2 - x1 + x2 + 3;
f = matlabFunction(f_def);

% compute gradient of function
grad_def = gradient(f_def);
grad = matlabFunction(grad_def);

% Define  objective function that needs to be minimized to get next x
phi = @(alpha, x_iter) f((x_iter(1) - alpha*(12*x_iter(2) + 4*(x_iter(1) - x_iter(2)).^3 - 1)), (x_iter(2) - alpha*(12*x_iter(1) - 4*(x_iter(1) - x_iter(2)).^3 + 1)));

% Define the range of x and y
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
title('Steepest Descent');
grid on
hold on;


clc;
clear all;
n=3; % Number of variables
k=10000; % # iterations
p=20; % number of particles
w=1;
c1=1;
c2=1;
 % x=[0.114 0.5556 0.8525]';
 
% initializing swarm and velocities
x=rand(p,n);
for i = 1: p
    f(i)=Hh(x(i,:));
end
fitness = f';
v=rand(p,n);% velocity
[globalmin,index]=min(fitness);
g=x(index,:); % fitness of individuals
 localx=x;

 for i=1:k; 
 
    r1=rand (p,n);
    r2=rand (p,n);
    v=v+w*v+c1*r1.*(localx-x)+c2*r2.*(ones(p,1)*g-x);
    x=x+v;
    
    for j = 1: p
        f(j)=Hh(x(j,:));
        if f(j)<=fitness(j)
           fitness(j)=f(j);
          localx(j,:)=x(j,:);
        end
         
    end
    
    [globalmin,index]=min(fitness);
     g=localx(index,:); % fitness of individuals
 end
 g
globalmin