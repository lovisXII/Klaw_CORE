import riscv_pkg::*;

module shifter
(
    //----------------------------------------
    // Inputs
    //----------------------------------------
    input  logic[XLEN-1:0]          rs1_data_i,
    input  logic[XLEN-1:0]          rs2_data_i,
    input  logic                    shifter_en_i,
    input  logic[NB_OPERATION-1:0]  cmd_i,
    //----------------------------------------
    // Outputs
    //----------------------------------------
    output logic[XLEN-1:0]          data_o
);
// --------------------------------
//      Signals declaration
// --------------------------------
logic [XLEN-1:0]    l_shift16;
logic [XLEN-1:0]    l_shift8;
logic [XLEN-1:0]    l_shift4;
logic [XLEN-1:0]    l_shift2;
logic [XLEN-1:0]    l_shift1;

logic [XLEN-1:0]    r_shift16;
logic [XLEN-1:0]    r_shift8;
logic [XLEN-1:0]    r_shift4;
logic [XLEN-1:0]    r_shift2;
logic [XLEN-1:0]    r_shift1;

logic               sign_extension;

// Sign extension for SRA
assign sign_extension  = rs1_data_i[XLEN-1] & cmd_i[SRA];

// Shift right
assign r_shift16 = {XLEN{ rs2_data_i[4]}} & {{16{sign_extension}}, rs1_data_i[XLEN-1:16]}
                 | {XLEN{~rs2_data_i[4]}} & rs1_data_i;

assign r_shift8  = {XLEN{ rs2_data_i[3]}} & { {8{sign_extension}}, r_shift16[XLEN-1:8]}
                 | {XLEN{~rs2_data_i[3]}} & r_shift16;

assign r_shift4  = {XLEN{ rs2_data_i[2]}} & { {4{sign_extension}}, r_shift8 [XLEN-1:4]}
                 | {XLEN{~rs2_data_i[2]}} & r_shift8;

assign r_shift2  = {XLEN{ rs2_data_i[1]}} & { {2{sign_extension}}, r_shift4 [XLEN-1:2]}
                 | {XLEN{~rs2_data_i[1]}} & r_shift4;

assign r_shift1  = {XLEN{ rs2_data_i[0]}} & {   sign_extension, r_shift2 [XLEN-1:1]}
                 | {XLEN{~rs2_data_i[0]}} & r_shift2;

// Shift left
assign l_shift16 = {XLEN{ rs2_data_i[4]}} & {rs1_data_i[15:0], {16{sign_extension}}}
                 | {XLEN{~rs2_data_i[4]}} & rs1_data_i;

assign l_shift8  = {XLEN{ rs2_data_i[3]}} & {l_shift16[23:0], {8{sign_extension}}}
                 | {XLEN{~rs2_data_i[3]}} & l_shift16;

assign l_shift4  = {XLEN{ rs2_data_i[2]}} & {l_shift8[27:0], {4{sign_extension}}}
                 | {XLEN{~rs2_data_i[2]}} & l_shift8;

assign l_shift2  = {XLEN{ rs2_data_i[1]}} & {l_shift4[29:0], {2{sign_extension}}}
                 | {XLEN{~rs2_data_i[1]}} & l_shift4;

assign l_shift1  = {XLEN{ rs2_data_i[0]}} & {l_shift2[30:0],    sign_extension}
                 | {XLEN{~rs2_data_i[0]}} & l_shift2;

// Output selection

assign data_o = {XLEN{shifter_en_i & cmd_i[SLL]}}                & l_shift1
              | {XLEN{shifter_en_i & (cmd_i[SRL] | cmd_i[SRA])}} & r_shift1;

endmodule