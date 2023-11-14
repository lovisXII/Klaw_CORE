import riscv_pkg::*;

module dec (
  input logic                 clk,
  input logic                 reset_n,
// --------------------------------
//      Ifetch Interface
// --------------------------------
  input logic [XLEN-1:0]             instr_q_i,
  input logic [XLEN-1:0]             pc0_q_i,
  // Exception
// --------------------------------
//      RF Interface
// --------------------------------
  // Registers Source 1
  output logic [4:0]                 rf_rs1_adr_o,
  input logic [XLEN-1:0]             rf_rs1_data_i,
  // Registers Source 2
  output logic [4:0]                 rf_rs2_adr_o,
  input logic [XLEN-1:0]             rf_rs2_data_i,
// --------------------------------
//      CSR Interface
// --------------------------------
  output logic [11:0]                 csr_adr_o,
  input  logic [XLEN-1:0]             csr_data_i,
// --------------------------------
//      Execute Interface
// --------------------------------
  input logic [1:0]                  core_mode_q_i,
  // rd ff from EXE
  input logic [XLEN-1:0]             exe_ff_res_data_q_i,
  // csr ff from exe
  input logic [XLEN-1:0]             exe_ff_csr_data_i,
  // Fast forwards from RF
  input logic                        rf_write_v_q_i,
  input logic [4:0]                  rf_ff_rd_adr_q_i,
  input logic [XLEN-1:0]             rf_ff_res_data_q_i,
  // PC
  output logic [XLEN-1:0]            pc_q_o,
  // Registers Destination
  output logic                       rd_v_q_o,
  output logic [4:0]                 rd_adr_q_o,
  // Csr destination
  output logic                       csr_wbk_q_o,
  output logic [11:0]                csr_adr_q_o,
  // Source registers
  output logic [XLEN:0]              rs1_data_qual_q_o,
  output logic [XLEN:0]              rs2_data_qual_q_o,
  // Execution Unit useful information
  output logic [XLEN-1:0]            branch_imm_q_o,
  output logic [2:0]                 access_size_q_o,
  output logic                       unsign_ext_q_o,
  output logic                       csrrw_q_o,
  output logic [NB_UNIT-1:0]         unit_q_o,
  output logic [NB_OPERATION-1:0]    operation_q_o,
  output logic                       illegal_inst_q_o,
  // Flush signals
  input logic                        flush_v_i
);
// --------------------------------
//      Signals declaration
// --------------------------------
  logic                       instr_rd_v;
  // rd
  logic                       rd_v_nxt;
  logic [4:0]                 rd_adr_nxt;
  logic [4:0]                 rd_adr_q;
  // rs1
  logic                       rs1_v;
  logic [4:0]                 rs1_adr;
  logic [XLEN-1:0]            rs1_data;
  logic [XLEN:0]              rs1_data_extended;
  logic [XLEN:0]              rs1_data_nxt;
  // rs2
  logic                       rs2_v;
  logic [4:0]                 rs2_adr;
  logic [XLEN-1:0]            rs2_data;
  logic [XLEN:0]              rs2_data_extended;
  logic [XLEN:0]              rs2_data_nxt;
  // csr
  logic                       rs2_is_csr;
  logic                       csr_clear;
  logic                       csr_wbk_nxt;
  logic                       csr_wbk_q;
  logic [11:0]                csr_adr;
  logic [11:0]                csr_adr_nxt;
  logic [11:0]                csr_adr_q;
  // Exceptions
  logic                       illegal_inst_nxt;
  logic                       illegal_inst_q;
  // EXE ff
  logic                       exe_ff_rs1_adr_match;
  logic                       exe_ff_rs2_adr_match;
  logic                       exe_ff_csr_adr_match;
  // RF ff
  logic                       rf_ff_rs1_adr_match;
  logic                       rf_ff_rs2_adr_match;
  // Additionnal informations
  logic                       auipc;
  logic                       rs1_is_immediat;
  logic                       rs2_is_immediat;
  logic [2:0]                 instr_access_size_nxt;
  logic                       unsign_extension;
  logic                       unsign_extension_nxt;
  logic                       csrrw_nxt;
  logic [NB_UNIT-1:0]         unit_nxt;
  logic [NB_OPERATION-1:0]    operation;
  logic                       rs2_ca2_v;
  // Flops
  logic                    rd_v_q;
  logic [XLEN:0]           rs1_data_q;
  logic [XLEN:0]           rs2_data_q;
  logic [XLEN-1:0]         immediat;
  logic [XLEN-1:0]         immediat_q;
  logic [2:0]              instr_access_size_q;
  logic                    unsign_extension_q;
  logic                    csrrw_q;
  logic [NB_UNIT-1:0]      instr_unit_q;
  logic [NB_OPERATION-1:0] instr_operation_q;

// --------------------------------
//      Decoder
// --------------------------------
decoder dec0(
    .instr_i              (instr_q_i),
    .rd_v_o               (instr_rd_v),
    .rd_adr_o             (rd_adr_nxt),
    .csr_wbk_o            (csr_wbk_nxt),
    .csr_clear_o          (csr_clear),
    .csr_adr_o            (csr_adr),
    .rs1_v_o              (rs1_v),
    .rs1_adr_o            (rs1_adr),
    .rs2_v_o              (rs2_v),
    .rs2_adr_o            (rs2_adr),
    .auipc_o              (auipc),
    .rs1_is_immediat_o    (rs1_is_immediat),
    .rs2_is_immediat_o    (rs2_is_immediat),
    .rs2_is_csr_o         (rs2_is_csr),
    .immediat_o           (immediat),
    .access_size_o        (instr_access_size_nxt),
    .unsign_extension_o   (unsign_extension),
    .csrrw_o              (csrrw_nxt),
    .unit_o               (unit_nxt),
    .operation_o          (operation),
    .rs2_ca2_v_o          (rs2_ca2_v),
    .illegal_inst_o       (illegal_inst_nxt)
);

