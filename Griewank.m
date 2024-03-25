%% Define Griewank function
function z = Griewank(x1,x2)

    z = 1 + x1.^2 / 4000 + x2.^2 / 4000 - cos(x1) .* cos(x2 / sqrt(2));

end