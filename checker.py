import re
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

MEM_REGEX = r'mem'
CSR_REGEX = r'c\d+\_\w+'
WBK_REGEX = r'x\d(|\d)\b'

def mem_v(line):
    pattern = MEM_REGEX
    return bool(re.search(pattern, line))

def csr_v(line) :
    pattern = CSR_REGEX
    return bool(re.search(pattern, line))

def wbk_v(line) :
    pattern = WBK_REGEX
    return bool(re.search(pattern, line))

def line_empty(line) :
    return True if not wbk_v(line) and not csr_v(line) and not mem_v(line) else False

def index(my_list, regex, incr = 0) :
    pattern = re.compile(regex)
    index = next((i for i, item in enumerate(my_list) if pattern.match(item)), None)
    if index is not None :
        return index + incr
    else :
        return 0

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
                    parts = line.strip().split()
                    # Extend to at least 9 elements with None
                    # Used to avoid index out of range
                    while len(parts) < 9:
                        parts.append("None")
                    if line_number < 5 or line_empty(line):
                        continue
                    else :
                        # Check if the line is related to memory writes
                        pc       = parts[3]
                        register = parts[5] if wbk_v(line) else \
                                 "None"
                        data     = parts[6] if wbk_v(line) else \
                                 "None"
                        mem_adr  = parts[index(parts, MEM_REGEX, 1)] if mem_v(line) else \
                                 "None"
                        mem_data = parts[index(parts, MEM_REGEX, 2)] if mem_v(line) else \
                                 "None"
                        csr      = parts[index(parts, CSR_REGEX)] if csr_v(line) else \
                                 "None"
                        data_csr = parts[index(parts, CSR_REGEX, 1)] if csr_v(line) else \
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

