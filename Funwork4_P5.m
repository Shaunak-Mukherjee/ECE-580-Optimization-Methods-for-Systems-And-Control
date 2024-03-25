% Clear workspace
clear

% Define the costs matrix
costs = [7 10 14 8; 7 11 12 6; 5 8 15 9];

% Reshape costs matrix into a column vector
c_func = reshape(costs', [], 1);

% Define the equality constraints matrix 
Aeq = [1 1 1 1 0 0 0 0 0 0 0 0;
       0 0 0 0 1 1 1 1 0 0 0 0;
       0 0 0 0 0 0 0 0 1 1 1 1;
       1 0 0 0 1 0 0 0 1 0 0 0;
       0 1 0 0 0 1 0 0 0 1 0 0;
       0 0 1 0 0 0 1 0 0 0 1 0;
       0 0 0 1 0 0 0 1 0 0 0 1;];


% Define the equality constraints vector 
beq = [30; 40; 30; 20; 20; 25; 35];

% Define lower bound (non-negative constraint)
lb = zeros(12, 1);

% Solve the linear programming problem
% (source- http://www.ece.northwestern.edu/local-apps/matlabhelp/toolbox/optim/linprog.html)
[c_func, fval, exitflag] = linprog(c_func, [], [], Aeq, beq, lb);

% Display the optimal solution
disp('Optimal solution c_func:')
disp(c_func)


% Reshape the solution vector into a matrix
sol = reshape(c_func, 4, 3)';

% Create a table for the optimal solution
Table = array2table(sol, 'VariableNames', {'D', 'E', 'F', 'G'}, 'RowNames', {'A', 'B', 'C'});


% Display the optimal solution table
disp('Optimal solution tabulated:')
disp(Table)

% Display the total transportation cost
disp('Total transportation cost:')
disp(fval)