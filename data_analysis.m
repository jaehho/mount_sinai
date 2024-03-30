function data_analysis()
    % Read the data from an Excel file
    jointAnglesData = readtable('data.xlsx', 'Sheet', 'Joint Angles ZXY');
    segmentVelocitiesData = readtable('data.xlsx', 'Sheet', 'Segment Angular Velocity');
%hi
    jointAngles = {...
        'L5S1LateralBending','L5S1AxialBending','L5S1Flexion_Extension',...
        'T1C7LateralBending','T1C7AxialRotation','T1C7Flexion_Extension',...
        'RightShoulderAbduction_Adduction','RightShoulderInternal_ExternalRotation','RightShoulderFlexion_Extension',...
        'RightElbowUlnarDeviation_RadialDeviation','RightElbowPronation_Supination','RightElbowFlexion_Extension',...
        'RightWristUlnarDeviation_RadialDeviation','RightWristPronation_Supination','RightWristFlexion_Extension',...
        'LeftShoulderAbduction_Adduction','LeftShoulderInternal_ExternalRotation','LeftShoulderFlexion_Extension',...
        'LeftElbowUlnarDeviation_RadialDeviation','LeftElbowPronation_Supination','LeftElbowFlexion_Extension',...
        'LeftWristUlnarDeviation_RadialDeviation','LeftWristPronation_Supination','LeftWristFlexion_Extension',...
        'RightKneeAbduction_Adduction','RightKneeInternal_ExternalRotation','RightKneeFlexion_Extension',...
        'LeftKneeAbduction_Adduction','LeftKneeInternal_ExternalRotation','LeftKneeFlexion_Extension',...
        };
    segmentVelocities = {...
        'L5X','L5Y','L5Z',...
        'NeckX','NeckY','NeckZ',...
        'RightUpperArmX','RightUpperArmY','RightUpperArmZ',...
        'RightForearmX','RightForearmY','RightForearmZ',...
        'RightHandX','RightHandY','RightHandZ',...
        'LeftUpperArmX','LeftUpperArmY','LeftUpperArmZ',...
        'LeftForearmX','LeftForearmY','LeftForearmZ',...
        'LeftHandX','LeftHandY','LeftHandZ',...
        'RightLowerLegX','RightLowerLegY','RightLowerLegZ',...
        'LeftLowerLegX','LeftLowerLegY','LeftLowerLegZ',...
        };

    % Ensure the lists are of equal length
    assert(length(jointAngles) == length(segmentVelocities), 'Joint angles and segment velocities must be paired correctly.');

    % Create the mapping
    jointToSegmentMap = containers.Map(jointAngles, segmentVelocities);

    % Adjusted for the new set of joint motions
    results = cell(length(jointAngles), 9); % Using cell array to accommodate mixed data types

    % Process each joint motion
    for i = 1:length(jointAngles)
        jointAngle = jointAngles{i};
        jointData = jointAnglesData.(jointAngle);
        correspondingVelocity = jointToSegmentMap(jointAngle); % Corrected access
        segmentVelocityData = segmentVelocitiesData.(correspondingVelocity); % Access segment velocity data
    
        fprintf('The segment velocity for %s is %s.\n', jointAngle, correspondingVelocity);
    
        % Calculate statistics
        stats = calculateStats(jointData);
    
        % Calculate ranges
        ranges = calculateRanges(jointAngle);
    
        % Calculate frame percentages and check for 'at rest' condition
        [percentFrames, atRest] = calculateFramePercentages(jointData, ranges, segmentVelocityData);
    
        % Collect results in preallocated array
        results(i, :) = {jointAngle, stats(1), stats(2), stats(3), percentFrames(1), percentFrames(2), percentFrames(3), atRest, sum(percentFrames)};
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
    % Check for joint angle prefixes and assign custom ranges
    if startsWith(jointAngle, 'L5S1')
        ranges = [0, 5; 0, 10; 10, 20];
    elseif startsWith(jointAngle, 'T1C7')
        ranges = [-30, -15; -15, 0; 0, 15];
    elseif startsWith(jointAngle, 'RightShoulder')
        ranges = [-30, -15; -15, 0; 0, 15];
    elseif startsWith(jointAngle, 'LeftShoulder')
        ranges = [-20, -10; -10, 5; 5, 20];
    elseif startsWith(jointAngle, 'RightElbow')
        ranges = [-25, -10; -10, 5; 5, 20];
    elseif startsWith(jointAngle, 'LeftElbow')
        ranges = [-30, -15; -15, 0; 0, 15];
    elseif startsWith(jointAngle, 'RightWrist')
        ranges = [-20, -5; -5, 10; 10, 25];
    elseif startsWith(jointAngle, 'LeftWrist')
        ranges = [-15, 0; 0, 15; 15, 30];
    elseif startsWith(jointAngle, 'RightKnee')
        ranges = [-15, -5; -5, 5; 5, 15];
    elseif startsWith(jointAngle, 'LeftKnee')
        ranges = [-10, 0; 0, 10; 10, 20];
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