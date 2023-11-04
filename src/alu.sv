import riscv_pkg::*;

module alu
(
    //----------------------------------------
    // Inputs
    //----------------------------------------
    input  logic[XLEN:0]           rs1_data_i,
    input  logic[XLEN:0]           rs2_data_i,
    input  logic                   alu_en_i,
    input  logic[NB_OPERATION-1:0] cmd_i,
    //----------------------------------------
    // Outputs
    //----------------------------------------
    output logic[XLEN-1:0]         data_o
);

logic[XLEN:0] addition_res;

// Output selection
assign addition_res = rs1_data_i + rs2_data_i;
assign data_o = {XLEN{alu_en_i     & cmd_i[ADD]}} & addition_res[XLEN-1:0] // add
              | {XLEN{alu_en_i     & cmd_i[SLT]}} & {31'b0, addition_res[XLEN]}
              | {XLEN{alu_en_i     & cmd_i[AND]}} & (rs1_data_i[XLEN-1:0] & rs2_data_i[XLEN-1:0]) // and
              | {XLEN{alu_en_i     & cmd_i[OR]}}  & (rs1_data_i[XLEN-1:0] | rs2_data_i[XLEN-1:0]) // or
              | {XLEN{alu_en_i     & cmd_i[XOR]}} & (rs1_data_i[XLEN-1:0] ^ rs2_data_i[XLEN-1:0]);
endmodule