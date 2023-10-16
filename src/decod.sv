import riscv::*;

module dec (
  input logic                 clk,
  input logic                 reset_n,
// --------------------------------
//      Ifetch Interface
// --------------------------------
  input logic                        instr_v_q_i,
  input logic [XLEN-1:0]             instr_q_i,
  input logic [XLEN-1:0]             pc0_q_i,
  // Exception
  output logic                       instr_illegal_q_o,
// --------------------------------
//      RF Interface
// --------------------------------
  // Registers Source 1
  output logic                       rf_rs1_v_o,
  output logic [4:0]                 rfr_rs1_adr_o,
  input logic [XLEN-1:0]             rf_rs1_data_i,
  // Registers Source 2
  output logic                       rf_rs2_v_o,
  output logic [4:0]                 rfr_rs2_adr_o,
  input logic [XLEN-1:0]             rf_rs2_data_i,
// --------------------------------
//      Execute Interface
// --------------------------------
  // Fast forwards from EXE
  input logic                         exe_ff_write_v_q_i,
  input logic [4:0]                   exe_ff_rd_adr_q_i,
  input logic [XLEN-1:0]              exe_ff_res_data_i,
  // Fast forwards from RF
  input logic                         rf_write_v_q_i,
  input logic [4:0]                   rf_ff_rd_adr_q_i,
  input logic [XLEN-1:0]              rf_ff_res_data_i,
  // PC
  output logic                       instr_v_q_o,
  output logic [XLEN-1:0]            pc_q_o,
  // Registers Destination
  output logic                       rd_v_q_o,
  output logic [4:0]                 rd_adr_q_o,
  // Source registers
  output logic [XLEN:0]              rs1_data_qual_q_o,
  output logic [XLEN:0]              rs2_data_qual_q_o,
  // Execution Unit useful information
  output logic [XLEN-1:0]            branch_imm_q_o,
  output logic [2:0]                 access_size_q_o,
  output logic                       unsign_ext_q_o,
  output logic [NB_UNIT-1:0]         unit_q_o,
  output logic [NB_OP_DECODED-1:0]   operation_q_o,
  // Flush signals
  input logic                        flush_v_q_i,
  input logic                        flush_v_q_dly1_i
);
// --------------------------------
//      Signals declaration
// --------------------------------
// -----------------------
//      LINE 0
// -----------------------
  logic                       instr_illegal_inst_nxt;
  logic                       instr_illegal_inst_q;
  logic                       valid_instr_q;
  logic                       instr_rd_v;
  // rd
  logic                       rd_v_nxt;
  logic [4:0]                 rd_adr_nxt;
  logic [4:0]                 rd_adr_q;
  // rs1
  logic                       rs1_v;
  logic [4:0]                 rs1_adr;
  logic [XLEN-1:0]            rs1_data;
  logic [XLEN:0]              rs1_data_nxt;
  // rs2
  logic                       rs2_v;
  logic [4:0]                 rs2_adr;
  logic [XLEN-1:0]            rs2_data;
  logic [XLEN:0]              rs2_data_extended;
  logic [XLEN:0]              rs2_data_nxt;
  // Flush
  logic                       flush_v;
  // EXE ff
  logic                       exe_ff_rs1_adr_match;
  logic                       exe_ff_rs2_adr_match;
  // RF ff
  logic                       rf_ff_rs1_adr_match;
  logic                       rf_ff_rs2_adr_match;
  // Additionnal informations
  logic                       auipc;
  logic                       rs2_is_immediat;
  logic                       is_store;
  logic                       instr_is_load;
  logic                       instr_is_branch;
  logic [2:0]                 instr_access_size_nxt;
  logic [12:0]                instr_instr_type;
  logic                       unsign_extension;
  logic                       unsign_extension_nxt;
  logic [NB_UNIT-1:0]         unit_nxt;
  logic [NB_OPERATION-1:0]    operation;
  logic                       rs2_ca2_v;
  // Flops
  logic                       rd_v_q;
  logic [XLEN:0]              rs1_data_q;
  logic                       instr_rs2_v_q;
  logic [XLEN:0]              rs2_data_q;
  logic                       rs2_is_immediat_q;
  logic                       instr_is_st_q;
  logic                       instr_is_lq;
  logic                       instr_is_braq;
  logic [XLEN-1:0]            immediat;
  logic [XLEN-1:0]            immediat_q;
  logic [2:0]                 instr_access_size_q;
  logic [12:0]                instr_instr_q;
  logic                       unsign_extension_q;
  logic [NB_UNIT-1:0]         instr_unit_q;
  logic [NB_OP_DECODED-1:0]   instr_operation_q;
  logic [NB_OP_DECODED-1:0]   instr_operation_dec_q;

