% --- MATLAB/Octave Script for Steepest Descent: Part (d) ---

clear; clc;

% --- 1. Define the derivative (the slope) ---
% We need the derivative of J(x) = exp(-x/10) * cos(x)
% Using the product rule, J'(x) = -exp(-x/10) * (0.1*cos(x) + sin(x))
J_prime = @(x) -exp(-x/10) .* (0.1*cos(x) + sin(x));

% --- 2. Set up iteration parameters ---
N = 100;           % number of iterations
mu = 0.5;          % algorithm step size (can be a bit larger here)

% --- TEST 1: Start with a guess in the first valley ---
x = zeros(1,N);    % initialize x vector
x(1) = 1.0;        % starting point x(1)
fprintf('--- Finding a local minimum of J(x) = exp(-x/10)*cos(x) ---\n');
fprintf('--- Test 1: Starting at x = %.1f ---\n', x(1));

for k = 1:N-1
    x_k = x(k);
    
    % The function is 0 for x<0, so the derivative is also 0.
    % We only apply the update if x_k is positive.
    if x_k > 0
        x(k+1) = x_k - mu * J_prime(x_k);
    else
        x(k+1) = x_k; % Stay at 0 if we cross it
    end
end
fprintf('Found a Local Minimum at: x = %.6f\n', x(N));
% Let's also calculate the value of J(x) at this minimum
J_val_1 = exp(-x(N)/10) * cos(x(N));
fprintf('Value of J(x) at this minimum: J(%.6f) = %.6f\n\n', x(N), J_val_1);


% --- TEST 2: Start with a guess in the second valley ---
x = zeros(1,N);    % re-initialize x vector
x(1) = 5.0;        % new starting point x(1)

fprintf('--- Finding a local minimum of J(x) = exp(-x/10)*cos(x) ---\n');
fprintf('--- Test 2: Starting at x = %.1f ---\n', x(1));

for k = 1:N-1
    x_k = x(k);
    if x_k > 0
        x(k+1) = x_k - mu * J_prime(x_k);
    else
        x(k+1) = x_k;
    end
end
fprintf('Found a Local Minimum at: x = %.6f\n', x(N));
% Let's calculate the value of J(x) at this minimum
J_val_2 = exp(-x(N)/10) * cos(x(N));
fprintf('Value of J(x) at this minimum: J(%.6f) = %.6f\n\n', x(N), J_val_2);2