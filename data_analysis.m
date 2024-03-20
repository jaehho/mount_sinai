data = readtable('data.xlsx', 'Sheet', 'Joint Angles ZXY', 'Range', 'W1:Y10');

% Define the angle ranges
ranges = [-Inf, -10; -10, 10; 10, Inf];

% Initialize counters for each range and joint
counters = zeros(size(ranges, 1), 3); % 3 joints, 3 ranges

% Analyze Right Shoulder Abduction/Adduction
for i = 1:size(ranges, 1)
    counters(i, 1) = sum(data.RightShoulderAbduction_Adduction > ranges(i, 1) & data.RightShoulderAbduction_Adduction <= ranges(i, 2));
end

% Analyze Right Shoulder Internal/External Rotation
for i = 1:size(ranges, 1)
    counters(i, 2) = sum(data.RightShoulderInternal_ExternalRotation > ranges(i, 1) & data.RightShoulderInternal_ExternalRotation <= ranges(i, 2));
end

% Analyze Right Shoulder Flexion/Extension
for i = 1:size(ranges, 1)
    counters(i, 3) = sum(data.RightShoulderFlexion_Extension > ranges(i, 1) & data.RightShoulderFlexion_Extension <= ranges(i, 2));
end

% Display the results
disp("Counters for each joint and range:");
disp("Rows: Range, Columns: [Abduction/Adduction, Internal/External Rotation, Flexion/Extension]");
disp(counters);