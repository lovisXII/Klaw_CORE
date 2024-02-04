spike = 'spike.log'
test = 'sw/tests/I/add/add_0.S'
veri = 'a.out.txt.s'
result = 'result.log'



def find_start(test):
    with open(test, 'r') as file:
        lignes = file.readlines()

    for i, ligne in enumerate(lignes):
            if '<_start>:' in ligne:
                pc = ligne.split()[0] 
                return pc
    return -1

def find_exit(test):
    with open(test, 'r') as file:
        lignes = file.readlines()

    for i, ligne in enumerate(lignes):
            if '<_exit>:' in ligne:
                pc = ligne.split()[0] 
                return pc
    return -1

def result_log(spike,start_,exit_):
    with open(spike, 'r') as file:
        # read spike log lines
        lignes_log = file.readlines()
    
    #add "0x" behind the pc values
    start_ = f'0x{start_.lower()}'
    exit_ = f'0x{exit_.lower()}'

    #search pc in the spike log
    for i, ligne in enumerate(lignes_log):
        raws = ligne.split()
        # search for the start pc value in the 3nd row
        if len(raws) > 2 and raws[2] == start_:
            with open(result, 'w') as output_file:
                # write one line over two from this line 
                for j in range(i + 1, len(lignes_log), 2):
                    cols = lignes_log[j].split()
                    if len(cols) >= 7:
                        # output_file.write(f"{cols[3]} la taille de cols {len(cols)}\n")
                        output_file.write(f"Cycle : x, register : {cols[5]} data : {cols[6]}\n")
                        # break if exit_ found
                        if cols[3] >= exit_:
                            break

            print(f"Results are written with success.")
            return
     

   

    



start_ = find_start(veri)
exit_= find_exit(veri)

if start_ != -1 and exit_ != -1:
    print(f"start found at: {start_}\n")
    print(f"exit found at: {exit_}\n")
    result_log(spike,start_,exit_)
    
else:
    print("tags not found.")