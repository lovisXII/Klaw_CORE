import riscv_pkg::*;

module ifetch(
    // global interface
    input logic clk,
    input logic reset_n,
    input logic [XLEN-1:0] reset_adr_i,
    input logic [1:0]     core_mode_q_i,
    // --------------------------------
    //     Icache
    // --------------------------------
    input logic [31:0]      icache_instr_i,
    output logic [XLEN-1:0] icache_adr_o,
    // --------------------------------
    //      EXE
    // --------------------------------
    input  logic            flush_v_i,
    input  logic[XLEN-1:0]  pc_data_q_i,
    // --------------------------------
    //      DEC
    // --------------------------------
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

logic [31:0]     instr_nxt;
logic [XLEN-1:0] pc_nxt;

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

// Reset address
assign end_reset_valid = reset_n & ~reset_n_q ;

assign reset_adr       = {XLEN{end_reset_valid}} & reset_adr_i;

// Next PC gestion
assign pc_fetched_nxt  = {XLEN{~end_reset_valid &  flush_v_i}} & pc_data_q_i    // branch taken
                       | {XLEN{~end_reset_valid & ~flush_v_i}} & pc_q + 32'b100 // no branch taken
                       | {XLEN{ end_reset_valid}}              & reset_adr;     // reset
// Icache Interface
assign icache_adr_o   = pc_fetched_nxt;

// Decod Interface
assign instr_nxt   = icache_instr_i;
assign pc_nxt      = pc_fetched_nxt;

// --------------------------------
//      Flopping outputs
// --------------------------------
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
    instr_q   <= '0;
    pc_q      <= '0;
  end else begin
    instr_q   <= instr_nxt;
    pc_q      <= pc_nxt;
end

// --------------------------------
//      Ouputs
// --------------------------------
assign instr_q_o      = instr_q;
assign pc_q_o         = pc_q;

endmodule
