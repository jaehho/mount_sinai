function data_analysis()
    % Read the data from an Excel file
    data = readtable('data.xlsx', 'Sheet', 'Joint Angles ZXY', 'Range', 'W1:Y100');

    % Define joint motions to analyze
    jointMotions = {'Abduction_Adduction', 'Internal_ExternalRotation', 'Flexion_Extension'};
    
    % Preallocate the results array with zeros
    % Number of rows equals the number of joint motions, columns equal 7 for each piece of data collected
    results = cell(length(jointMotions), 7); % Using cell array to accommodate mixed data types

    % Process each joint motion
    for i = 1:length(jointMotions)
        motionName = jointMotions{i};
        jointData = data.(['RightShoulder' motionName]);

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
    resultsTable = cell2table(results, 'VariableNames', {'Motion', 'Median', 'Min', 'Max', 'PercentFramesRange1', 'PercentFramesRange2', 'PercentFramesRange3'});
    
    % Write table to Excel file
    writetable(resultsTable, 'analysis_results_table.xlsx');

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