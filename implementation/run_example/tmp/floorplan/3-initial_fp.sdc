###############################################################################
# Created by write_sdc
# Sat Nov  4 13:53:41 2023
###############################################################################
current_design core
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[10]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[11]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[12]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[13]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[14]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[15]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[16]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[17]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[18]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[19]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[20]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[21]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[22]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[23]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[24]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[25]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[26]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[27]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[28]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[29]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[30]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[31]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[4]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[5]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[6]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[7]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[8]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_instr_i[9]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[10]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[11]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[12]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[13]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[14]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[15]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[16]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[17]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[18]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[19]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[20]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[21]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[22]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[23]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[24]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[25]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[26]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[27]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[28]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[29]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[30]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[31]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[4]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[5]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[6]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[7]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[8]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {load_data_i[9]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[10]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[11]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[12]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[13]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[14]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[15]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[16]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[17]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[18]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[19]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[20]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[21]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[22]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[23]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[24]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[25]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[26]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[27]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[28]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[29]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[30]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[31]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[4]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[5]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[6]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[7]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[8]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_adr_i[9]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_n}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {access_size_o[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {access_size_o[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {access_size_o[2]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[10]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[11]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[12]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[13]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[14]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[15]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[16]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[17]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[18]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[19]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[20]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[21]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[22]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[23]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[24]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[25]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[26]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[27]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[28]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[29]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[2]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[30]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[31]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[3]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[4]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[5]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[6]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[7]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[8]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_o[9]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {adr_v_o}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[10]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[11]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[12]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[13]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[14]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[15]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[16]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[17]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[18]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[19]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[20]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[21]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[22]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[23]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[24]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[25]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[26]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[27]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[28]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[29]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[2]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[30]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[31]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[3]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[4]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[5]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[6]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[7]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[8]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {icache_adr_o[9]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {is_store_o}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[10]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[11]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[12]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[13]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[14]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[15]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[16]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[17]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[18]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[19]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[20]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[21]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[22]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[23]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[24]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[25]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[26]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[27]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[28]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[29]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[2]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[30]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[31]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[3]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[4]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[5]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[6]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[7]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[8]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {store_data_o[9]}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {adr_v_o}]
set_load -pin_load 0.0334 [get_ports {is_store_o}]
set_load -pin_load 0.0334 [get_ports {access_size_o[2]}]
set_load -pin_load 0.0334 [get_ports {access_size_o[1]}]
set_load -pin_load 0.0334 [get_ports {access_size_o[0]}]
set_load -pin_load 0.0334 [get_ports {adr_o[31]}]
set_load -pin_load 0.0334 [get_ports {adr_o[30]}]
set_load -pin_load 0.0334 [get_ports {adr_o[29]}]
set_load -pin_load 0.0334 [get_ports {adr_o[28]}]
set_load -pin_load 0.0334 [get_ports {adr_o[27]}]
set_load -pin_load 0.0334 [get_ports {adr_o[26]}]
set_load -pin_load 0.0334 [get_ports {adr_o[25]}]
set_load -pin_load 0.0334 [get_ports {adr_o[24]}]
set_load -pin_load 0.0334 [get_ports {adr_o[23]}]
set_load -pin_load 0.0334 [get_ports {adr_o[22]}]
set_load -pin_load 0.0334 [get_ports {adr_o[21]}]
set_load -pin_load 0.0334 [get_ports {adr_o[20]}]
set_load -pin_load 0.0334 [get_ports {adr_o[19]}]
set_load -pin_load 0.0334 [get_ports {adr_o[18]}]
set_load -pin_load 0.0334 [get_ports {adr_o[17]}]
set_load -pin_load 0.0334 [get_ports {adr_o[16]}]
set_load -pin_load 0.0334 [get_ports {adr_o[15]}]
set_load -pin_load 0.0334 [get_ports {adr_o[14]}]
set_load -pin_load 0.0334 [get_ports {adr_o[13]}]
set_load -pin_load 0.0334 [get_ports {adr_o[12]}]
set_load -pin_load 0.0334 [get_ports {adr_o[11]}]
set_load -pin_load 0.0334 [get_ports {adr_o[10]}]
set_load -pin_load 0.0334 [get_ports {adr_o[9]}]
set_load -pin_load 0.0334 [get_ports {adr_o[8]}]
set_load -pin_load 0.0334 [get_ports {adr_o[7]}]
set_load -pin_load 0.0334 [get_ports {adr_o[6]}]
set_load -pin_load 0.0334 [get_ports {adr_o[5]}]
set_load -pin_load 0.0334 [get_ports {adr_o[4]}]
set_load -pin_load 0.0334 [get_ports {adr_o[3]}]
set_load -pin_load 0.0334 [get_ports {adr_o[2]}]
set_load -pin_load 0.0334 [get_ports {adr_o[1]}]
set_load -pin_load 0.0334 [get_ports {adr_o[0]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[31]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[30]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[29]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[28]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[27]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[26]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[25]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[24]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[23]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[22]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[21]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[20]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[19]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[18]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[17]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[16]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[15]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[14]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[13]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[12]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[11]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[10]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[9]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[8]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[7]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[6]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[5]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[4]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[3]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[2]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[1]}]
set_load -pin_load 0.0334 [get_ports {icache_adr_o[0]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[31]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[30]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[29]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[28]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[27]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[26]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[25]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[24]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[23]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[22]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[21]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[20]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[19]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[18]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[17]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[16]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[15]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[14]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[13]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[12]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[11]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[10]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[9]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[8]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[7]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[6]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[5]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[4]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[3]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[2]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[1]}]
set_load -pin_load 0.0334 [get_ports {store_data_o[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_n}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[31]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[30]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[29]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[28]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[27]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[26]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[25]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[24]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[23]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[22]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[21]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[20]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[19]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[18]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[17]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[16]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[15]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[14]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[13]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[12]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[11]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[10]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[9]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[8]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[7]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[6]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {icache_instr_i[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[31]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[30]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[29]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[28]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[27]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[26]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[25]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[24]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[23]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[22]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[21]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[20]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[19]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[18]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[17]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[16]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[15]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[14]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[13]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[12]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[11]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[10]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[9]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[8]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[7]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[6]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {load_data_i[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[31]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[30]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[29]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[28]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[27]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[26]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[25]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[24]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[23]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[22]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[21]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[20]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[19]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[18]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[17]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[16]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[15]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[14]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[13]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[12]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[11]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[10]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[9]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[8]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[7]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[6]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset_adr_i[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_fanout 10.0000 [current_design]
