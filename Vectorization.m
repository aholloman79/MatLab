%% Supersonic Jet Engine Data Cleaning and Analysis

% Step 1: Generate a simulated dataset for supersonic jet engines.
% I created a large dataset simulating various metrics for supersonic jet engines.

% Number of jets and test runs
num_jets = 1000; % Total number of jets
num_tests = 50;  % Total number of test runs per jet

% Initialize the dataset
% The dimensions are [num_jets, num_tests, num_metrics].
% Metrics: 1. Thrust (kN), 2. Temperature (°C), 3. Fuel Efficiency (km/L)
jet_data = rand(num_jets, num_tests, 3) .* [200 1200 15]; % Simulated ranges for metrics

% Introduce missing values (10% random missing)
missing_mask = rand(size(jet_data)) < 0.1; % 10% random missing values
jet_data(missing_mask) = NaN;

% Introduce outliers (5% random outliers)
outlier_mask = rand(size(jet_data)) < 0.05; % 5% random outliers
jet_data(outlier_mask) = jet_data(outlier_mask) .* 5; % Outliers are exaggerated by a factor of 5

%% Step 2: Data Cleaning

% Step 2.1: Remove outliers in thrust, temperature, and fuel efficiency
% I identified outliers as values exceeding 3 standard deviations from the mean.

% Calculate mean and standard deviation for each metric.
metric_means = mean(jet_data, [1, 2], 'omitnan'); % Mean for each metric
metric_stds = std(jet_data, 0, [1, 2], 'omitnan'); % Standard deviation for each metric

% Logical masks for outliers
outliers = abs(jet_data - metric_means) > 3 * metric_stds;

% Replace outliers with the respective mean
% I chose to replace outliers with the mean for consistency.
jet_data(outliers) = metric_means(outliers);

% Step 2.2: Fill missing values
% Missing values are replaced using column-wise means for each test metric.

for metric = 1:3
    % Compute the mean for the current metric across jets and tests, ignoring NaN
    column_mean = mean(jet_data(:, :, metric), 'omitnan');
    
    % Replicate the mean to match the size of the data
    replicated_mean = repmat(column_mean, size(jet_data, 1), 1);
    
    % Identify missing values in the current metric
    missing_values = isnan(jet_data(:, :, metric));
    
    % Replace missing values with the corresponding column mean
    jet_data(:, :, metric)(missing_values) = replicated_mean(missing_values);
end

%% Step 3: Exploratory Data Analysis

% Step 3.1: Summary statistics for cleaned data
% I calculated key metrics for each test to ensure data validity.

summary_stats = struct();
for metric = 1:3
    metric_name = ["Thrust", "Temperature", "Fuel_Efficiency"];
    summary_stats.(metric_name(metric)) = struct( ...
        'Mean', mean(jet_data(:, :, metric), 'all'), ...
        'Median', median(jet_data(:, :, metric), 'all'), ...
        'StandardDeviation', std(jet_data(:, :, metric), 0, 'all') ...
    );
end

% Display the summary statistics
disp("Summary Statistics for Supersonic Jet Engine Data:");
disp(summary_stats);

% Step 3.2: Plot metrics to observe trends
% I created visualizations for each metric to observe their distribution and trends.

figure;
metric_titles = ["Thrust (kN)", "Temperature (°C)", "Fuel Efficiency (km/L)"];
for metric = 1:3
    subplot(1, 3, metric);
    histogram(jet_data(:, :, metric), 50);
    title(metric_titles(metric));
    xlabel(metric_titles(metric));
    ylabel('Frequency');
end

%% Step 4: Save cleaned data
% Save the cleaned data for further analysis or model training.

save('cleaned_jet_data.mat', 'jet_data');
disp('Cleaned data saved to cleaned_jet_data.mat');