// --------------------------------
//      Internal architecture
// --------------------------------
assign rd_v_nxt        = instr_rd_v;
// EXE ff
assign exe_ff_rs1_adr_match    = (rs1_adr == rd_adr_q)  & rd_v_q    & ~flush_v_i;
assign exe_ff_rs2_adr_match    = (rs2_adr == rd_adr_q)  & rd_v_q    & ~flush_v_i;
assign exe_ff_csr_adr_match    = (csr_adr == csr_adr_q) & csr_wbk_q & ~flush_v_i;

// RF ff
assign rf_ff_rs1_adr_match    = (rs1_adr == rf_ff_rd_adr_q_i) & rf_write_v_q_i & ~exe_ff_rs1_adr_match & ~flush_v_i;
assign rf_ff_rs2_adr_match    = (rs2_adr == rf_ff_rd_adr_q_i) & rf_write_v_q_i & ~exe_ff_rs2_adr_match & ~flush_v_i;

// Sign extension
assign unsign_extension_nxt = unsign_extension;
// Operand 1 value
assign rs1_data       = {XLEN{rs1_v}} & ({XLEN{~exe_ff_rs1_adr_match & ~rf_ff_rs1_adr_match}} & rf_rs1_data_i
                                       | {XLEN{ exe_ff_rs1_adr_match}}                        & exe_ff_res_data_q_i
                                       | {XLEN{ rf_ff_rs1_adr_match}}                         & rf_ff_res_data_q_i)
                      | {XLEN{rs1_is_immediat}}                                               & immediat
                      | {XLEN{auipc}}                                                         & pc0_q_i;

assign rs1_data_extended  = {~unsign_extension & rs1_data[31],
                              {XLEN{~csr_clear}} &  rs1_data
                            | {XLEN{ csr_clear}} & ~rs1_data};

assign rs1_data_nxt       = rs1_data_extended;
// Operand 2 value
assign rs2_data       = {XLEN{rs2_v & ~exe_ff_rs2_adr_match & ~rf_ff_rs2_adr_match}} & rf_rs2_data_i       // no ff, no imm, data from RF
                      | {XLEN{rs2_v &  exe_ff_rs2_adr_match}}                        & exe_ff_res_data_q_i // exe ff
                      | {XLEN{rs2_v &  rf_ff_rs2_adr_match}}                         & rf_ff_res_data_q_i  // rf ff
                      | {XLEN{rs2_is_immediat}}                                      & immediat            // immediat
                      | {XLEN{rs2_is_csr & ~exe_ff_csr_adr_match}}                   & csr_data_i
                      | {XLEN{rs2_is_csr &  exe_ff_csr_adr_match}}                   & exe_ff_csr_data_i; // csr ff

assign rs2_data_extended  = {~unsign_extension & rs2_data[31], rs2_data};

assign rs2_data_nxt       = {XLEN+1{ rs2_ca2_v}} & ~rs2_data_extended + 32'b1
                          | {XLEN+1{~rs2_ca2_v}} &  rs2_data_extended;

// Csr value
assign csr_adr_nxt  = csr_adr;
assign csr_adr_o    = csr_adr_nxt;
// --------------------------------
//      Flopping outputs
// --------------------------------

always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
              rd_v_q                   <= '0;
              rd_adr_q                 <= '0;
              rs1_data_q               <= '0;
              rs2_data_q               <= '0;
              instr_access_size_q      <= '0;
              unsign_extension_q       <= '0;
              csrrw_q                  <= '0;
              instr_unit_q             <= '0;
              instr_operation_q        <= '0;
              pc_q_o                   <= '0;
              csr_adr_q                <= '0;
              csr_wbk_q                <= '0;
              illegal_inst_q           <= '0;
  end else begin
              rd_v_q                   <= rd_v_nxt;
              rd_adr_q                 <= rd_adr_nxt;
              rs1_data_q               <= rs1_data_nxt;
              rs2_data_q               <= rs2_data_nxt;
              immediat_q               <= immediat;
              instr_access_size_q      <= instr_access_size_nxt;
              unsign_extension_q       <= unsign_extension_nxt;
              csrrw_q                  <= csrrw_nxt;
              instr_unit_q             <= unit_nxt;
              instr_operation_q        <= operation;
              pc_q_o                   <= pc0_q_i;
              csr_adr_q                <= csr_adr_nxt;
              csr_wbk_q                <= csr_wbk_nxt;
              illegal_inst_q           <= illegal_inst_nxt;
  end

// --------------------------------
//      Ouputs
// --------------------------------
assign rf_rs1_adr_o     = rs1_adr;
assign rf_rs2_adr_o     = rs2_adr;
assign rd_v_q_o          = rd_v_q;
assign rd_adr_q_o        = rd_adr_q;
assign rs1_data_qual_q_o = rs1_data_q;
assign rs2_data_qual_q_o = rs2_data_q;
assign branch_imm_q_o    = immediat_q;
assign access_size_q_o   = instr_access_size_q;
assign unsign_ext_q_o    = unsign_extension_q;
assign csrrw_q_o         = csrrw_q;
assign unit_q_o          = instr_unit_q;
assign operation_q_o     = instr_operation_q;
assign csr_adr_q_o       = csr_adr_q;
assign csr_wbk_q_o       = csr_wbk_q;
assign illegal_inst_q_o  = illegal_inst_q;

endmodule