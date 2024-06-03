#! /usr/bin/env python3.10
import re
from termcolor import colored
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
    """
    Finds the index of the first item in the list that matches the given regex pattern.

    Args:
        my_list (list): The list of strings to search through.
        regex (str): The regular expression pattern to match.
        incr (int, optional): The value to add to the found index. Defaults to 0.

    Returns:
        int: The index of the first matching item plus the increment. Returns 0 if no match is found.
    """
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
                    if line_number < 5 :
                        continue
                    else :
                        # Check if the line is related to memory writes
                        pc       = parts[3]
                        register = parts[5] if wbk_v(line) else \
                                 "None"
                        data     = parts[6] if wbk_v(line) else \
                                 "None"
                        # If idx is the index where "mem" is :
                        # * at idx + 1 there is address
                        # * at idx + 2 there is the data
                        # But sometimes there is no memory access
                        # In order to avoid overflow we check the
                        # idx of the stored data is < lenght
                        # to avoid overflow
                        mem_adr  = parts[index(parts, MEM_REGEX, 1)] if mem_v(line) else \
                                 "None"

                        index_stored_data = index(parts, MEM_REGEX, 2)
                        if index_stored_data < len(parts) :
                            mem_data = parts[index_stored_data] if mem_v(line) else \
                                     "None"
                        else :
                            mem_data = "None"

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
    return entries

def run_checker() :
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
                print("--------------------------------------------")
                print("Missmatch in registers detected")
                print(elem_sim)
                print(elem_model)
                print("Sim   : {}".format(elem_sim[i]))
                print("Model : {}".format(elem_model[i]))
                print("--------------------------------------------")
                error = 1
                break
        if error == 1:
            break  # Exit the outer loop if a mismatch is found

    if error == 0 :
        print(colored("[INFO]", "green"), "Checker ran without errors")
    else :
        print(colored("[ERROR]", "red"), "Missmatch detected")
        print("-------------- Simulation ------------------------")
        print("PC                   : ", data_sim  [index][0])
        print("rd                   : ", data_sim  [index][1])
        print("data                 : ", data_sim  [index][2])
        print("mem_adr              : ", data_sim  [index][3])
        print("mem_data             : ", data_sim  [index][4])
        print("csr                  : ", data_sim  [index][5])
        print("csr_data             : ", data_sim  [index][6])
        print("----------------  Model  -------------------------")
        print("PC                   : ", data_model[index][0])
        print("rd                   : ", data_model[index][1])
        print("data                 : ", data_model[index][2])
        print("mem_adr              : ", data_model[index][3])
        print("mem_data             : ", data_model[index][4])
        print("csr                  : ", data_model[index][5])
        print("csr_data             : ", data_model[index][6])

if __name__ == "__main__" :
    run_checker()