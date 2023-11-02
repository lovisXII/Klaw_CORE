// The branch unit must be able to execute the following operation :
// * Check if the data of rs1 and rs2 are equals (beq, bne)  : performed throw rs1 & rs2
// * Check if data of rs1 < rs2 (blt, bge)                   : performed throw rs1 - rs2
// * Add immediat to pc                                      : performed throw an addition

import riscv::*;

module lsu
(
    //----------------------------------------
    // Inputs
    //----------------------------------------
    input   logic [XLEN-1:0]         rs1_data_i,
    input   logic [XLEN-1:0]         rs2_data_i,
    input   logic [XLEN-1:0]         immediat_i,
    input   logic                    lsu_en_i,
    input   logic[NB_OPERATION-1:0]  cmd_i,
    input   logic [2:0]              access_size_q_i,
    input   logic                    unsign_extension_i,
    input   logic [XLEN-1:0]         load_data_i,
    //----------------------------------------
    // Outputs
    //----------------------------------------
    output  logic [XLEN-1:0]         adr_o,
    output  logic [XLEN-1:0]         lsu_data_o,
    output  logic [XLEN-1:0]         store_data_o
);

logic [XLEN-1:0] adr;
logic [XLEN-1:0] load_data;

assign adr       = {XLEN{lsu_en_i}} & rs1_data_i + immediat_i;

assign load_data = {XLEN{access_size_q_i[0] & adr[1:0] == 2'b00}} & {{24{~unsign_extension_i & load_data_i[7]}},  load_data_i[7:0]  }
                 | {XLEN{access_size_q_i[0] & adr[1:0] == 2'b01}} & {{24{~unsign_extension_i & load_data_i[7]}},  load_data_i[15:8] }
                 | {XLEN{access_size_q_i[0] & adr[1:0] == 2'b10}} & {{24{~unsign_extension_i & load_data_i[7]}},  load_data_i[23:16]}
                 | {XLEN{access_size_q_i[0] & adr[1:0] == 2'b11}} & {{24{~unsign_extension_i & load_data_i[7]}},  load_data_i[31:24]}
                 | {XLEN{access_size_q_i[1] & adr[1:0] == 2'b00}} & {{16{~unsign_extension_i & load_data_i[15]}}, load_data_i[15:0] }
                 | {XLEN{access_size_q_i[1] & adr[1:0] == 2'b10}} & {{16{~unsign_extension_i & load_data_i[31]}}, load_data_i[31:16]}
                 | {XLEN{access_size_q_i[2]}} & load_data_i;
assign adr_o        = adr;
assign store_data_o = rs2_data_i;
assign lsu_data_o   = load_data;
endmodule