spike = 'spike.log'
test = 'sw/tests/I/add/add_0.S'
veri = 'a.out.txt.s'
result = 'result.log'



def find_pc_val(test):
    with open(test, 'r') as file:
        lignes = file.readlines()

    for i, ligne in enumerate(lignes):
            if '<_start>:' in ligne:
                pc = ligne.split()[0] 
                return pc
    return -1

def find_start(spike,pc):
    with open(spike, 'r') as file:
        # read spike log lines
        lignes_log = file.readlines()
    
    pc = f'0x{pc.lower()}'

    #search pc in the spike log
    for i, ligne in enumerate(lignes_log):
        raws = ligne.split()
        if len(raws) > 2 and raws[2] == pc:
            with open(result, 'w') as output_file:
                # write those lines in the result file 
                for j in range(i, len(lignes_log), 2):
                    cols = lignes_log[j].split()
                    # data = raws[4:7]
                    # output_file.write(' '.join(data) + '\n')
                    output_file.write(f"Cycle : x, register : {cols[5]} data : {cols[6]}\n")

            print(f"Les lignes ont été écrites dans result.")
            return
     

   

    



pc = find_pc_val(veri)

if pc != -1:
    print(f"pc = {pc}")
    find_start(spike,pc)
    
else:
    print("start not found.")