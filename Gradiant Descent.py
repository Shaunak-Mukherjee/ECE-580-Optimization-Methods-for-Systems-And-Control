#implementation of Gradient Descent

import numpy as np
import matplotlib.pyplot as plt

# Define the function
def f(x1, x2):
    return (x2 - x1) ** 4 + 12 * x1 * x2 - x1 + x2 + 3

# Define the gradient of the function
def grad(x1, x2):
    df_dx1 = -4 * (x2 - x1) ** 3 + 12 * x2 - 1
    df_dx2 = 4 * (x2 - x1) ** 3 + 12 * x1 + 1
    return np.array([df_dx1, df_dx2])

# Define objective function for line search
def phi(alpha, x_iter):
    x1, x2 = x_iter
    return f(x1 - alpha * (12 * x2 + 4 * (x1 - x2) ** 3 - 1), x2 - alpha * (12 * x1 - 4 * (x1 - x2) ** 3 + 1))

# Define Steepest Descent Tolerance
tol = 1e-2

# Define the uncertainty for golden search
uncertainty = 1e-4

# Start with initial values
x_iter1 = np.array([0.55, 0.7])  # initial guess 1
x_iter2 = np.array([-0.9, -0.5])  # initial guess 2

x_iter_all = np.vstack((x_iter1, x_iter2))
f_level_set = []

# Define the range of x and y
x1_range = np.linspace(-1, 1, 100)
x2_range = np.linspace(-1, 1, 100)

# Create a grid of x and y values
x1_grid, x2_grid = np.meshgrid(x1_range, x2_range)

# Compute the function values on the grid
f_values = f(x1_grid, x2_grid)

# Contour levels for the function values
function_levels = np.linspace(np.min(f_values), np.max(f_values), 20)

plt.contourf(x1_grid, x2_grid, f_values, levels=function_levels, cmap='Spectral_r', linestyles='dotted')


plt.colorbar(label='f(x1, x2)')
plt.xlabel('x1')
plt.ylabel('x2')
plt.title('Contour Plot of the Function')

for i in range(2):
    x_iter = x_iter_all[i]
    k_iter = 1
    print(f'Starting point, x0 = {x_iter}')

    while np.linalg.norm(grad(*x_iter)) > tol:
        f_level_set.append(f(*x_iter))

        # Golden search loop
        a, b = 0, 5
        rho = (3 - np.sqrt(5)) / 2

        a1 = a + rho * (b - a)
        b1 = a + (1 - rho) * (b - a)
        phi_a1 = phi(a1, x_iter)
        phi_b1 = phi(b1, x_iter)
        k = 1

        while np.linalg.norm(b - a) > uncertainty:
            k += 1

            if phi_a1 < phi_b1:
                b = b1
                b1 = a1
                phi_b1 = phi_a1
                a1 = a + rho * (b - a)
                phi_a1 = phi(a1, x_iter)
            else:
                a = a1
                a1 = b1
                phi_a1 = phi_b1
                b1 = a + (1 - rho) * (b - a)
                phi_b1 = phi(b1, x_iter)

        alpha = (a1 + b1) / 2
        phi_val = phi(alpha, x_iter)

        print(f'Iteration {k_iter}: alpha = {alpha:.5f}, phi_val = {phi_val:.5f}, x_iter = {x_iter}, f(x_iter) = {f(*x_iter):.5f}')

        x_new = np.array([x_iter[0] - alpha * (12 * x_iter[1] + 4 * (x_iter[0] - x_iter[1]) ** 3 - 1),
                          x_iter[1] - alpha * (12 * x_iter[0] - 4 * (x_iter[0] - x_iter[1]) ** 3 + 1)])

        plt.plot(x_iter[0], x_iter[1], 'ro')
        if k_iter == 1:
            plt.text(x_iter[0], x_iter[1], 'Start', color = 'Black')

        d = x_new - x_iter
        plt.quiver(x_iter[0], x_iter[1], d[0], d[1], angles='xy', scale_units='xy', scale=1, color='k', linestyle='--')

        x_iter = x_new
        k_iter += 1

    plt.text(x_iter[0], x_iter[1], 'End', color = 'white')
    plt.plot(x_iter[0], x_iter[1], 'bx', markersize=1)  # Plot minima

# Adding level set function values
level_set_levels = sorted(list(set(f_level_set)))
cont = plt.contour(x1_grid, x2_grid, f_values, levels=level_set_levels, colors='black', linestyles='dotted', linewidths=1)
plt.clabel(cont, inline=True, fontsize=8)
plt.show()
