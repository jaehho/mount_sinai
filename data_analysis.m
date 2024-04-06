function data_analysis()
    % Read the data from an Excel file
    jointAnglesData = readtable('test_data.xlsx', 'Sheet', 'Joint Angles ZXY');
    segmentVelocitiesData = readtable('test_data.xlsx', 'Sheet', 'Segment Angular Velocity');

    joints = {...
        {'L5S1LateralBending', 'L5S1AxialBending', 'L5S1Flexion_Extension'},...
        {'T1C7LateralBending', 'T1C7AxialRotation', 'T1C7Flexion_Extension'},...
        {'RightShoulderAbduction_Adduction', 'RightShoulderInternal_ExternalRotation', 'RightShoulderFlexion_Extension'},...
        {'RightElbowUlnarDeviation_RadialDeviation', 'RightElbowPronation_Supination', 'RightElbowFlexion_Extension'},...
        {'RightWristUlnarDeviation_RadialDeviation', 'RightWristPronation_Supination', 'RightWristFlexion_Extension'},...
        {'LeftShoulderAbduction_Adduction', 'LeftShoulderInternal_ExternalRotation', 'LeftShoulderFlexion_Extension'},...
        {'LeftElbowUlnarDeviation_RadialDeviation', 'LeftElbowPronation_Supination', 'LeftElbowFlexion_Extension'},...
        {'LeftWristUlnarDeviation_RadialDeviation', 'LeftWristPronation_Supination', 'LeftWristFlexion_Extension'},...
        {'RightKneeAbduction_Adduction', 'RightKneeInternal_ExternalRotation', 'RightKneeFlexion_Extension'},...
        {'LeftKneeAbduction_Adduction', 'LeftKneeInternal_ExternalRotation', 'LeftKneeFlexion_Extension'}...
    };
    
    segmentVelocities = {...
        {'L5X', 'L5Y', 'L5Z'},...
        {'NeckX', 'NeckY', 'NeckZ'},...
        {'RightUpperArmX', 'RightUpperArmY', 'RightUpperArmZ'},...
        {'RightForearmX', 'RightForearmY', 'RightForearmZ'},...
        {'RightHandX', 'RightHandY', 'RightHandZ'},...
        {'LeftUpperArmX', 'LeftUpperArmY', 'LeftUpperArmZ'},...
        {'LeftForearmX', 'LeftForearmY', 'LeftForearmZ'},...
        {'LeftHandX', 'LeftHandY', 'LeftHandZ'},...
        {'RightLowerLegX', 'RightLowerLegY', 'RightLowerLegZ'},...
        {'LeftLowerLegX', 'LeftLowerLegY', 'LeftLowerLegZ'}...
    };

    % Create a dictionary to map joint angles to segment velocities
    jointToSegmentDict = dictionary;
    
    % Populate the dictionary with individual mappings
    for i = 1:length(joints)
        for j = 1:length(joints{i})
            key = joints{i}{j}; % Each joint angle is a key
            value = segmentVelocities{i}{j}; % Corresponding segment velocity is the value
            jointToSegmentDict(key) = value; % Insert into the dictionary
        end
    end

    totalJointAngles = sum(cellfun(@(x) length(x), joints));
    frames = height(jointAnglesData.(joints{1}{1}));
    results = cell(length(totalJointAngles), 10); % Using cell array to accommodate mixed data types
    jointData = zeros(frames, 3); % Initialize joint group data

    % Process each joint motion
    for i = 1:length(joints) % joints (e.g shoulder) 1-10
        for j = 1:length(joints{i}) % joint motions (e.g shoulder flexion) 1 = abd, 2 = int, 3 = flex 
            joint = findCommonPrefix(joints{i}); % Find the common prefix for the joint group
            jointMotion = joints{i}{j}; 
            jointMotionData = jointAnglesData.(jointMotion);
            jointData(:, j) = jointMotionData; % Store joint data for the group (e.g shoulder)
            ranges = calculateRanges(jointMotion);
            
            neutral = 0; medium = 0; extreme = 0; % Initialize counters for each range
            for k = 1:frames % frame 1-frames
                x = jointData(k, 1); y = jointData(k, 2); z = jointData(k, 3); % x = abd, y = int, z = flex 
                if startsWith(jointMotion, 'RightShoulder') || startsWith(jointMotion, 'LeftShoulder')
                    [neutral, medium, extreme] = calculateCircleStatus(x, y, z, ranges(1, 2), ranges(2, 2), neutral, medium, extreme);
                elseif startsWith(jointMotion, 'RightWrist') || startsWith(jointMotion, 'LeftWrist')
                    [neutral, medium, extreme] = calculateEllipseStatus(x, y, z, ranges(1, 1), ranges(2, 1), neutral, medium, extreme);
                else
                    [neutral, medium, extreme] = calculateFlexionStatus(x, y, z, ranges(1, 1), ranges(2, 1), neutral, medium, extreme);
                end
            end        

            neutralPercent = neutral / frames;
            mediumPercent = medium / frames;
            extremePercent = extreme / frames;
            totalPercent = neutralPercent + mediumPercent + extremePercent;

            if isKey(jointToSegmentDict, jointMotion)
                correspondingVelocity = jointToSegmentDict(jointMotion);
                segmentVelocityData = segmentVelocitiesData.(correspondingVelocity); % Access segment velocity data
            end

            stats = calculateStats(jointMotionData);

            atRest = 0; % Set atRest to 0 until code for it is implemented
            results(i, :) = {jointMotion, stats(1), stats(2), stats(3), stats(4), neutralPercent, mediumPercent, extremePercent, atRest, totalPercent};
        end
        fprintf('%s Neutral Percentage: %.2f%%\n', joint, neutralPercent * 100);
        fprintf('%s Medium Percentage: %.2f%%\n', joint, mediumPercent * 100);
        fprintf('%s Extreme Percentage: %.2f%%\n', joint, extremePercent * 100);
        fprintf('%s Total Percentage: %.2f%%\n', joint, totalPercent * 100);
    end

    % Convert results to table
    resultsTable = cell2table(results, 'VariableNames', {'JointMotion', '50th', '99th', 'Min', 'Max', 'Neutral', 'Medium', 'Extreme', 'Rest' 'Percent Total'});
    
    % Write table to Excel file
    writetable(resultsTable, 'results.csv');

    % Optionally, display the table in the Command Window
    % disp(resultsTable);
