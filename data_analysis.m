% Read the data from an Excel file
data = readtable('data.xlsx', 'Sheet', 'Joint Angles ZXY', 'Range', 'W1:Y100');

% Extract joint angles from the table
RightShoulderAbduction_Adduction = data.RightShoulderAbduction_Adduction;
RightShoulderInternal_ExternalRotation = data.RightShoulderInternal_ExternalRotation;
RightShoulderFlexion_Extension = data.RightShoulderFlexion_Extension;

% Calculate and display statistics for each joint motion
stats = @(x) [median(x), min(x), max(x)]; % Define an anonymous function for stats

% Open a file for writing
fileID = fopen('analysis_results.txt', 'w');

% Define a custom fprintf to write to both file and Command Window
custom_fprintf = @(varargin) fprintf(fileID, varargin{:}) & fprintf(varargin{:});

% Display stats for Right Shoulder Abduction/Adduction
stats_AbdAdd = stats(RightShoulderAbduction_Adduction);
custom_fprintf('Right Shoulder Abduction/Adduction - Median: %.2f, Min: %.2f, Max: %.2f\n', stats_AbdAdd);

% Display stats for Right Shoulder Internal/External Rotation
stats_IntExtRot = stats(RightShoulderInternal_ExternalRotation);
custom_fprintf('Right Shoulder Internal/External Rotation - Median: %.2f, Min: %.2f, Max: %.2f\n', stats_IntExtRot);

% Display stats for Right Shoulder Flexion/Extension
stats_FlexExt = stats(RightShoulderFlexion_Extension);
custom_fprintf('Right Shoulder Flexion/Extension - Median: %.2f, Min: %.2f, Max: %.2f\n', stats_FlexExt);

% Automatically calculate ranges based on min and max
calculateRanges = @(minVal, maxVal) [minVal, minVal + 1/3 * (maxVal - minVal); minVal + 1/3 * (maxVal - minVal), minVal + 2/3 * (maxVal - minVal); minVal + 2/3 * (maxVal - minVal), maxVal];

% Update ranges based on actual min and max values
ranges = struct();
ranges.Abduction_Adduction = calculateRanges(min(RightShoulderAbduction_Adduction), max(RightShoulderAbduction_Adduction));
ranges.Internal_ExternalRotation = calculateRanges(min(RightShoulderInternal_ExternalRotation), max(RightShoulderInternal_ExternalRotation));
ranges.Flexion_Extension = calculateRanges(min(RightShoulderFlexion_Extension), max(RightShoulderFlexion_Extension));

% Print the calculated ranges for each joint motion
printRanges = @(ranges, motionName) custom_fprintf('%s Ranges:\n  Range 1: %.2f to %.2f\n  Range 2: %.2f to %.2f\n  Range 3: %.2f to %.2f\n', motionName, ranges(1,1), ranges(1,2), ranges(2,1), ranges(2,2), ranges(3,1), ranges(3,2));

% Print the ranges for each motion
printRanges(ranges.Abduction_Adduction, 'Right Shoulder Abduction/Adduction');
printRanges(ranges.Internal_ExternalRotation, 'Right Shoulder Internal/External Rotation');
printRanges(ranges.Flexion_Extension, 'Right Shoulder Flexion/Extension');

% Initialize counters for each range
counters = struct();
counters.Abduction_Adduction = zeros(1, 3);
counters.Internal_ExternalRotation = zeros(1, 3);
counters.Flexion_Extension = zeros(1, 3);

% Total number of frames
totalFrames = size(data, 1);

% Calculate the percent of frames for each range
calculatePercentFrames = @(counts) counts / totalFrames * 100;

% Count the frames for Abduction/Adduction
for i = 1:size(ranges.Abduction_Adduction, 1)
    range = ranges.Abduction_Adduction(i, :);
    counters.Abduction_Adduction(i) = calculatePercentFrames(sum(RightShoulderAbduction_Adduction >= range(1) & RightShoulderAbduction_Adduction <= range(2)));
end

% Count the frames for Internal/External Rotation
for i = 1:size(ranges.Internal_ExternalRotation, 1)
    range = ranges.Internal_ExternalRotation(i, :);
    counters.Internal_ExternalRotation(i) = calculatePercentFrames(sum(RightShoulderInternal_ExternalRotation >= range(1) & RightShoulderInternal_ExternalRotation <= range(2)));
end

% Count the frames for Flexion/Extension
for i = 1:size(ranges.Flexion_Extension, 1)
    range = ranges.Flexion_Extension(i, :);
    counters.Flexion_Extension(i) = calculatePercentFrames(sum(RightShoulderFlexion_Extension >= range(1) & RightShoulderFlexion_Extension <= range(2)));
end

% Display the results in percentages
custom_fprintf('\nPercent of frames for Right Shoulder Abduction/Adduction:\n Range 1: %.2f%%\n Range 2: %.2f%%\n Range 3: %.2f%%\n', counters.Abduction_Adduction);
custom_fprintf('Percent of frames for Right Shoulder Internal/External Rotation:\n Range 1: %.2f%%\n Range 2: %.2f%%\n Range 3: %.2f%%\n', counters.Internal_ExternalRotation);
custom_fprintf('Percent of frames for Right Shoulder Flexion/Extension:\n Range 1: %.2f%%\n Range 2: %.2f%%\n Range 3: %.2f%%\n', counters.Flexion_Extension);

% Close the file
fclose(fileID);