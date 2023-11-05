module csr(
    input  logic            clk,
    input  logic            reset,
    input  logic            write_v_i,
    input  logic [11:0]     adr_read_i,
    input  logic [11:0]     adr_write_i,
    input  logic [XLEN-1:0] data_i,
    output logic [XLEN-1:0] data_o,
);
logic            mvendorid_nxt_v;
logic [XLEN-1:0] mvendorid_q;
logic            marchid_nxt_v;
logic [XLEN-1:0] marchid_q;
logic            mimpid_nxt_v;
logic [XLEN-1:0] mimpid_q;
logic            mstatus_nxt_v;
logic [XLEN-1:0] mstatus_q;
logic            misa_nxt_v;
logic [XLEN-1:0] misa_q;
logic            mie_nxt_v;
logic [XLEN-1:0] mie_q;
logic            mtvec_nxt_v;
logic [XLEN-1:0] mtvec_q;
logic            mstatush_nxt_v;
logic [XLEN-1:0] mstatush_q;
logic            mepc_nxt_v;
logic [XLEN-1:0] mepc_q;
logic            mcause_nxt_v;
logic [XLEN-1:0] mcause_q;
logic            mtval_nxt_v;
logic [XLEN-1:0] mtval_q;
logic            mip_nxt_v;
logic [XLEN-1:0] mip_q;
logic            mscratch_nxt_v;
logic [XLEN-1:0] mscratch_q;

assign mvendorid_nxt_v    = write_v_i & (CSR_MVENDORID == adr_write_i);
assign marchid_nxt_v      = write_v_i & (CSR_MARCHID   == adr_write_i);
assign mimpid_nxt_v       = write_v_i & (CSR_MIMPID    == adr_write_i);
assign mstatus_nxt_v      = write_v_i & (CSR_MSTATUS   == adr_write_i);
assign misa_nxt_v         = write_v_i & (CSR_MISA      == adr_write_i);
assign mie_nxt_v          = write_v_i & (CSR_MIE       == adr_write_i);
assign mtvec_nxt_v        = write_v_i & (CSR_MTVEC     == adr_write_i);
assign mstatush_nxt_v     = write_v_i & (CSR_MSTATUSH  == adr_write_i);
assign mepc_nxt_v         = write_v_i & (CSR_MEPC      == adr_write_i);
assign mtval_nxt_v        = write_v_i & (CSR_MTVAL     == adr_write_i);
assign mip_nxt_v          = write_v_i & (CSR_MIP       == adr_write_i);
assign mscratch_nxt_v     = write_v_i & (CSR_MSCRATCH  == adr_write_i);

always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mvendorid_q <= 32'h0;
    end else begin
        if (mvendorid_nxt_v) begin
            mvendorid_q <= data_i;
        end
    end
end

always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            marchid_q <= 32'h0;
    end else begin
        if (marchid_nxt_v) begin
            marchid_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mimpid_q <= 32'h0;
    end else begin
        if (mimpid_nxt_v) begin
            mimpid_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mstatus_q <= 32'h0;
    end else begin
        if (mstatus_nxt_v) begin
            mstatus_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            misa_q <= 32'h0;
    end else begin
        if (misa_nxt_v) begin
            misa_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mie_q <= 32'h0;
    end else begin
        if (mie_nxt_v) begin
            mie_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mtvec_q <= 32'h0;
    end else begin
        if (mtvec_nxt_v) begin
            mtvec_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mstatush_q <= 32'h0;
    end else begin
        if (mstatush_nxt_v) begin
            mstatush_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mepc_q <= 32'h0;
    end else begin
        if (mepc_nxt_v) begin
            mepc_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mtval_q <= 32'h0;
    end else begin
        if (mtval_nxt_v) begin
            mtval_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mip_q <= 32'h0;
    end else begin
        if (mip_nxt_v) begin
            mip_q <= data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mscratch_q <= 32'h0;
    end else begin
        if (mscratch_nxt_v) begin
            mscratch_q <= data_i;
        end
    end
end
endmodule