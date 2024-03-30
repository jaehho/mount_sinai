function data_analysis()
    % Read the data from an Excel file
    data = readtable('data.xlsx', 'Sheet', 'Joint Angles ZXY');

    % Automatically generate joint motions list from table column names

    jointAngles = {...
        'C1HeadLateralBending','C1HeadAxialRotation','C1HeadFlexion_Extension',...
        'RightShoulderAbduction_Adduction','RightShoulderInternal_ExternalRotation','RightShoulderFlexion_Extension',...
        'RightElbowUlnarDeviation_RadialDeviation','RightElbowPronation_Supination','RightElbowFlexion_Extension',...
        'RightWristUlnarDeviation_RadialDeviation','RightWristPronation_Supination','RightWristFlexion_Extension',...
        'LeftShoulderAbduction_Adduction','LeftShoulderInternal_ExternalRotation','LeftShoulderFlexion_Extension',...
        'LeftElbowUlnarDeviation_RadialDeviation','LeftElbowPronation_Supination','LeftElbowFlexion_Extension',...
        'LeftWristUlnarDeviation_RadialDeviation','LeftWristPronation_Supination','LeftWristFlexion_Extension',...
        'RightHipAbduction_Adduction','RightHipInternal_ExternalRotation','RightHipFlexion_Extension',...
        'RightKneeAbduction_Adduction','RightKneeInternal_ExternalRotation','RightKneeFlexion_Extension',...
        'LeftHipAbduction_Adduction','LeftHipInternal_ExternalRotation','LeftHipFlexion_Extension',...
        'LeftKneeAbduction_Adduction','LeftKneeInternal_ExternalRotation','LeftKneeFlexion_Extension',...
        };
    segmentVelocities = {...
        'PelvisX','PelvisY','PelvisZ',...
        'L5X','L5Y','L5Z',...
        'HeadX','HeadY','HeadZ',...
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
        jointData = data.(jointAngle);

        if isKey(jointToSegmentMap, jointAngle)
            correspondingVelocity = jointToSegmentMap(jointAngle);
            fprintf('The segment velocity for %s is %s.\n', jointAngle, correspondingVelocity);
        else
            fprintf('No segment velocity found for %s.\n', jointAngle);
        end

        segmentData = data.(correspondingVelocity{i});

        % Calculate statistics
        stats = calculateStats(jointData);

        % Calculate ranges
        ranges = calculateRanges(jointAngle);

        restStatus = checkRestStatus;

        % Calculate frame percentages
        percentFrames = calculateFramePercentages(jointData, ranges);
        totalpercent = sum(percentFrames);

        % Collect results in preallocated array
        results(i, :) = {jointAngle, stats(1), stats(2), stats(3), percentFrames(1), percentFrames(2), percentFrames(3), totalpercent, restStatus};
    end

    % Convert results to table
    resultsTable = cell2table(results, 'VariableNames', {'JointMotion', 'Median', 'Min', 'Max', 'PercentFramesRange1', 'PercentFramesRange2', 'PercentFramesRange3', 'percentTotal'});
    
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
    if startsWith(jointAngle, 'C1Head')
        ranges = [0, 5; 0, 10; 10, 20];
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
    elseif startsWith(jointAngle, 'RightHip')
        ranges = [-20, -10; -10, 0; 0, 10];
    elseif startsWith(jointAngle, 'LeftHip')
        ranges = [-25, -15; -15, -5; -5, 5];
    elseif startsWith(jointAngle, 'RightKnee')
        ranges = [-15, -5; -5, 5; 5, 15];
    elseif startsWith(jointAngle, 'LeftKnee')
        ranges = [-10, 0; 0, 10; 10, 20];
    else
        error(['Custom ranges for ' jointAngle ' are not defined.']);
    end
end

function restStatus = checkRestStatus(velocity)
    restStatus = velocity < 5;
end

function percentFrames = calculateFramePercentages(jointData, ranges)
    totalFrames = length(jointData);
    percentFrames = zeros(1, size(ranges, 1));
    for i = 1:size(ranges, 1)
        count = sum(jointData >= ranges(i,1) & jointData <= ranges(i,2));
        percentFrames(i) = count / totalFrames * 100;
    end
end