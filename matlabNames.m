jointData = readtable('data.xlsx', 'Sheet', 'Joint Angles ZXY'); 

jointAngles = jointData.Properties.VariableNames(2:end)

writecell(jointAngles, 'jointAngles.csv');

segmentData = readtable('data.xlsx', 'Sheet', 'Segment Angular Velocity'); 

segmentVelocities = segmentData.Properties.VariableNames(2:end)

writecell(segmentVelocities, 'segmentVelocities.csv');
