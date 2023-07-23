import riscv::*;

module alu
(
    input  logic[XLEN-1:0]          rs1_data_i,
    input  logic[XLEN-1:0]          rs2_data_i,
    input  logic                    alu_en_i,
    input  logic[NB_OPERATION-1:0]  cmd_i,
    output logic[XLEN-1:0]          data_o
);

// Output selection
assign data_o = {XLEN{alu_en_i     & (cmd_i[ADD] | cmd_i[SLT])}} & (rs1_data_i + rs2_data_i) // add / slt
              | {XLEN{alu_en_i     & cmd_i[AND]}}                & (rs1_data_i & rs2_data_i) // and
              | {XLEN{alu_en_i     & cmd_i[OR]}}                 & (rs1_data_i | rs2_data_i) // or
              | {XLEN{alu_en_i     & cmd_i[XOR]}}                & (rs1_data_i ^ rs2_data_i);
endmodule