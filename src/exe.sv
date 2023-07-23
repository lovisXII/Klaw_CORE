module exe #(parameter int bitWidth = 32)
(
%% for i in range(1):
  // Registers
    // Destination 
  input logic                       line{<i>}_rd_v_i, 
  input logic [4:0]                 line{<i>}_rd_i, 
    // Source 1
  input logic                       line{<i>}_rs1_v_i,
  input logic [XLEN-1:0]            line{<i>}_rs1_data_i, 
    // Source 2
  input logic                       line{<i>}_rs2_v_i, 
  input logic [XLEN-1:0]            line{<i>}_rs2_data_i,  
  // Additionnal informations
  input logic                       line{<i>}_is_store_i,        
  input logic                       line{<i>}_is_load_i,          
  input logic                       line{<i>}_is_branch_i,         
  input logic [31:0]                line{<i>}_immediat_i,
  input logic [2:0]                 line{<i>}_access_size_i,
  input logic [12:0]                line{<i>}_instr_type_i,
  input logic                       line{<i>}_unsign_extension_i,
  input logic [NBR_UNIT-1:0]        line{<i>}_unit_i,
  input logic [NBR_OPERATION-1:0]   line{<i>}_operation_i
%% endfor
);

%% for unit in range(1)
logic [XLEN-1:0] line{<unit>}_op1_data;
logic [XLEN-1:0] line{<unit>}_op2_data;
logic [XLEN-1:0] line{<unit>}_cmd;
logic [XLEN-1:0] line{<unit>}_res_data;
%% endfor

%% for unit in range(1)
assign line{<unit>}_op1_data = {XLEN{line{<unit>}_rs1_v_i}} & line{<unit>}_rs1_data_i;
assign line{<unit>}_op2_data = {XLEN{line{<unit>}_rs2_v_i}} & line{<unit>}_rs2_data_i;
%% endfor

%% for unit in range(1)
ALU #(.bitWidth(bitWidth)) 
alu(
    .rs1_data_i     (line{<unit>}_op1_data),
    .rs2_data_i     (line{<unit>}_op2_data),
    .Cin_i          (Cin),
    .cmd_i          (aluCmd),
    .data_o         (aluOut)
);
Shifter #(.bitWidth(bitWidth)) 
shifter(
    .data_i        (line{<unit>}_op1_data),
    .shift_value_i (line{<unit>}_op2_data),
    .cmd_i         (shiftCmd),
    .data_o        (shifterOut)
);
%% endfor


endmodule
