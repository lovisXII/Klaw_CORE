// This module must instanciate the interface between the fetch unit and the caches
// It can fetch several instruction at the same cycle so it must be parametrizable
import riscv::*;

module ifetch(
    // global interface
    input logic clk,
    input logic reset_n,
    input logic [XLEN-1:0] reset_adr_i,
    // --------------------------------
    //     Icache Interface line {<i>}
    // --------------------------------
    input logic [31:0]      icache_instr_i,
    output logic [XLEN-1:0] icache_adr_o,
    // --------------------------------
    //      EXE Interface
    // --------------------------------
    input  logic            flush_v_q_i,
    input  logic[XLEN-1:0]  pc_data_q_i,
    // --------------------------------
    //      DEC Interface
    // --------------------------------
    output logic            instr_v_q_o,
    output logic[31:0]      instr_q_o,
    output logic[XLEN-1:0]  pc_q_o

);

// --------------------------------
//      Signals declaration
// --------------------------------
// Reset signals
logic            reset_n_q;
logic            end_reset_valid;
logic [XLEN-1:0] reset_adr;
logic [XLEN-1:0] pc_fetched_nxt;

// D pin of internals flops
logic            instr_v_nxt;
logic [31:0]     instr_nxt;
logic [XLEN-1:0] pc_nxt;

// Q pin of internals flops
logic            instr_v_q;
logic [31:0]     instr_q;
logic [XLEN-1:0] pc_q;

// --------------------------------
//      Internal architecture
// --------------------------------

// Reset PC
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
    reset_n_q <= '0;
  end else begin
    reset_n_q <= reset_n;
end

// Reset adress
assign end_reset_valid = reset_n & ~reset_n_q ;

assign reset_adr       = {XLEN{end_reset_valid}} & reset_adr_i;

// Next PC gestion
assign pc_fetched_nxt  = {XLEN{reset_n &  flush_v_q_i}} & pc_data_q_i    // branch taken
                       | {XLEN{reset_n & ~flush_v_q_i}} & pc_q + 32'b100 // no branch taken
                       | {XLEN{end_reset_valid}}        & reset_adr;     // reset
// Icache Interface
assign icache_adr_o   = pc_fetched_nxt;

// Decod Interface
assign instr_v_nxt = reset_n;
assign instr_nxt   = icache_instr_i;
assign pc_nxt      = pc_fetched_nxt;

// --------------------------------
//      Flopping outputs
// --------------------------------
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
    instr_v_q <= '0;
    instr_q   <= '0;
    pc_q      <= '0;
  end else begin
    instr_v_q <= instr_v_nxt;
    instr_q   <= instr_nxt;
    pc_q      <= pc_nxt;
end

// --------------------------------
//      Ouputs
// --------------------------------
assign instr_v_q_o    = instr_v_q;
assign instr_q_o      = instr_q;
assign pc_q_o         = pc_q;

endmodule
