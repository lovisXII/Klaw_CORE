# Function to read and process file one
def process_sim_file(file_path):
    entries = []

    try:
        with open(file_path, 'r') as file:
            sim_log = []
            for line in file:
                # Split the line and extract values
                pc_str, register_str, data_str = line.strip().split(', ')
                pc                             = pc_str.split(': ')[1]
                register                       = register_str.split(': ')[1]
                data                           = data_str.split(': ')[1]
                # Create a FileOneEntry object and add to the list
                sim_log.append([pc, register, data])

    except FileNotFoundError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

    return sim_log

def process_model_file(file_path):
    entries = []

    try:
        with open(file_path, 'r') as file:
            sim_log = []

            for line_number, line in enumerate(file):
                # Skip every 1st line
                if line_number % 2 == 0 or line_number < 9:
                    continue
                # Split the line and extract values
                parts    = line.strip().split()
                if len(parts) == 5 :
                    continue
                if "mem" in parts :
                    if parts[5] == "mem" :
                        continue
                    else :
                        pc       = parts[3]
                        register = parts[5]
                        data     = parts[6]
                else :
                    pc       = parts[3]
                    register = parts[-2]
                    data     = parts[-1]
                # Create a list with pc, register, and data and add to the entries list
                entry = [pc, register, data]
                entries.append(entry)

    except FileNotFoundError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

    return entries

    return sim_log
# Example usage
file1 = 'register_values.txt'
file2 = 'spike.log'
data_sim   = process_sim_file(file1)
data_model = process_model_file(file2)
for i in range(len(data_sim)):
    if data_sim[i][0] != data_model[i][0] or data_sim[i][1] != data_model[i][1] or data_sim[i][2] != data_model[i][2]:
        print("Missmatch detected")
        print("---------------------------------------------------------")
        print("Pc found                      : {}".format(data_sim[i][0]))
        print("Expected pc                   : {}".format(data_model[i][0]))
        print("Destination found register    : {}".format(data_sim[i][1]))
        print("Destination register expected : {}".format(data_model[i][1]))
        print("Destination written           : {}".format(data_sim[i][2]))
        print("Destination written expected  : {}".format(data_model[i][2]))
        print("---------------------------------------------------------")
        break