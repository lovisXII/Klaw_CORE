module csr(
    input  logic            clk,
    input  logic            reset_n,
    // --------------------------------
    //      Inputs
    // --------------------------------
    input  logic            exception_q_i,
    input  logic [XLEN-1:0] mcause_q_i,
    input  logic [XLEN-1:0] mtval_q_i,
    input  logic [XLEN-1:0] mepc_q_i,
    input  logic            write_v_i,
    input  logic [11:0]     adr_read_i,
    input  logic [11:0]     adr_write_i,
    input  logic [XLEN-1:0] data_i,
    // --------------------------------
    //      Outputs
    // --------------------------------
    output logic [XLEN-1:0] mepc_q_o,
    output logic [XLEN-1:0] mtvec_q_o,
    output logic [XLEN-1:0] data_o
);
logic            mhardtid_nxt_v;
logic [XLEN-1:0] mhardtid_q;
logic            mvendorid_nxt_v;
logic [XLEN-1:0] mvendorid_q;
logic [XLEN-1:0] marchid_q;
logic [XLEN-1:0] mimpid_q;
logic            mstatus_nxt_v;
logic [XLEN-1:0] mstatus_nxt;
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
logic [XLEN-1:0] mepc_nxt;
logic [XLEN-1:0] mepc_q;
logic            mcause_nxt_v;
logic [XLEN-1:0] mcause_nxt;
logic [XLEN-1:0] mcause_q;
logic            mtval_nxt_v;
logic [XLEN-1:0] mtval_nxt;
logic [XLEN-1:0] mtval_q;
logic            mip_nxt_v;
logic [XLEN-1:0] mip_q;
logic            mscratch_nxt_v;
logic [XLEN-1:0] mscratch_q;
// --------------------------------
//      Write
// --------------------------------
assign mhardtid_nxt_v     = write_v_i & (CSR_MHARTID   == adr_write_i);
assign mvendorid_nxt_v    = write_v_i & (CSR_MVENDORID == adr_write_i);
assign mstatus_nxt_v      = write_v_i & (CSR_MSTATUS   == adr_write_i)
                          | exception_q_i;
assign misa_nxt_v         = write_v_i & (CSR_MISA      == adr_write_i);
assign mie_nxt_v          = write_v_i & (CSR_MIE       == adr_write_i);
assign mtvec_nxt_v        = write_v_i & (CSR_MTVEC     == adr_write_i);
assign mstatush_nxt_v     = write_v_i & (CSR_MSTATUSH  == adr_write_i);
assign mepc_nxt_v         = write_v_i & (CSR_MEPC      == adr_write_i)
                          | exception_q_i;
assign mcause_nxt_v       = write_v_i & (CSR_MCAUSE    == adr_write_i)
                          | exception_q_i;
assign mtval_nxt_v        = write_v_i & (CSR_MTVAL     == adr_write_i)
                          | exception_q_i;
assign mip_nxt_v          = write_v_i & (CSR_MIP       == adr_write_i);
assign mscratch_nxt_v     = write_v_i & (CSR_MSCRATCH  == adr_write_i);

assign mstatus_nxt  = {XLEN{mstatus_nxt_v}} & data_i;

assign mepc_nxt     = {XLEN{mepc_nxt_v}}    & data_i
                    | {XLEN{exception_q_i}} & mepc_q_i;

assign mcause_nxt   = {XLEN{mcause_nxt_v}}  & data_i
                    | {XLEN{exception_q_i}} & mcause_q_i;

assign mtval_nxt    = {XLEN{mtval_nxt_v}}   & data_i
                    | {XLEN{exception_q_i}} & mtval_q_i;

always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mhardtid_q <= 32'h0;
    end else begin
        if (mhardtid_nxt_v) begin
            mhardtid_q <= data_i;
        end
    end
end

always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mvendorid_q <= 32'h0;
    end else begin
        if (mvendorid_nxt_v) begin
            mvendorid_q <= data_i;
        end
    end
end

assign marchid_q = 32'h0;
assign mimpid_q  = 32'h0;

always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mstatus_q <= 32'h0;
    end else begin
        if (mstatus_nxt_v) begin
            mstatus_q <= {19'b0, 2'b11, 11'b0};
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            misa_q <= {2'b1, 4'b0, 26'b1_0000_0000};
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
            mepc_q <= mepc_nxt;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mcause_q <= 32'h0;
    end else begin
        if (mcause_nxt_v) begin
            mcause_q <= mcause_nxt;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            mtval_q <= 32'h0;
    end else begin
        if (mtval_nxt_v) begin
            mtval_q <= mtval_nxt;
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

// --------------------------------
//      Read
// --------------------------------

assign data_o = 32'b0
              | {XLEN{(CSR_MHARTID   == adr_read_i)}} & mhardtid_q
              | {XLEN{(CSR_MVENDORID == adr_read_i)}} & mvendorid_q
              | {XLEN{(CSR_MARCHID   == adr_read_i)}} & marchid_q
              | {XLEN{(CSR_MIMPID    == adr_read_i)}} & mimpid_q
              | {XLEN{(CSR_MSTATUS   == adr_read_i)}} & mstatus_q
              | {XLEN{(CSR_MISA      == adr_read_i)}} & misa_q
              | {XLEN{(CSR_MIE       == adr_read_i)}} & mie_q
              | {XLEN{(CSR_MTVEC     == adr_read_i)}} & mtvec_q
              | {XLEN{(CSR_MSTATUSH  == adr_read_i)}} & mstatush_q
              | {XLEN{(CSR_MEPC      == adr_read_i)}} & mepc_q
              | {XLEN{(CSR_MCAUSE    == adr_read_i)}} & mcause_q
              | {XLEN{(CSR_MTVAL     == adr_read_i)}} & mtval_q
              | {XLEN{(CSR_MIP       == adr_read_i)}} & mip_q
              | {XLEN{(CSR_MSCRATCH  == adr_read_i)}} & mscratch_q
              ;

// --------------------------------
//      Exceptions
// --------------------------------
assign mepc_q_o  = mepc_q;
assign mtvec_q_o = mtvec_q;
endmodule