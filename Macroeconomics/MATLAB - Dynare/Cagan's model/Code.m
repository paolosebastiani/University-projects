%--------------------------------------------------------------------------
% MONETARY POLICY 2024 - Prof. Giovanni di Bartolomeo - Assignment #2 
% 
% Claudio Costarelli, Josemaria Loria, Paolo Sebastiani
%--------------------------------------------------------------------------
%  
%                            CAGAN'S MODEL
%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Note: the Statistics and Machine Learning Toolbox is required


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Point a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import the dataset
data = readtable('cagan_dataset.xlsx');

% Remove useless data and rename variables
data = data(40:end, :);
data = data(:, 2:end);
data = data(1:end-4, :);
data.Properties.VariableNames = {'Obs', 'Dates', 'Y', 'C', 'E_beta_0_20'};

% Create variables from dataset
Y = data.Y;
E = data.("E_beta_0_20");

% Add a column of ones for the intercept of the regression
X = [ones(length(E), 1), E];

% Perform the OLS regression and extract the results (with ~ we skipped the computation of residuals and their CI)
[b, b_int, ~, ~, stats] = regress(Y, X, 0.10);
gamma = -b(1);
alpha = b(2);

% Confidence intervals for the coefficients (90%)
gamma_CI = b_int(1, :);
alpha_CI = b_int(2, :);

% Compute the R^2
R_squared = stats(1);

% Create and display a summary table
summary_table = table(alpha, gamma, alpha_CI, gamma_CI, R_squared,'VariableNames', {'Estimated alpha', 'Estimated gamma', 'CI for alpha (90%)', 'CI for gamma(90%)', 'R^2'});
disp(summary_table)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Point b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import the original dataset
data = readtable('cagan_dataset.xlsx');
data.Properties.VariableNames = {'Obs1','Obs2', 'Dates', 'Y', 'C', 'E_beta_0_20'}; % Rename the variables

% Set parameter beta and calculate the factor (1 - e^(-beta))
beta = 0.20;
factor = 1 - exp(-beta);

% Compute expected inflation (E) manually
t = (1:height(data))';
exp_beta_t = exp(beta * t);
cumulative_sum_column = cumsum(exp_beta_t .* data.C); % Cumulative sum of products with actual inflation (C)
manually_computed_E = (cumulative_sum_column * factor) ./ exp_beta_t;

% Display the comparison of E from the dataset and the manually computed E
comparison_table = table(data.E_beta_0_20, manually_computed_E, 'VariableNames', {'E_beta_0_20', 'manually_computed_E'});
disp(comparison_table(40:end, :));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Point c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import the dataset
data = readtable('cagan_dataset.xlsx');
data = data(:, 2:end);
data.Properties.VariableNames = {'Obs', 'Dates', 'Y', 'C', 'E'};

% Create the original variable Y
Y=data.Y;
C=data.C;

% Define the range of beta values to test
beta_values = [0.01, 0.10, 0.20, 0.50, 0.70, 0.99];

% Initialize a table to store each computed E column for the full dataset
E_table = table('Size', [height(data), length(beta_values)], ...
                'VariableTypes', repmat({'double'}, 1, length(beta_values)), ...
                'VariableNames', strcat('E_', strrep(string(beta_values), '.', '_')));


% Full dataset time index
t_full = (1:height(data))';

% Calculate manually_computed_E for each beta and store in E_table
for i = 1:length(beta_values)
    beta = beta_values(i);
    factor = 1 - exp(-beta);

    % Calculate manually_computed_E over the full dataset
    exp_beta_t = exp(beta * t_full);
    cumulative_sum_column = cumsum(exp_beta_t .* C);
    E_column = (cumulative_sum_column * factor) ./ exp_beta_t;

    % Store the computed E column in E_table
    E_table{:, i} = E_column;
end

% Initialize the results table
results = table('Size', [length(beta_values), 4], ...
                'VariableTypes', {'double', 'double', 'double', 'double'}, ...
                'VariableNames', {'Beta', 'Estimated_alpha', 'Estimated_gamma', 'R_squared'});

% Cleaned data Y
data = data(40:end, :);
data = data(1:end-4, :);

Y_cleaned = data.Y;


% Loop over each computed E column in E_table for OLS on cleaned data
for i = 1:length(beta_values)
    % Get the cleaned portion of the manually computed E for this beta
    E_cleaned = E_table{40:end-4, i};

    % Perform OLS regression with the cleaned data portion of manually computed E
    X = [ones(length(E_cleaned), 1), E_cleaned];
    [b, ~, ~, ~, stats] = regress(Y_cleaned, X, 0.10);

    % Extract results
    gamma = -b(1);
    alpha = b(2);
    R_squared = stats(1);

    % Store the results in the table
    results.Beta(i) = beta_values(i);
    results.Estimated_alpha(i) = alpha;
    results.Estimated_gamma(i) = gamma;
    results.R_squared(i) = R_squared;
end

display(results) % As we can see, the R^2 is maximized for beta=0.20