end

function stats = calculateStats(jointMotionData)
    stats = [median(jointMotionData), prctile(jointMotionData, 99) min(jointMotionData), max(jointMotionData)];
end

function ranges = calculateRanges(jointMotion)
    if startsWith(jointMotion, 'L5S1')
        ranges = [0, 5; 5, 15; 15, 180];
    elseif startsWith(jointMotion, 'T1C7')
        ranges = [0, 5; 5, 5; 5, 180];
    elseif startsWith(jointMotion, 'RightShoulder') || startsWith(jointMotion, 'LeftShoulder')
        ranges = [0, 20; 20, 60; 60, 180];
    elseif startsWith(jointMotion, 'RightElbow') || startsWith(jointMotion, 'LeftElbow')
        ranges = [180, 160; 160, 90; 90, 0];
    elseif startsWith(jointMotion, 'RightWristUlnar') || startsWith(jointMotion, 'LeftWristUlnar')
        ranges = [0, 5; 5, 15; 15, 180];
    elseif startsWith(jointMotion, 'RightWristFlexion') || startsWith(jointMotion, 'LeftWristFlexion')
        ranges = [0, 5; 5, 5; 5, 180];
    elseif startsWith(jointMotion, 'RightWristPronation') || startsWith(jointMotion, 'LeftWristPronation')
        ranges = [0, 5; 5, 5; 5, 180];
    elseif startsWith(jointMotion, 'RightKnee') || startsWith(jointMotion, 'LeftKnee')
        ranges = [0, 10; 10, 30; 30, 180];
    else
        error(['Custom ranges for ' jointMotion ' are not defined.']);
    end
end

function commonPrefix = findCommonPrefix(strings)
    % Ensure the input is a 1x3 cell array of strings
    if ~iscell(strings) || numel(strings) ~= 3
        error('Input must be a 1x3 cell array of strings.');
    end

    % Initialize variables
    commonPrefix = ''; % Start with an empty common prefix
    minLength = min(cellfun(@length, strings)); % Find the length of the shortest string

    % Iterate over each character up to the length of the shortest string
    for i = 1:minLength
        % Get the current character from each string
        char1 = strings{1}(i);
        char2 = strings{2}(i);
        char3 = strings{3}(i);

        % Check if the characters are the same
        if char1 == char2 && char2 == char3
            commonPrefix = [commonPrefix, char1]; %#ok<AGROW> % Append the character to the common prefix
        else
            break; % Stop if any character differs
        end
    end
end

function [neutral, medium, extreme] = calculateCircleStatus(x, y, z, lowerThreshold, upperThreshold, neutral, medium, extreme)
    if y <= lowerThreshold
        if (x^2 + z^2) <= lowerThreshold^2
            neutral = neutral + 1;
        end
        if (x^2 + z^2) > lowerThreshold^2 && (x^2 + z^2) <= upperThreshold^2
            medium = medium + 1;
        end
        if (x^2 + z^2) > upperThreshold^2
            extreme = extreme + 1;
        end
    end

    if y > lowerThreshold && y <= upperThreshold
        if (x^2 + z^2) > lowerThreshold^2 && (x^2 + z^2) <= upperThreshold^2
            medium = medium + 1;
        else
            extreme = extreme + 1;
        end
    end

    if y > upperThreshold
        extreme = extreme + 1;
    end
end

function [neutral, medium, extreme] = calculateEllipseStatus(x, y, z, lowerThreshold, upperThreshold, neutral, medium, extreme)
    if y <= lowerThreshold
        if (x^2/(5^2) + z^2/(5^2)) <= 1
            neutral = neutral + 1;
        end
        if (x^2/(5^2) + z^2/(5^2)) > 1 && (x^2/(15^2) + z^2/(15^2)) <= 1
            medium = medium + 1;
        end
        if (x^2/(15^2) + z^2/(15^2)) > 1
            extreme = extreme + 1;
        end
    end

    if y > lowerThreshold && y <= upperThreshold
        if (x^2 + z^2) > lowerThreshold^2 && (x^2 + z^2) <= upperThreshold^2
            medium = medium + 1;
        else
            extreme = extreme + 1;
        end
    end

    if y > upperThreshold
        extreme = extreme + 1;
    end
end

function [neutral, medium, extreme] = calculateFlexionStatus(x, y, z, lowerThreshold, upperThreshold, neutral, medium, extreme)
    if z <= lowerThreshold
        neutral = neutral + 1;
    elseif z > lowerThreshold && z <= upperThreshold
        medium = medium + 1;
    else
        extreme = extreme + 1;
    end
end
