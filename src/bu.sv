import riscv_pkg::*;

module bu
(
    //----------------------------------------
    // Inputs
    //----------------------------------------
    input  logic[XLEN:0]            rs1_data_i,
    input  logic[XLEN:0]            rs2_data_i,
    input   logic                   unsign_cmp_i,
    input  logic[XLEN-1:0]          immediat_i,
    input  logic[XLEN-1:0]          pc_data_i,
    input  logic                    bu_en_i,
    input  logic[NB_OPERATION-1:0]  cmd_i,
    //----------------------------------------
    // Outputs
    //----------------------------------------
    output logic                    branch_v_o,
    output logic[XLEN-1:0]          pc_nxt_o,
    output logic                    pc_missaligned_o,
    output logic[XLEN-1:0]          data_o
);
// Output selection
logic            data_eq;
logic            branch_v;
logic [XLEN:0]   addition_res;
logic [XLEN:0]   pc_nxt;

// Perform rs1 - rs2
// addition_res[XLEN] = 1 <=> rs1 - rs2 < 0 <=> rs1 < rs2
assign data_eq      = ~|(rs1_data_i[XLEN:0] ^ rs2_data_i[XLEN:0]);
assign addition_res = rs1_data_i + rs2_data_i;

assign branch_v = bu_en_i & (
                  cmd_i[BEQ] &  data_eq                                          // beq
                | cmd_i[BNE] & ~data_eq                                          // bne
                | cmd_i[BLT] &   addition_res[XLEN]                              // blt
                | cmd_i[BGE] & (~addition_res[XLEN]  | (unsign_cmp_i & data_eq)) // bge
                | cmd_i[JAL] | cmd_i[JALR]                                       // jal jalr
                );

assign branch_v_o       = branch_v;
assign data_o           = pc_data_i + 32'd4;
assign pc_nxt           = {XLEN{branch_v & ~cmd_i[JALR]}}  & pc_data_i  + immediat_i
                        | {XLEN{branch_v &  cmd_i[JALR]}}  & rs1_data_i[XLEN-1:0] + immediat_i;
assign pc_nxt_o         = pc_nxt;
assign pc_missaligned_o = pc_nxt[0] | pc_nxt[1];
endmodule