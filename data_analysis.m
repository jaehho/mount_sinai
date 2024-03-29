function data_analysis()
    % Read the data from an Excel file
    data = readtable('data.xlsx', 'Sheet', 'Joint Angles ZXY', 'Range', 'S1:AQ100'); % Adjust range if necessary

    % Automatically generate joint motions list from table column names
    jointMotions = (L5S1LateralBending,L5S1AxialBending,L5S1Flexion_Extension,...
    L4L3LateralBending,L4L3AxialRotation,L4L3Flexion_Extension,L1T12LateralBending,...
    L1T12AxialRotation,L1T12Flexion_Extension,T9T8LateralBending,T9T8AxialRotation,...
    T9T8Flexion_Extension,T1C7LateralBending,T1C7AxialRotation,T1C7Flexion_Extension,...
    C1HeadLateralBending,C1HeadAxialRotation,C1HeadFlexion_Extension,...
    RightT4ShoulderAbduction_Adduction,RightT4ShoulderInternal_ExternalRotation,RightT4ShoulderFlexion_Extension,...
    RightShoulderAbduction_Adduction,RightShoulderInternal_ExternalRotation,RightShoulderFlexion_Extension,...
    RightElbowUlnarDeviation_RadialDeviation,RightElbowPronation_Supination,RightElbowFlexion_Extension,...
    RightWristUlnarDeviation_RadialDeviation,RightWristPronation_Supination,RightWristFlexion_Extension,...
    LeftT4ShoulderAbduction_Adduction,LeftT4ShoulderInternal_ExternalRotation,LeftT4ShoulderFlexion_Extension,...
    LeftShoulderAbduction_Adduction,LeftShoulderInternal_ExternalRotation,LeftShoulderFlexion_Extension,...
    LeftElbowUlnarDeviation_RadialDeviation,LeftElbowPronation_Supination,LeftElbowFlexion_Extension,...
    LeftWristUlnarDeviation_RadialDeviation,LeftWristPronation_Supination,LeftWristFlexion_Extension,...
    RightHipAbduction_Adduction,RightHipInternal_ExternalRotation,RightHipFlexion_Extension,...
    RightKneeAbduction_Adduction,RightKneeInternal_ExternalRotation,RightKneeFlexion_Extension,...
    RightAnkleAbduction_Adduction,RightAnkleInternal_ExternalRotation,RightAnkleDorsiflexion_Plantarflexion,RightBallFootAbduction_Adduction,RightBallFootInternal_ExternalRotation,RightBallFootFlexion_Extension,LeftHipAbduction_Adduction,LeftHipInternal_ExternalRotation,LeftHipFlexion_Extension,LeftKneeAbduction_Adduction,LeftKneeInternal_ExternalRotation,LeftKneeFlexion_Extension,LeftAnkleAbduction_Adduction,LeftAnkleInternal_ExternalRotation,LeftAnkleDorsiflexion_Plantarflexion,LeftBallFootAbduction_Adduction,LeftBallFootInternal_ExternalRotation,LeftBallFootFlexion_Extension    );
    % Preallocate the results array with zeros
    % Adjusted for the new set of joint motions
    results = cell(length(jointMotions), 7); % Using cell array to accommodate mixed data types

    % Process each joint motion
    for i = 1:length(jointMotions)
        motionName = jointMotions{i};
        jointData = data.(motionName); % Dynamically extract joint data

        % Calculate statistics
        stats = calculateStats(jointData);

        % Calculate ranges
        ranges = calculateRanges(jointData);

        % Calculate frame percentages
        percentFrames = calculateFramePercentages(jointData, ranges);

        % Collect results in preallocated array
        results(i, :) = {motionName, stats(1), stats(2), stats(3), percentFrames(1), percentFrames(2), percentFrames(3)};
    end

    % Convert results to table
    resultsTable = cell2table(results, 'VariableNames', {'JointMotion', 'Median', 'Min', 'Max', 'PercentFramesRange1', 'PercentFramesRange2', 'PercentFramesRange3'});
    
    % Write table to Excel file
    writetable(resultsTable, 'all_joints_analysis_results.xlsx');

    % Optionally, display the table in the Command Window
    disp(resultsTable);
end

function stats = calculateStats(jointData)
    stats = [median(jointData), min(jointData), max(jointData)];
end

function ranges = calculateRanges(jointData)
    minVal = min(jointData);
    maxVal = max(jointData);
    step = (maxVal - minVal) / 3;
    ranges = [minVal, minVal + step; minVal + step, minVal + 2*step; minVal + 2*step, maxVal];
end

function percentFrames = calculateFramePercentages(jointData, ranges)
    totalFrames = length(jointData);
    percentFrames = zeros(1, size(ranges, 1));
    for i = 1:size(ranges, 1)
        count = sum(jointData >= ranges(i,1) & jointData <= ranges(i,2));
        percentFrames(i) = count / totalFrames * 100;
    end
end