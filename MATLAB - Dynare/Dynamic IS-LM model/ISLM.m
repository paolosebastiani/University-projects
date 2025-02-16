%--------------------------------------------------------------------------
% MONETARY 2024 -   Assignemnt 1
%--------------------------------------------------------------------------
% This m-file does the follwing: 
%   1. Runs Dynare to obtain the IRFs
%   2. Simulates the adjustment path of the economy after a permanent shock
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
dynare IRFs.mod

ypath = oo_.endo_simul(1,:);
ipath = oo_.endo_simul(2,:);

% Plot Output over the first 300 periods
figure;
plot(1:300, ypath(1:300), 'r-', 'LineWidth', 2);
xlabel('Periods');
ylabel('Output (y)');
title('Output Dynamics after Shock');
grid on;

% Plot Interest Rate over the first 300 periods
figure;
plot(1:300, ipath(1:300), 'b-', 'LineWidth', 2);
xlabel('Periods');
ylabel('Interest Rate (i)');
title('Interest Rate Dynamics after Shock');
grid on;

% Create the new steady state variables and the ISLM before and after shock
y_new = ypath(end);
i_new = ipath(end);

A = 10;
g = 0.4;
c = 0.7;
b = 2.5;
beta = 3;
m = 0.7;
rhoi = 5;
rhoy = 7;

i_min = min(ipath) - 0.01;  
i_max = max(ipath) + 0.01; 
i_vals = linspace(i_min, i_max, 100); 
y_is = (-b * i_vals + g + A) / (1 - c);
y_lm = m + beta * i_vals;
A_prime = (1 - c) * y_new + b * i_new - g;
y_new_is = (-b * i_vals + g + A_prime) / (1 - c);

% Plot the adjustment path of the economy towards the new equilibrium 
figure;
plot(y_is, i_vals, 'r-', 'LineWidth', 2, 'DisplayName', 'IS Curve');
hold on;
plot(y_lm, i_vals, 'b-', 'LineWidth', 2, 'DisplayName', 'LM Curve');
plot(ypath(1:300), ipath(1:300), 'ko-', 'LineWidth', 1.5, 'DisplayName', 'Adjustment Path');
plot(y_new_is, i_vals, 'g--', 'LineWidth', 2, 'DisplayName', 'New IS Curve');
xlabel('Output (y)');
ylabel('Interest Rate (i)');
legend('Location', 'best');
title('IS-LM Plot with Adjustment Path and New IS Curve');
grid on;