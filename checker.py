# Function to translate csr address into csr register name
def get_csr_adr(name):
    register_map = {
        "mhartid"      : "0xF14",
        "menvord"      : "0xF11",
        "marchid"      : "0xF12",
        "mimpid"       : "0xF13",
        "mstatus"      : "0x300",
        "c768_mstatus" : "0x300",
        "misa"         : "0x301",
        "mie"          : "0x304",
        "c773_mtvec"   : "0x305",
        "mstatush"     : "0x310",
        "mepc"         : "0x341",
        "c833_mepc"    : "0x341",
        "mcause"       : "0x342",
        "mtval"        : "0x343",
        "mip"          : "0x344",
        "c832_mscratch": "0x340"
    }

    return register_map.get(name, "None")

def is_csr(line):
    csr_instructions = ["csrr", "csrw", "csrrwi", "csrrci", "mret"]
    return any(instruction in line for instruction in csr_instructions)


def is_load(line):
    csr_instructions = ["lw", "lh", "lhu", "lb", "lbu"]
    return any(instruction in line for instruction in csr_instructions)

def is_store(line):
    csr_instructions = ["sw", "sh", "sb"]
    return any(instruction in line for instruction in csr_instructions)

def is_exception(line) :
    return True if "exception" in line else False

def is_arith(line) :
    return True if not is_csr(line) and not is_load(line) and not is_store(line) and not is_exception(line) else False

def rd_v(line) :
    csr_rd   = ["csrrwi", "csrr"]
    csr_rd_v = any(instruction in line for instruction in csr_rd)
    return True if csr_rd_v or is_load(line) or is_arith(line) else False


# Function to read and process file one
def process_sim_file(file_path):
    sim_log = []

    try:
        with open(file_path, 'r') as file:
            for line in file:
                # Split the line and extract values
                line_data = line.strip().split(';')
                line_data = [str(item) for item in line_data]
                sim_log.append(line_data)
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
                # Store previus line
                if line_number % 2 == 0 or line_number < 10:
                    prev_line = line
                else :
                    parts = line.strip().split()
                    # Extend to at least 9 elements with None
                    # Used to avoid index out of range
                    while len(parts) < 9:
                        parts.append("None")
                    # print(parts)
                    # Check if the line is related to memory writes
                    pc       = parts[3]
                    register = parts[5] if rd_v(prev_line) else \
                               "None"
                    data     = parts[6] if rd_v(prev_line) else \
                               "None"
                    mem_adr  = parts[6] if is_store(prev_line) else \
                               parts[8] if is_load(prev_line) else \
                               "None"
                    mem_data = parts[7] if is_store(prev_line) else \
                               "None"
                    csr      = parts[5] if "csrw" in prev_line or "mret" in prev_line else \
                               parts[7] if "csrrwi" in prev_line or "csrrci" in prev_line else \
                               "None"
                    data_csr = parts[8] if "csrrwi" in prev_line or "csrrci" in prev_line else \
                               parts[6] if "csrw" in prev_line or "mret" in prev_line else  \
                               "None"
                    entry = [pc, register, data, mem_adr, mem_data, get_csr_adr(csr), data_csr]
                    # print(entry)
                    # if line_number == 27 :
                    #     exit(1)
                    entries.append(entry)

    except FileNotFoundError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

    return entries

if __name__ == "__main__" :
    file1 = 'sim.log'
    file2 = 'spike.log'
    data_model = process_model_file(file2)
    data_sim   = process_sim_file(file1)
    error = 0
    index = -1

    for elem_sim, elem_model in zip(data_sim, data_model) :
        index += 1
        for i in range(len(elem_sim)) :
            if elem_sim[i] != elem_model[i] :
                print("Missmatch in registers detected")
                print(elem_sim)
                print(elem_model)
                print("Sim   : {}".format(elem_sim[i]))
                print("Model : {}".format(elem_model[i]))
                error = 1
                break
        if error == 1:
            break  # Exit the outer loop if a mismatch is found

    if error == 0 :
        print("Checker ran without errors")
    else :
        print("---Full log :---")
        print("PC sim                    : ", data_sim  [index][0])
        print("PC model                  : ", data_model[index][0])
        print("rd sim                    : ", data_sim  [index][1])
        print("rd model                  : ", data_model[index][1])
        print("data sim                  : ", data_sim  [index][2])
        print("data model                : ", data_model[index][2])
        print("mem_adr sim               : ", data_sim  [index][3])
        print("mem_adr model             : ", data_model[index][3])
        print("mem_data sim              : ", data_sim  [index][4])
        print("mem_data model            : ", data_model[index][4])
        print("csr sim                   : ", data_sim  [index][5])
        print("csr model                 : ", data_model[index][5])
        print("csr_data sim              : ", data_sim  [index][6])
        print("csr_data model            : ", data_model[index][6])

