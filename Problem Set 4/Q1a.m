clear; clc; 

%-- Define the functions--
% The "@(x)" syntax is a way to create a quick , anonymous fuction 
P= @(x) x.^2 + 2*x -3 ;
P_prime = @(x) 2*x + 2;         % The derivate of P(x)

%------ 2. Find the First Root(by starting with a guess)
x_k =10;
num_iterations = 10;  % repeat the process 10 times 

% fprintf is a formatted print commad
% '%d' is a placeholder for an integer 
fprintf('----Find firt root(starting at x = %d) ---\n', x_k);
for k=1:num_iterations
    %Calculate P(x_k) using our current guess 
    P_val = P(x_k);

    %Calculate P'(x_k) using our current guess 
    P_prime_val = P_prime(x_k);

    %This is the correction term: P(x_k)/ P'(x_k)
    correction = P_val / P_prime_val;

    % This is the full Netwon's formula: x_k+1= x_k-correction 
    x_k_next = x_k - correction ; 

    % Print our prgoress
    % '%2d' means "an integer, 2 spaces wide" (for 'k')
    % '%2d' means "an integer, 2 spaces wide" (for 'k')
    fprintf('Iteration %2d: x = %.6f\n',k,x_k_next);

    %Update the guess to next 
    x_k=x_k_next;
end

% After the loop finishes, x_k holds our final answer.
fprintf('Found Root 1: %.6f\n\n', x_k); % '\n\n' adds two new lines


% --- 3. Find the Second Root (by starting with a NEW guess) ---
x_k = -10;           % A new initial guess, far away in the other direction

fprintf('--- Finding second root (starting at x = %d) ---\n', x_k);

% This loop does the exact same thing as the first loop,
% but in a more compact, single line.
for k = 1:num_iterations
    
    % x_k_next = x_k - (P(x_k) / P_prime(x_k))
    % This one line does the job of the 5 lines in the loop above.
    % It calculates the new guess and immediately updates x_k with it.
    x_k = x_k - (P(x_k) / P_prime(x_k));
    
    fprintf('Iteration %2d: x = %.6f\n', k, x_k);
end
fprintf('Found Root 2: %.6f\n', x_k);