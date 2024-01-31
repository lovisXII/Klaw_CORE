# Function to translate csr address into csr register name
def get_csr_name(address):
    register_map = {
        "0xF14": "mhartid",
        "0xF11": "menvord",
        "0xF12": "marchid",
        "0xF13": "mimpid",
        "0x300": "mstatus",
        "0x301": "misa",
        "0x304": "mie",
        "0x305": "c773_mtvec",
        "0x310": "mstatush",
        "0x341": "mepc",
        "0x342": "mcause",
        "0x343": "mtval",
        "0x344": "mip",
        "0x340": "c832_mscratch"
    }

    return register_map.get(address, "Unknown")

# Function to read and process file one
def process_sim_file(file_path):
    sim_log = []

    try:
        with open(file_path, 'r') as file:
            for line in file:
                # Split the line and extract values
                parts = line.strip().split(', ')
                if len(parts) < 2:  # if nop instruction, skip
                    continue

                elif len(parts) > 3: # for read and write csr instruction
                    pc_str, register_str, data_str, csr_adr, csr_data = parts
                    pc = pc_str.split(': ')[1]
                    register = register_str.split(': ')[1]
                    data = data_str.split(': ')[1]
                    csr_adr = csr_adr.split(': ')[1]
                    csr_data = csr_data.split(': ')[1]
                    # Create a FileOneEntry object and add to the list
                    sim_log.append([pc, register, data, get_csr_name(csr_adr), csr_data])
                else :
                    pc_str, register_str, data_str = parts
                    pc = pc_str.split(': ')[1]
                    register = register_str.split(': ')[1]
                    data = data_str.split(': ')[1]
                    # Create a FileOneEntry object and add to the list
                    if len(register) == 5:  # if the destination is a csr register
                        sim_log.append([pc, get_csr_name(register), data])
                    else:
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
                if line_number % 2 == 0 or line_number < 10:
                    continue

                parts = line.strip().split()

                # Check if the line is related to memory writes
                if "mem" in parts:
                    if (len(parts) == 9 ):
                        pc = parts[3]
                        register = parts[5]
                        data = parts[6]
                    else :
                        pc = parts[3]
                        register = parts[6]
                        data = parts[7]
                elif (len(parts) == 5):
                    continue
                elif "exception" in parts :
                    pc = parts[5]
                    register = parts[4]
                    data = parts[5]
                elif (len(parts) == 9):
                    pc = parts[3]
                    register = parts[5]
                    data = parts[6]
                    csr = parts[7]
                    data_csr = parts[8]
                else :
                    pc = parts[3]
                    register = parts[-2]
                    data = parts[-1]

                # Create a list with pc, register, and data and add to the entries list
                if (len(parts) == 9 ):
                    entry = [pc, register, data, csr, data_csr]
                else :
                    entry = [pc, register, data]
                entries.append(entry)

    except FileNotFoundError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

    return entries

    return sim_log
# Example usage
file1 = 'sim.log'
file2 = 'spike.log'
data_sim   = process_sim_file(file1)
data_model = process_model_file(file2)
error = 0

for i in range(len(data_sim)):
    if (len(data_sim[i]) == 5 and len(data_model[i]) == 5 ):
        if data_sim[i][0] != data_model[i][0] or data_sim[i][1] != data_model[i][1] or data_sim[i][2] != data_model[i][2]or data_sim[i][3] != data_model[i][3] or data_sim[i][4] != data_model[i][4]:
            error = 1
            print("Missmatch in registers detected")
            print("---------------------------------------------------------")
            print("Pc found                      : {}".format(data_sim[i][0]))
            print("Expected pc                   : {}".format(data_model[i][0]))
            print("Destination found register    : {}".format(data_sim[i][1]))
            print("Destination register expected : {}".format(data_model[i][1]))
            print("Destination written           : {}".format(data_sim[i][2]))
            print("Destination written expected  : {}".format(data_model[i][2]))
            print("---------------------------------------------------------")
            print("Destination found csr register    : {}".format(data_sim[i][3]))
            print("Destination csr register expected : {}".format(data_model[i][3]))
            print("Destination written           : {}".format(data_sim[i][4]))
            print("Destination written expected  : {}".format(data_model[i][4]))
            print("---------------------------------------------------------")
            break
    else :

        if data_sim[i][0] != data_model[i][0] or data_sim[i][1] != data_model[i][1] or data_sim[i][2] != data_model[i][2]:
            error = 1
            if "0x" in data_model[i][1] :
                print("Missmatch in memory detected")
                print("---------------------------------------------------------")
                print("Pc found                      : {}".format(data_sim[i][0]))
                print("Expected pc                   : {}".format(data_model[i][0]))
                print("Destination found             : {}".format(data_sim[i][1]))
                print("Destination expected          : {}".format(data_model[i][1]))
                print("Destination written           : {}".format(data_sim[i][2]))
                print("Destination written expected  : {}".format(data_model[i][2]))
                print("---------------------------------------------------------")
            else :
                print("Missmatch in registers detected")
                print("---------------------------------------------------------")
                print("Pc found                      : {}".format(data_sim[i][0]))
                print("Expected pc                   : {}".format(data_model[i][0]))
                print("Destination found register    : {}".format(data_sim[i][1]))
                print("Destination register expected : {}".format(data_model[i][1]))
                print("Destination written           : {}".format(data_sim[i][2]))
                print("Destination written expected  : {}".format(data_model[i][2]))
                print("---------------------------------------------------------")
            break

if error == 0 :
    print("Checker ran without errors")