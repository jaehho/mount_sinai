function data_analysis()
    % Read the data from an Excel file
    jointAnglesData = readtable('test_data.xlsx', 'Sheet', 'Joint Angles ZXY');
    segmentVelocitiesData = readtable('test_data.xlsx', 'Sheet', 'Segment Angular Velocity');

    jointAngles = {...
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
    for i = 1:length(jointAngles)
        for j = 1:length(jointAngles{i})
            key = jointAngles{i}{j}; % Each joint angle is a key
            value = segmentVelocities{i}{j}; % Corresponding segment velocity is the value
            jointToSegmentDict(key) = value; % Insert into the dictionary
        end
    end

    totalJointAngles = sum(cellfun(@(x) length(x), jointAngles))
    % Adjusted for the new set of joint motions
    results = cell(length(totalJointAngles), 9); % Using cell array to accommodate mixed data types
    resultIndex = 1;

    % Process each joint motion
    for i = 1:length(jointAngles)
        for j = 1:length(jointAngles{i})
            jointAngle = jointAngles{i}{j};
            jointData = jointAnglesData.(jointAngle);
            if isKey(jointToSegmentDict, jointAngle)
                correspondingVelocity = jointToSegmentDict(jointAngle);
                segmentVelocityData = segmentVelocitiesData.(correspondingVelocity); % Access segment velocity data

                % Diagnostic output (unchanged)
                fprintf('The segment velocity for %s is %s.\n', jointAngle, correspondingVelocity);

                % Analysis calculations (unchanged)
                stats = calculateStats(jointData);
                ranges = calculateRanges(jointAngle);
                [percentFrames, atRest] = calculateFramePercentages(jointData, ranges, segmentVelocityData);

                % Collect results using the resultIndex to append correctly
                results(resultIndex, :) = {jointAngle, stats(1), stats(2), stats(3), percentFrames(1), percentFrames(2), percentFrames(3), atRest, sum(percentFrames)};

                % Increment resultIndex to append the next set of results correctly
                resultIndex = resultIndex + 1;
            end
        end
    end

    % Convert results to table
    resultsTable = cell2table(results, 'VariableNames', {'JointMotion', 'Median', 'Min', 'Max', 'Neutral', 'Medium', 'Extreme', 'Rest' 'Percent Total'});
    
    % Write table to Excel file
    writetable(resultsTable, 'results.xlsx');

    % Optionally, display the table in the Command Window
    disp(resultsTable);
end

function stats = calculateStats(jointData)
    stats = [median(jointData), min(jointData), max(jointData)];
end

function ranges = calculateRanges(jointAngle)
    if startsWith(jointAngle, 'L5S1')
        ranges = [0, 5; 5, 15; 15, 180];
    elseif startsWith(jointAngle, 'T1C7')
        ranges = [0, 5; 5, 5; 5, 180];
    elseif startsWith(jointAngle, 'RightShoulder') || startsWith(jointAngle, 'LeftShoulder')
        ranges = [0, 20; 20, 60; 60, 180];
    elseif startsWith(jointAngle, 'RightElbow') || startsWith(jointAngle, 'LeftElbow')
        ranges = [180, 160; 160, 90; 90, 0];
    elseif startsWith(jointAngle, 'RightWrist') || startsWith(jointAngle, 'LeftWrist')
        ranges = [0, 5; 5, 15; 15, 180];
    elseif startsWith(jointAngle, 'RightKnee') || startsWith(jointAngle, 'LeftKnee')
        ranges = [0, 10; 10, 30; 30, 180];
    else
        error(['Custom ranges for ' jointAngle ' are not defined.']);
    end
end

function [percentFrames, atRest] = calculateFramePercentages(jointData, ranges, velocityData)
    totalFrames = length(jointData);
    percentFrames = zeros(1, size(ranges, 1));
    atRest = 0; % Initialize atRest as 0, meaning not at rest by default

    for i = 1:size(ranges, 1)
        count = sum(jointData >= ranges(i,1) & jointData <= ranges(i,2));
        percentFrames(i) = count / totalFrames * 100;
        % Check if in the lowest range and at rest
        if i == 1 && all(velocityData < 5)
            atRest = percentFrames(i); % Assign the percentage of the first range to atRest if condition is met
            percentFrames(i) = 0; % Reset the first range percentage as it's considered 'at rest'
        end
    end
end