import csv
import pandas as pd

# jointData = pd.read_excel('data.xlsx', sheet_name='Joint Angles ZXY')
# jointMotions = jointData.columns[1:]
# segmentData = pd.read_excel('data.xlsx', sheet_name='Segment Angular Velocity')
# segmentMotions = segmentData.columns[1:]

def csv_reader(csv_file_path):
    # Open the CSV file
    with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
        # Create a CSV reader object
        csvreader = csv.reader(csvfile)
        
        # Iterate over each row in the CSV file
        for row in csvreader:
            # 'row' is a list of fields in the current row
            # You can process each 'row' as needed; here, we simply print it
            return row

def find_common_prefix(str1, str2):
    """Find the longest common prefix between two strings."""
    i = 0
    while i < min(len(str1), len(str2)) and str1[i] == str2[i]:
        i += 1
    return str1[:i]

def group_values(values):
    grouped_values = []
    current_group = [values[0]]
    last_prefix = values[0]
    previous_value = ''

    for value in values:
        common_prefix = find_common_prefix(previous_value, value)
        
        if value.startswith(last_prefix):
            current_group.append(value)
        else:
            # Join the current group's values, append ellipsis for a new group, and start a new group
            grouped_values.append(",".join(current_group) + "...")
            current_group = [value]

        last_prefix = common_prefix
        previous_value = value
    # Add the last group without an ellipsis at the end
    grouped_values.append(",".join(current_group))

    return "\n".join(grouped_values)

def process_motion_data(input_file_name, output_file_name):
    motion_data = csv_reader(input_file_name)

    grouped_str = group_values(motion_data)
    
    # Write the processed data to the output file.
    with open(output_file_name, 'w', encoding='utf-8') as file:
        file.writelines(grouped_str)

    print(f"Processed data written to {output_file_name}")

process_motion_data('jointAngles.csv', 'ellipsedJointMotions.txt')
process_motion_data('segmentVelocities.csv', 'ellipsedSegmentMotions.txt')