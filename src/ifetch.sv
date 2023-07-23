// This module must instanciate the interface between the fetch unit and the caches
// It can fetch several instruction at the same cycle so it must be parametrizable

module ifetch(
    // global interface
    input logic clk,
    input logic reset_n,

    input logic         icache_stall_i,
%% for i in range(1):
    // -----------------------
    //      LINE {<i>}
    // -----------------------

    // Icache interface
    input logic [31:0]     line{<i>}_instr_i,
    output logic [31:0]    line{<i>}_adr_o,

    // PC interface
    input  logic           line{<i>}_pc_v_i,
    input  logic[XLEN-1:0] line{<i>}_pc_i,
    // Decod Interface
    output logic[31:0]     line{<i>}_instr_o,
    output logic[31:0]     line{<i>}_pc_o,
%% endfor
);

%% for i in range(1):
    // -----------------------
    //      LINE {<i>}
    // -----------------------
    // Cache Interface
assign line{<i>}_adr_o   = {XLEN-1{line{<i>}_pc_v_i}}      & line{<i>}_pc_i;
    // Decod Interface
assign line{<i>}_instr_o = {32{~icache_stall_i}}                    & line{<i>}_instr_i;
assign line{<i>}_pc_o    = {32{~icache_stall_i & line{<i>}_pc_v_i}} & line{<i>}_pc_i;
%% endfor
endmodule