import csv

with open('jointMotions.csv', mode='r', encoding='utf-8') as file:
    # Create a CSV reader object
    csv_reader = csv.reader(file)

print(csv_reader)


def find_common_prefix(str1, str2):
    """Find the longest common prefix between two strings."""
    i = 0
    while i < min(len(str1), len(str2)) and str1[i] == str2[i]:
        i += 1
    return str1[:i]

def group_values_without_newlines(values):
    values_list = values.split(",")
    grouped_values = []
    current_group = [values_list[0]]
    current_prefix = values_list[0]

    for value in values_list[1:]:
        common_prefix = find_common_prefix(current_prefix, value)
        if common_prefix and len(common_prefix) > 0:
            current_group.append(value)
            current_prefix = common_prefix
        else:
            # Join the current group's values, append ellipsis for a new group, and start a new group
            grouped_values.append(",".join(current_group) + "\n...")
            current_group = [value]
            current_prefix = value
    # Add the last group without an ellipsis at the end
    grouped_values.append(",".join(current_group))

    return "\n".join(grouped_values)

# Input string with values to be grouped
values_str = "L5S1LateralBending,L5S1AxialBending,L5S1Flexion_Extension,L4L3LateralBending,L4L3AxialRotation,L4L3Flexion_Extension,L1T12LateralBending,L1T12AxialRotation,L1T12Flexion_Extension,T9T8LateralBending,T9T8AxialRotation,T9T8Flexion_Extension,T1C7LateralBending,T1C7AxialRotation,T1C7Flexion_Extension,C1HeadLateralBending,C1HeadAxialRotation,C1HeadFlexion_Extension,RightT4ShoulderAbduction_Adduction,RightT4ShoulderInternal_ExternalRotation,RightT4ShoulderFlexion_Extension,RightShoulderAbduction_Adduction,RightShoulderInternal_ExternalRotation,RightShoulderFlexion_Extension,RightElbowUlnarDeviation_RadialDeviation,RightElbowPronation_Supination,RightElbowFlexion_Extension,RightWristUlnarDeviation_RadialDeviation,RightWristPronation_Supination,RightWristFlexion_Extension,LeftT4ShoulderAbduction_Adduction,LeftT4ShoulderInternal_ExternalRotation,LeftT4ShoulderFlexion_Extension,LeftShoulderAbduction_Adduction,LeftShoulderInternal_ExternalRotation,LeftShoulderFlexion_Extension,LeftElbowUlnarDeviation_RadialDeviation,LeftElbowPronation_Supination,LeftElbowFlexion_Extension,LeftWristUlnarDeviation_RadialDeviation,LeftWristPronation_Supination,LeftWristFlexion_Extension,RightHipAbduction_Adduction,RightHipInternal_ExternalRotation,RightHipFlexion_Extension,RightKneeAbduction_Adduction,RightKneeInternal_ExternalRotation,RightKneeFlexion_Extension,RightAnkleAbduction_Adduction,RightAnkleInternal_ExternalRotation,RightAnkleDorsiflexion_Plantarflexion,RightBallFootAbduction_Adduction,RightBallFootInternal_ExternalRotation,RightBallFootFlexion_Extension,LeftHipAbduction_Adduction,LeftHipInternal_ExternalRotation,LeftHipFlexion_Extension,LeftKneeAbduction_Adduction,LeftKneeInternal_ExternalRotation,LeftKneeFlexion_Extension,LeftAnkleAbduction_Adduction,LeftAnkleInternal_ExternalRotation,LeftAnkleDorsiflexion_Plantarflexion,LeftBallFootAbduction_Adduction,LeftBallFootInternal_ExternalRotation,LeftBallFootFlexion_Extension"

# Process the string to group values
grouped_str_no_newlines = group_values_without_newlines(values_str)
print(grouped_str_no_newlines)
