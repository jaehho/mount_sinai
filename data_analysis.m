data = readtable(data.xlsx);

% Extract joint angles from the table
RightShoulderAbduction_Adduction = data.RightShoulderAbduction_Adduction;
RightShoulderInternal_ExternalRotation = data.RightShoulderInternal_ExternalRotation;
RightShoulderFlexion_Extension = data.RightShoulderFlexion_Extension;

% Define angle ranges for each joint motion
% For example purposes, ranges are arbitrarily defined as Low, Medium, and High
% Update these ranges based on your specific requirements
ranges = struct();
ranges.Abduction_Adduction = [-90, 0; 0, 90; 90, 180];
ranges.Internal_ExternalRotation = [-90, -30; -30, 30; 30, 90];
ranges.Flexion_Extension = [0, 45; 45, 90; 90, 180];

% Initialize counters for each range
counters = struct();
counters.Abduction_Adduction = zeros(1, 3);
counters.Internal_ExternalRotation = zeros(1, 3);
counters.Flexion_Extension = zeros(1, 3);

% Count the frames for Abduction/Adduction
for i = 1:size(ranges.Abduction_Adduction, 1)
    range = ranges.Abduction_Adduction(i, :);
    counters.Abduction_Adduction(i) = sum(RightShoulderAbduction_Adduction >= range(1) & RightShoulderAbduction_Adduction <= range(2));
end

% Count the frames for Internal/External Rotation
for i = 1:size(ranges.Internal_ExternalRotation, 1)
    range = ranges.Internal_ExternalRotation(i, :);
    counters.Internal_ExternalRotation(i) = sum(RightShoulderInternal_ExternalRotation >= range(1) & RightShoulderInternal_ExternalRotation <= range(2));
end

% Count the frames for Flexion/Extension
for i = 1:size(ranges.Flexion_Extension, 1)
    range = ranges.Flexion_Extension(i, :);
    counters.Flexion_Extension(i) = sum(RightShoulderFlexion_Extension >= range(1) & RightShoulderFlexion_Extension <= range(2));
end

% Display the results
disp('Frames count for Right Shoulder Abduction/Adduction in each range:');
disp(counters.Abduction_Adduction);
disp('Frames count for Right Shoulder Internal/External Rotation in each range:');
disp(counters.Internal_ExternalRotation);
disp('Frames count for Right Shoulder Flexion/Extension in each range:');
disp(counters.Flexion_Extension);