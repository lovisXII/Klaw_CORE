spike = 'spike.log'
result = 'result.log'

with open(spike, 'r') as file:
    # read spike log lines
    lignes_log = file.readlines()
# select one line over two
selected_lines = lignes_log[1::2] 

with open(result, 'w') as output_file:
    # write those lines in the result file 
    output_file.writelines(selected_lines)


