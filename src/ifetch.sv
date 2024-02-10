import riscv_pkg::*;

module ifetch
(
    // global interface
    input logic clk,
    input logic reset_n,
    input logic [XLEN-1:0] reset_adr_i,
    // --------------------------------
    //     Icache
    // --------------------------------
    input logic [31:0]      icache_instr_i,
    output logic [XLEN-1:0] icache_adr_o,
    // --------------------------------
    //      EXE
    // --------------------------------
    input  logic            flush_v_q_i,
    input  logic[XLEN-1:0]  pc_data_q_i,
    input  logic[XLEN-1:0]  exe_pc_q_i,
    input  logic            exe_branch_instr_q_i,
    input  logic            bu_pred_feedback_q_i,
    input  logic            bu_pred_success_q_i,
    input  logic            bu_pred_failed_q_i,

    // --------------------------------
    //      DEC
    // --------------------------------

    output logic            pred_v_o,
    output logic            pred_is_taken_o,
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

logic            pred_en;
logic [XLEN-1:0] pred_pc;
logic            pred_taken;
logic            pred_v;
logic            pred_v_q;
logic            pred_taken_q;

// --------------------------------
//      Unit instanciation
// --------------------------------

pred u_pred(
    .clk                  (clk),
    .reset_n              (reset_n),
    .pred_en_i            (pred_en),
    .bu_pc_branch_i       (exe_pc_q_i),
    .bu_pc_target_i       (pc_data_q_i),
    .bu_pred_feedback_q_i (bu_pred_feedback_q_i),
    .bu_pred_success_q_i  (bu_pred_success_q_i),
    .bu_pred_failed_q_i   (bu_pred_failed_q_i),
    .pred_pc_o            (pred_pc),
    .pred_taken_o         (pred_taken),
    .pred_v_o             (pred_v)
);


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
assign pc_fetched_nxt  = {XLEN{reset_n &  flush_v_q_i}} & pc_data_q_i    // branch taken
                       | {XLEN{reset_n & ~flush_v_q_i}} & pc_q + 32'b100 // no branch taken
                       | {XLEN{end_reset_valid}}        & reset_adr;     // reset
// Icache Interface
assign icache_adr_o   = pc_fetched_nxt;

// Decod Interface
assign instr_nxt   = icache_instr_i;
assign pc_nxt      = pc_fetched_nxt;

// Branch pred
assign pred_en = exe_branch_instr_q_i | bu_pred_feedback_q_i;
// --------------------------------
//      Flopping outputs
// --------------------------------
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
    instr_q   <= '0;
    pc_q      <= '0;
    pred_v_q  <= '0;
    pred_taken_q <= '0;
  end else begin
    instr_q   <= instr_nxt;
    pc_q      <= pc_nxt;
    pred_v_q  <= pred_v;
    pred_taken_q <= pred_taken;
end

// --------------------------------
//      Ouputs
// --------------------------------
assign instr_q_o      = instr_q;
assign pc_q_o         = pc_q;
assign pred_v_o         = pred_v_q;
assign pred_is_taken_o  = pred_taken_q;

endmodule
