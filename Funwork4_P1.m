% Given data converted into matrix form
A = [0.3, 0.1; 0.4, 0.2; 0.3, 0.7]; % Coefficient matrix
b = [5; 3; 4]; % Right-hand side vector

% Calculate A_transpose * A
ATA = A.' * A;

% Calculate A_transpose * b
ATB = A.' * b;

% Solve the system of equations using ATA * X = ATb
x_star = ATA \ ATB;

% Extract the values of x and y
x_1 = x_star(1);
x_2 = x_star(2);

% Calculate the ratio of weights of mixture A to mixture B
ratio = x_1 / x_2;

% Display results
fprintf('Weight of mixture A: %.3f\n', x_1);
fprintf('Weight of mixture B: %.3f\n', x_2);
fprintf('Ratio of weight of mixture A to mixture B: %.3f\n', ratio);
