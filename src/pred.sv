import riscv_pkg::*;

module pred
    #(parameter PRED_SIZE = 4) (
    // global interface
    input logic                 clk,
    input logic                 reset_n,

    input logic                 pred_en_i,
    input logic [XLEN-1:0]      bu_pc_branch_i,
    input logic [XLEN-1:0]      bu_pc_target_i,

    input logic                 bu_pred_success_i,
    input logic                 bu_pred_failed_i,

    output logic [XLEN-1:0]     pred_pc_o,
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

logic [PRED_SIZE-1:0]       pred_wptr_next;
logic [PRED_SIZE-1:0]       pred_wptr_q;
logic                       pred_wptr_we;

logic [PRED_SIZE-1:0]       pred_we;

logic [PRED_SIZE-1:0]       pred_hits;          // onehot
logic                       pred_miss;

logic                       pred_update;
logic [PRED_SIZE-1:0]       pred_sate_update;   // onehot

logic                       new_pred;
logic [1:0]                 pred_state;


assign pred_wptr_next   =   pred_wptr_q << 1'b1 & {PRED_SIZE{~pred_wptr_q[PRED_SIZE-1]}}
                        |   4'b1                & {PRED_SIZE{ pred_wptr_q[PRED_SIZE-1]}};

generate
for(i = 0; i < PRED_SIZE; i++) begin
    assign pred_hits[i]         = bu_pc_branch_i == branch_q[i] & pred_v_q[i];
    assign pred_sate_update[i]  = pred_update & pred_hits[i];

    assign pred_state_next[i]   = (pred_state_q[i] + 1'b1) & {2{~&pred_state_q[i] & ~new_pred & pred_hits[i] & bu_pred_success_i   }} 
                                | (pred_state_q[i] - 1'b1) & {2{ |pred_state_q[i] & ~new_pred & pred_hits[i] & bu_pred_failed_i    }}
                                | (pred_state_q[i]       ) & {2{~^pred_state_q[i] & ~new_pred & pred_hits[i]                    }}
                                | (PRED_WT               ) & {2{                     new_pred                                   }};

    assign branch_next[i]       = bu_pc_branch_i;
    assign target_next[i]       = bu_pc_target_i;
    assign pred_v_next[i]       = pred_en_i;

    assign pred_we[i]           = pred_wptr_q[i] & pred_en_i & ~pred_hits[i];
end
endgenerate

assign pred_miss        = ~|pred_hits;
assign pred_wptr_we     = pred_miss & pred_en_i;

assign pred_update      = pred_en_i & (bu_pred_success_i | bu_pred_failed_i | pred_miss);

assign new_pred         = &pred_v_q & |pred_we;

// Flops
generate
for(i = 0; i < PRED_SIZE; i++) begin
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            branch_q[i]         <= '0;
            target_q[i]         <= '0;
            pred_v_q[i]         <= '0;
        end else begin 
            if (pred_we[i] == 1'b1) begin
                branch_q[i]     <= branch_next[i];
                target_q[i]     <= target_next[i];
                pred_v_q[i]     <= pred_v_next[i]; 
            end    
        end
    end
end

always_ff @(posedge clk, negedge reset_n) begin
    if (!reset_n)
        pred_state_q[i]     <= PRED_WT;
    else begin
        if (pred_sate_update[i])
            pred_state_q[i] <= pred_state_next[i];
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

// Sorry it's ugly
// Output mux
always_comb begin
    logic [XLEN-1:0] pc_target;
    logic [1:0]      state;
    logic            valid;

    pc_target = '0;
    state     = '0;
    valid     = '0;

    for(i=0; i<PRED_SIZE; i++) begin    
        pc_target = pc_target   | (target_q[i]      & {XLEN{pred_hits[i]}});
        state     = state       | (pred_state_q[i]  & {XLEN{pred_hits[i]}});
        valid     = valid       | (pred_v_q[i]      & {XLEN{pred_hits[i]}});
    end

    assign pred_state   = state;
    assign pred_v_o     = valid; 
    assign pred_pc_o    = pc_target;
end

assign pred_taken_o     = pred_state[1];

endmodule