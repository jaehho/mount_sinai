jointData = readtable('data.xlsx', 'Sheet', 'Joint Angles ZXY'); 

jointMotions = jointData.Properties.VariableNames(2:end)

writecell(jointMotions, 'jointMotions.csv');

segmentData = readtable('data.xlsx', 'Sheet', 'Segment Angular Velocity'); 

jointMotions = segmentData.Properties.VariableNames(2:end)

writecell(jointMotions, 'segmentMotions.csv');