// --------------------------------
//      Decoder instanciation
// --------------------------------
decoder dec0(
    .instr_i              (instr_q_i),
    .illegal_inst_o       (instr_illegal_inst_nxt),
    .rd_v_o               (instr_rd_v),
    .rd_o                 (rd_adr_nxt),
    .rs1_v_o              (rs1_v),
    .rs1_adr_o            (rs1_adr),
    .rs2_v_o              (rs2_v),
    .rs2_adr_o            (rs2_adr),
    .auipc_o              (auipc),
    .rs2_is_immediat_o    (rs2_is_immediat),
    .immediat_o           (immediat),
    .access_size_o        (instr_access_size_nxt),
    .unsign_extension_o   (unsign_extension),
    .unit_o               (unit_nxt),
    .operation_o          (operation),
    .rs2_ca2_v_o          (rs2_ca2_v)
);

// --------------------------------
//      Internal architecture
// --------------------------------
assign valid_instr_nxt = instr_v_q_i;
assign rd_v_nxt        = instr_rd_v;
// Flush
assign flush_v = flush_v_q_i | flush_v_q_dly1_i;
// EXE ff
assign exe_ff_rs1_adr_match    = (rs1_adr == exe_ff_rd_adr_q_i) & exe_ff_write_v_q_i & ~flush_v;
assign exe_ff_rs2_adr_match    = (rs2_adr == exe_ff_rd_adr_q_i) & exe_ff_write_v_q_i & ~flush_v;

// RF ff
assign rf_ff_rs1_adr_match    = (rs1_adr == rf_ff_rd_adr_q_i) & rf_write_v_q_i & ~exe_ff_rs1_adr_match & ~flush_v;
assign rf_ff_rs2_adr_match    = (rs2_adr == rf_ff_rd_adr_q_i) & rf_write_v_q_i & ~exe_ff_rs2_adr_match & ~flush_v;

// Sign extension
assign unsign_extension_nxt = unsign_extension;
// Operand 1 value
assign rs1_data       = {XLEN{rs1_v}} & ({XLEN{~exe_ff_rs1_adr_match & ~rf_ff_rs1_adr_match}} & rf_rs1_data_i
                                       | {XLEN{ exe_ff_rs1_adr_match}}                        & exe_ff_res_data_i
                                       | {XLEN{ rf_ff_rs1_adr_match}}                         & rf_ff_res_data_i)
                      | {XLEN{auipc}} & pc0_q_i;

assign rs1_data_nxt   = {~unsign_extension & rs1_data[31], rs1_data};
// Operand 2 value
assign rs2_data           = {XLEN{rs2_v & ~exe_ff_rs2_adr_match & ~rf_ff_rs2_adr_match}} & rf_rs2_data_i     // no ff, no imm, data from RF
                          | {XLEN{rs2_v &  exe_ff_rs2_adr_match}}                        & exe_ff_res_data_i // exe ff
                          | {XLEN{rs2_v &  rf_ff_rs2_adr_match}}                         & rf_ff_res_data_i  // rf ff
                          | {XLEN{rs2_is_immediat}}                                      & immediat;   // immediat

assign rs2_data_extended  = {~unsign_extension & rs2_data[31], rs2_data};
assign rs2_data_nxt       = {XLEN+1{ rs2_ca2_v}} & ~rs2_data_extended + 32'b1
                          | {XLEN+1{~rs2_ca2_v}} &  rs2_data_extended;


// --------------------------------
//      Flopping outputs
// --------------------------------

always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
              valid_instr_q            <= '0;
              instr_illegal_inst_q     <= '0;
              rd_v_q                   <= '0;
              rd_adr_q                 <= '0;
              rs1_data_q               <= '0;
              rs2_data_q               <= '0;
              instr_access_size_q      <= '0;
              unsign_extension_q <= '0;
              instr_unit_q             <= '0;
              instr_operation_q        <= '0;
              pc_q_o                   <= '0;
  end else begin
              valid_instr_q               <= valid_instr_nxt;
              instr_illegal_inst_q        <= instr_illegal_inst_nxt;
              rd_v_q                      <= rd_v_nxt;
              rd_adr_q                    <= rd_adr_nxt;
              rs1_data_q                  <= rs1_data_nxt;
              rs2_data_q                  <= rs2_data_nxt;
              immediat_q                  <= immediat;
              instr_access_size_q         <= instr_access_size_nxt;
              unsign_extension_q          <= unsign_extension_nxt;
              instr_unit_q                <= unit_nxt;
              instr_operation_q           <= operation;
              pc_q_o                      <= pc0_q_i;
  end

assign rf_rs1_v_o        = rs1_v;
assign rfr_rs1_adr_o     = rs1_adr;
assign rf_rs2_v_o        = rs2_v;
assign rfr_rs2_adr_o     = rs2_adr;
assign instr_v_q_o       = valid_instr_q;
assign rd_v_q_o          = rd_v_q;
assign instr_illegal_q_o = instr_illegal_inst_q;
assign rd_adr_q_o        = rd_adr_q;
assign rs1_data_qual_q_o = rs1_data_q;
assign rs2_data_qual_q_o = rs2_data_q;
assign branch_imm_q_o    = immediat_q;
assign access_size_q_o   = instr_access_size_q;
assign unsign_ext_q_o    = unsign_extension_q;
assign unit_q_o          = instr_unit_q;
assign operation_q_o     = instr_operation_q;

endmodule