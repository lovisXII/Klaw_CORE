import riscv_pkg::*;

module dec1 (
  input logic                       clk,
  input logic                       reset_n,
// --------------------------------
//      dec0 Interface
// --------------------------------
  // PC
  input logic [XLEN-1:0]             pc_q_i,
  // Registers Destination
  input logic                        wbk_v_q_i,
  input logic [4:0]                  wbk_adr_q_i,
  // Csr destination
  input logic                        csr_wbk_q_i,
  input logic [11:0]                 csr_adr_q_i,
  input logic [XLEN-1:0]             csr_data_q_i,
  // Source registers
  input logic                       rs1_v_q_i,
  input logic [4:0]                 rs1_adr_q_i,
  input logic [XLEN-1:0]            rs1_data_q_i,
  input logic                       rs2_v_q_i,
  input logic [4:0]                 rs2_adr_q_i,
  input logic [XLEN-1:0]            rs2_data_q_i,
  // Execution Unit useful information
  input logic                        csr_clear_q_i,
  input logic                        ecall_q_i,
  input logic                        ebreak_q_i,
  input logic                        auipc_q_i,
  input logic                        rs1_is_immediat_q_i,
  input logic                        rs2_is_immediat_q_i,
  input logic                        rs2_is_csr_q_i,
  input logic [XLEN-1:0]             immediat_q_i,
  input logic [2:0]                  access_size_q_i,
  input logic                        unsign_extension_q_i,
  input logic                        csrrw_q_i,
  input logic [NB_UNIT-1:0]          unit_q_i,
  input logic [NB_OPERATION-1:0]     operation_q_i,
  input logic                        rs2_ca2_v_q_i,
  input logic                        illegal_inst_q_i,
  input logic                        mret_q_i,
  input logic                        sret_q_i,
// --------------------------------
//      Execute Interface
// --------------------------------
  // rd ff from EXE
  input logic [XLEN-1:0]             exe_ff_res_data_i,
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
  output logic                       mret_q_o,
  output logic                       sret_q_o,
  output logic                       ecall_q_o,
  output logic                       ebreak_q_o,
  // Flush signals
  input logic                        branch_v_q_i
);
// --------------------------------
//      Signals declaration
// --------------------------------
  // rd
  logic [4:0]                 wbk_adr_q;
  // rs1
  logic [XLEN-1:0]            rs1_data;
  logic [XLEN:0]              rs1_data_extended;
  logic [XLEN:0]              rs1_data_nxt;
  // rs2
  logic [XLEN-1:0]            rs2_data;
  logic [XLEN:0]              rs2_data_extended;
  logic [XLEN:0]              rs2_data_nxt;
  // csr
  logic                       csr_wbk_q;
  logic [11:0]                csr_adr_q;
  logic                       ecall_q;
  logic                       ebreak_q;
  // Exceptions
  logic                       illegal_inst_q;
  logic                       mret_q;
  logic                       sret_q;
  // EXE ff
  logic                       exe_ff_rs1_adr_match;
  logic                       exe_ff_rs2_adr_match;
  logic                       exe_ff_csr_adr_match;
  // RF ff
  logic                       rf_ff_rs1_adr_match;
  logic                       rf_ff_rs2_adr_match;
  // Flops
  logic                       wbk_v_q;
  logic [XLEN:0]              rs1_data_q;
  logic [XLEN:0]              rs2_data_q;
  logic [XLEN-1:0]            immediat_q;
  logic [2:0]                 instr_access_size_q;
  logic                       unsign_extension_q;
  logic                       csrrw_q;
  logic [NB_UNIT-1:0]         instr_unit_q;
  logic [NB_OPERATION-1:0]    instr_operation_q;

// --------------------------------
//      Internal architecture
// --------------------------------
// EXE ff
assign exe_ff_rs1_adr_match    = (rs1_adr_q_i == wbk_adr_q) & wbk_v_q     & ~branch_v_q_i;
assign exe_ff_rs2_adr_match    = (rs2_adr_q_i == wbk_adr_q) & wbk_v_q     & ~branch_v_q_i;
assign exe_ff_csr_adr_match    = (csr_adr_q_i == csr_adr_q) & csr_wbk_q   & ~branch_v_q_i;

