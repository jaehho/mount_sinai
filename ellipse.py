import csv

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

def group_values_without_newlines(values):
    grouped_values = []
    current_group = [values[0]]
    current_prefix = values[0]

    for value in values[1:]:
        common_prefix = find_common_prefix(current_prefix, value)
        if value.startswith(common_prefix) and len(common_prefix) > 0:
            current_group.append(value)
            current_prefix = common_prefix
        else:
            # Join the current group's values, append ellipsis for a new group, and start a new group
            grouped_values.append(",".join(current_group) + "...")
            current_group = [value]
            current_prefix = value
    # Add the last group without an ellipsis at the end
    grouped_values.append(",".join(current_group))

    return "\n".join(grouped_values)

# Input string with values to be grouped
jointMotions = csv_reader('jointMotions.csv')

# Process the string to group values
grouped_str_no_newlines = group_values_without_newlines(jointMotions)
print(grouped_str_no_newlines)

output_file_path = 'ellipsed.txt'

# Open the file with write ('w') mode
with open(output_file_path, 'w', encoding='utf-8') as file:
    file.writelines(grouped_str_no_newlines)
