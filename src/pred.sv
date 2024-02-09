import riscv_pkg::*;

module pred
    #(parameter PRED_SIZE = 4) (
    // global interface
    input logic                 clk,
    input logic                 reset_n,

    input logic                 pred_en_i,
    input logic [XLEN-1:0]      bu_pc_branch_i,
    input logic [XLEN-1:0]      bu_pc_target_i,
    input logic                 pred_success_i,
    input logic                 pred_failed_i,

    output logic [XLEN-1:0]     pc_pred_o,
    output logic                pred_taken_o,
    output logic                pred_v_o
);  

genvar i;

logic [XLEN-1:0]            branch_next     [PRED_SIZE-1:0];
logic [XLEN-1:0]            target_next     [PRED_SIZE-1:0];
logic [1:0]                 pred_state_next [PRED_SIZE-1:0];
logic [PRED_SIZE-1:0]       pred_v_next;

logic [XLEN-1:0]            branch_q        [PRED_SIZE-1:0];
logic [XLEN-1:0]            target_q        [PRED_SIZE-1:0];
logic [1:0]                 pred_state_q    [PRED_SIZE-1:0];
logic [PRED_SIZE-1:0]       pred_v_q;

logic [PRED_WPTR_SIZE-1:0]  pred_wptr_next;
logic [PRED_WPTR_SIZE-1:0]  pred_wptr_q;
logic                       pred_wptr_we;

logic [PRED_SIZE-1:0]       pred_we;

logic [PRED_SIZE-1:0]       pred_hits;          // onehot
logic                       pred_miss;

logic                       pred_update;
logic [PRED_SIZE-1:0]       pred_sate_update;   // onehot


assign pred_wptr_next   = pred_wptr_q + 1'b1;

generate
for(i = 0; i < PRED_SIZE; i++) begin
    assign pred_hits[i] = bu_pc_branch_i == branch_q[i];
end
endgenerate

assign pred_miss        = ~|pred_hits;
assign pred_wptr_we     = pred_miss & pred_en_i;

assign pred_update      = pred_en_i & (pred_success_i | pred_failed_i | pred_miss);


// Flops
generate
for(i = 0; i < PRED_SIZE; i++) begin
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            branch_q[i]         <= '0;
            target_q[i]         <= '0;
            pred_state_q[i]     <= PRED_WNT;
            pred_v_q[i]         <= '0;
        end else begin 
            if (pred_we[i] == 1'b1) begin
                branch_q[i]     <= branch_next[i];
                target_q[i]     <= target_next[i];
                pred_state_q[i] <= pred_state_next[i]; // should be in another flop
                pred_v_q[i]     <= pred_v_next[i]; 
            end    
        end
    end
end
endgenerate

always_ff @(posedge clk, negedge reset_n) begin
    if (!reset_n)
        pred_wptr_q     <= '0;
    else begin
        if (pred_wptr_we == 1'b1)
            pred_wptr_q <= pred_wptr_next;
    end
end


endmodule