// RF ff
assign rf_ff_rs1_adr_match    = (rs1_adr_q_i == rf_ff_rd_adr_q_i) & rf_write_v_q_i & ~exe_ff_rs1_adr_match & ~branch_v_q_i;
assign rf_ff_rs2_adr_match    = (rs2_adr_q_i == rf_ff_rd_adr_q_i) & rf_write_v_q_i & ~exe_ff_rs2_adr_match & ~branch_v_q_i;

// Operand 1 value
assign rs1_data       = {XLEN{rs1_v_q_i}} & ({XLEN{~exe_ff_rs1_adr_match & ~rf_ff_rs1_adr_match}} & rs1_data_q_i
                                           | {XLEN{ exe_ff_rs1_adr_match}}                        & exe_ff_res_data_i
                                           | {XLEN{ rf_ff_rs1_adr_match}}                         & rf_ff_res_data_q_i)
                      | {XLEN{rs1_is_immediat_q_i}}                                               & immediat_q_i
                      | {XLEN{auipc_q_i}}                                                         & pc_q_i;

assign rs1_data_extended  = {~unsign_extension_q_i   & rs1_data[31],
                              {XLEN{~csr_clear_q_i}} &  rs1_data
                            | {XLEN{ csr_clear_q_i}} & ~rs1_data};

assign rs1_data_nxt       = rs1_data_extended;
// Operand 2 value
assign rs2_data       = {XLEN{rs2_v_q_i & ~exe_ff_rs2_adr_match & ~rf_ff_rs2_adr_match}} & rs2_data_q_i       // no ff, no imm, data from RF
                      | {XLEN{rs2_v_q_i &  exe_ff_rs2_adr_match                       }} & exe_ff_res_data_i // exe ff
                      | {XLEN{rs2_v_q_i &  rf_ff_rs2_adr_match                        }} & rf_ff_res_data_q_i  // rf ff
                      | {XLEN{rs2_is_immediat_q_i                                     }} & immediat_q_i            // immediat_q_i
                      | {XLEN{rs2_is_csr_q_i & ~exe_ff_csr_adr_match                  }} & csr_data_q_i
                      | {XLEN{rs2_is_csr_q_i &  exe_ff_csr_adr_match                  }} & exe_ff_csr_data_i; // csr ff

assign rs2_data_extended  = {~unsign_extension_q_i & rs2_data[31], rs2_data};

assign rs2_data_nxt       = {XLEN+1{ rs2_ca2_v_q_i}} & ~rs2_data_extended + 32'b1
                          | {XLEN+1{~rs2_ca2_v_q_i}} &  rs2_data_extended;

// --------------------------------
//      Flopping outputs
// --------------------------------

always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
              wbk_v_q                  <= '0;
              wbk_adr_q                <= '0;
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
              mret_q                   <= '0;
              sret_q                   <= '0;
              ecall_q                  <= '0;
              ebreak_q                 <= '0;
  end else begin
              wbk_v_q                  <= wbk_v_q_i;
              wbk_adr_q                <= wbk_adr_q_i;
              rs1_data_q               <= rs1_data_nxt;
              rs2_data_q               <= rs2_data_nxt;
              immediat_q               <= immediat_q_i;
              instr_access_size_q      <= access_size_q_i;
              unsign_extension_q       <= unsign_extension_q_i;
              csrrw_q                  <= csrrw_q_i;
              instr_unit_q             <= unit_q_i;
              instr_operation_q        <= operation_q_i;
              pc_q_o                   <= pc_q_i;
              csr_adr_q                <= csr_adr_q_i;
              csr_wbk_q                <= csr_wbk_q_i;
              illegal_inst_q           <= illegal_inst_q_i;
              mret_q                   <= mret_q_i;
              sret_q                   <= sret_q_i;
              ecall_q                  <= ecall_q_i;
              ebreak_q                 <= ebreak_q_i;
  end

// --------------------------------
//      Ouputs
// --------------------------------
assign rd_v_q_o          = wbk_v_q;
assign rd_adr_q_o        = wbk_adr_q;
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
assign mret_q_o          = mret_q;
assign sret_q_o          = sret_q;
assign ecall_q_o         = ecall_q;
assign ebreak_q_o        = ebreak_q;

endmodule