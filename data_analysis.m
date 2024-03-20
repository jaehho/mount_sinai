function data_analysis()
    % Read the data from an Excel file
    data = readtable('data.xlsx', 'Sheet', 'Joint Angles ZXY', 'Range', 'W1:Y100');

    % Open a file for writing
    fileID = fopen('analysis_results.txt', 'w');
    
    % Define joint motions to analyze
    jointMotions = {'Abduction_Adduction', 'Internal_ExternalRotation', 'Flexion_Extension'};
    
    % Iterate over each joint motion for analysis
    for i = 1:length(jointMotions)
        motionName = jointMotions{i};
        jointData = data.(['RightShoulder' motionName]);
        
        % Calculate and display statistics
        displayStats(jointData, motionName, fileID);
        
        % Calculate and display ranges
        ranges = calculateRanges(jointData);
        printRanges(ranges, ['Right Shoulder ' strrep(motionName, '_', '/')], fileID);
        
        % Calculate and display frame percentages
        calculateAndDisplayFramePercentages(jointData, ranges, fileID);
    end
    
    % Close the file
    fclose(fileID);
end

function displayStats(jointData, motionName, fileID)
    stats = [median(jointData), min(jointData), max(jointData)];
    custom_fprintf(fileID, '%s - Median: %.2f, Min: %.2f, Max: %.2f\n', ['Right Shoulder ' strrep(motionName, '_', '/')], stats);
end

function ranges = calculateRanges(jointData)
    minVal = min(jointData);
    maxVal = max(jointData);
    step = (maxVal - minVal) / 3;
    ranges = [minVal, minVal + step; minVal + step, minVal + 2*step; minVal + 2*step, maxVal];
end

function printRanges(ranges, motionName, fileID)
    for i = 1:size(ranges, 1)
        custom_fprintf(fileID, '%s Range %d: %.2f to %.2f\n', motionName, i, ranges(i,1), ranges(i,2));
    end
end

function calculateAndDisplayFramePercentages(jointData, ranges, fileID)
    totalFrames = length(jointData);
    for i = 1:size(ranges, 1)
        count = sum(jointData >= ranges(i,1) & jointData <= ranges(i,2));
        percentFrames = count / totalFrames * 100;
        custom_fprintf(fileID, 'Percent of frames in Range %d: %.2f%%\n', i, percentFrames);
    end
end

function custom_fprintf(fileID, varargin)
    fprintf(fileID, varargin{:});
    fprintf(varargin{:});
end