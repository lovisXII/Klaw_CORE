import riscv_pkg::*;

module dec0 (
  input logic                 clk,
  input logic                 reset_n,
// --------------------------------
//      Ifetch Interface
// --------------------------------
  input logic [XLEN-1:0]             instr_q_i,
  input logic [XLEN-1:0]             pc_q_i,
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
  output logic [11:0]                 wbk_csr_adr_q_o,
  input  logic [XLEN-1:0]             csr_data_i,
// --------------------------------
//      Execute Interface
// --------------------------------
  // Flush signals
  input  logic                       branch_v_q_i,
  // ff from EXE
  input logic                        exe_wbk_v_adr_q_i,
  input logic [4:0]                  exe_wbk_adr_q_i,
  input logic [XLEN-1:0]             exe_wbk_data_q_i,
  input logic                        exe_csr_wbk_v_adr_q_i,
  input logic [11:0]                 exe_wbk_csr_q_i,
  input logic [XLEN-1:0]             exe_csr_data_q_i,
// --------------------------------
//      dec1 Interface
// --------------------------------
  // PC
  output logic [XLEN-1:0]            pc_q_o,
  // Registers Destination
  output logic                       wbk_v_q_o,
  output logic [4:0]                 wbk_adr_q_o,
  // Csr destination
  output logic                       csr_wbk_q_o,
  output logic [11:0]                csr_adr_q_o,
  output logic [XLEN-1:0]            csr_data_q_o,
  // Source registers
  output logic                       rs1_v_q_o,
  output logic [4:0]                 rs1_adr_q_o,
  output logic [XLEN-1:0]            rs1_data_q_o,
  output logic                       rs2_v_q_o,
  output logic [4:0]                 rs2_adr_q_o,
  output logic [XLEN-1:0]            rs2_data_q_o,
  // Execution Unit useful information
  output logic                       csr_clear_q_o,
  output logic                       ecall_q_o,
  output logic                       ebreak_q_o,
  output logic                       auipc_q_o,
  output logic                       rs1_is_immediat_q_o,
  output logic                       rs2_is_immediat_q_o,
  output logic                       rs2_is_csr_q_o,
  output logic [XLEN-1:0]            immediat_q_o,
  output logic [2:0]                 access_size_q_o,
  output logic                       unsign_extension_q_o,
  output logic                       csrrw_q_o,
  output logic [NB_UNIT-1:0]         unit_q_o,
  output logic [NB_OPERATION-1:0]    operation_q_o,
  output logic                       rs2_ca2_v_q_o,
  output logic                       illegal_inst_q_o,
  output logic                       mret_q_o,
  output logic                       sret_q_o
);
// --------------------------------
//      Signals declaration
// --------------------------------
  // rd
  logic                       wbk_v;
  logic                       wbk_v_nxt;
  logic [4:0]                 wbk_adr_nxt;
  // rs1
  logic                       rs1_v;
  logic [4:0]                 rs1_adr;
  logic dec0_exe_rs1_adr_match;
  logic [XLEN-1:0] rs1_data_nxt;
  // rs2
  logic                       rs2_v;
  logic [4:0]                 rs2_adr;
  logic dec0_exe_rs2_adr_match;
  logic [XLEN-1:0] rs2_data_nxt;
  // csr
  logic dec0_exe_csr_adr_match;
  logic [XLEN-1:0] csr_data_nxt;
  logic                       rs2_is_csr;
  logic                       csr_clear;
  logic                       csr_wbk_nxt;
  logic [11:0]                csr_adr;
  logic [11:0]                csr_adr_nxt;
  logic                       ecall;
  logic                       ebreak;
  // Exceptions
  logic                       illegal_inst;
  logic                       illegal_inst_nxt;
  logic                       mret_nxt;
  logic                       sret_nxt;
  // Additionnal informations
  logic [XLEN-1:0]            immediat;
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
  logic                       reset_n_q;

  logic                       wbk_v_q;
  logic [4:0]                 wbk_adr_q;
  logic                       csr_wbk_q;

  logic                       rs1_v_q;
  logic [4:0]                 rs1_adr_q;
  logic [XLEN-1:0]              rs1_data_q;

  logic                       rs2_v_q;
  logic [4:0]                 rs2_adr_q;
  logic [XLEN-1:0]            rs2_data_q;

  logic [XLEN-1:0]            csr_data_q;
  logic                       csr_clear_q;
  logic [11:0]  csr_adr_q;
  logic                       ecall_q;
  logic                       ebreak_q;
  logic                       auipc_q;
  logic                       rs1_is_immediat_q;
  logic                       rs2_is_immediat_q;
  logic                       rs2_is_csr_q;
  logic [XLEN-1:0]            immediat_q;
  logic [2:0]                 access_size_q;
  logic                       unsign_extension_q;
  logic                       csrrw_q;
  logic [NB_UNIT-1:0]         unit_q;
  logic [NB_OPERATION-1:0]    operation_q;
  logic                       rs2_ca2_v_q;
  logic                       illegal_inst_q;
  logic                       mret_q;
  logic                       sret_q;
// --------------------------------
//      Decoder
// --------------------------------
decoder u_decoder0(
    .instr_i              (instr_q_i),
    .wbk_v_o              (wbk_v),
    .wbk_adr_o            (wbk_adr_nxt),
    .csr_wbk_o            (csr_wbk_nxt),
    .csr_clear_o          (csr_clear),
    .wbk_csr_adr_o        (csr_adr),
    .rs1_v_o              (rs1_v),
    .rs1_adr_o            (rs1_adr),
    .rs2_v_o              (rs2_v),
    .rs2_adr_o            (rs2_adr),
    .ecall_o              (ecall),
    .ebreak_o             (ebreak),
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
    .illegal_inst_o       (illegal_inst),
    .mret_o               (mret_nxt),
    .sret_o               (sret_nxt)
);


// --------------------------------
//      Internal architecture
// --------------------------------
assign wbk_v_nxt        = wbk_v & ~branch_v_q_i;
// exception
// if not done exception will be raised when reset is high during the first cycle
assign illegal_inst_nxt = illegal_inst & reset_n_q;

// Check if bypass will be needed in d1
assign dec0_exe_rs1_adr_match = (rs1_adr == exe_wbk_adr_q_i) & exe_wbk_v_adr_q_i;
assign dec0_exe_rs2_adr_match = (rs2_adr == exe_wbk_adr_q_i) & exe_wbk_v_adr_q_i;

assign rs1_data_nxt = {32{ dec0_exe_rs1_adr_match}} & exe_wbk_data_q_i
                    | {32{~dec0_exe_rs1_adr_match}} & rf_rs1_data_i;

assign rs2_data_nxt = {32{ dec0_exe_rs2_adr_match}} & exe_wbk_data_q_i
                    | {32{~dec0_exe_rs2_adr_match}} & rf_rs2_data_i;

assign dec0_exe_csr_adr_match = (csr_adr == exe_wbk_csr_q_i) & exe_csr_wbk_v_adr_q_i;

assign csr_data_nxt = {32{ dec0_exe_csr_adr_match}} & exe_csr_data_q_i
                    | {32{~dec0_exe_csr_adr_match}} & csr_data_i;
// --------------------------------
//      Flopping outputs
// --------------------------------

// Validity flops
// --------------------------------
always_ff @(posedge clk, negedge reset_n) begin
  if (!reset_n) begin
              wbk_v_q    <= '0;
              csr_wbk_q  <= '0;
              rs1_v_q    <= '0;
              rs2_v_q    <= '0;
  end else begin
              wbk_v_q     <= wbk_v_nxt;
              csr_wbk_q   <= csr_wbk_nxt;
              rs1_v_q     <= rs1_v;
              rs2_v_q     <= rs2_v;
  end
end

always_ff @(posedge clk) begin
  if (wbk_v_nxt) begin
              wbk_adr_q <= wbk_adr_nxt;
  end
end

// rs1 flops
// --------------------------------
always_ff @(posedge clk, negedge reset_n) begin
  if (rs1_v) begin
              rs1_adr_q  <= rs1_adr;
              rs1_data_q <= rs1_data_nxt;

  end
end

// rs2 flops
// --------------------------------
always_ff @(posedge clk, negedge reset_n) begin
  if (rs2_v) begin
              rs2_adr_q  <= rs2_adr;
              rs2_data_q <= rs2_data_nxt;
  end
end

// csr flops
// --------------------------------
always_ff @(posedge clk, negedge reset_n) begin
  if (csr_wbk_nxt | rs2_is_csr) begin
              csr_data_q  <= csr_data_nxt;
  end
end

// other flops
// --------------------------------
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
              reset_n_q              <= '0;
              pc_q_o                 <= '0;
              csr_clear_q            <= '0;
              csr_adr_q              <= '0;
              ecall_q                <= '0;
              ebreak_q               <= '0;
              auipc_q                <= '0;
              rs1_is_immediat_q      <= '0;
              rs2_is_immediat_q      <= '0;
              rs2_is_csr_q           <= '0;
              immediat_q             <= '0;
              access_size_q          <= '0;
              unsign_extension_q     <= '0;
              csrrw_q                <= '0;
              unit_q                 <= '0;
              operation_q            <= '0;
              rs2_ca2_v_q            <= '0;
              illegal_inst_q         <= '0;
              mret_q                 <= '0;
              sret_q                 <= '0;
  end else begin
              reset_n_q              <= reset_n;
              pc_q_o                 <= pc_q_i;
              csr_clear_q            <= csr_clear;
              csr_adr_q              <= csr_adr;
              ecall_q                <= ecall;
              ebreak_q               <= ebreak;
              auipc_q                <= auipc;
              rs1_is_immediat_q      <= rs1_is_immediat;
              rs2_is_immediat_q      <= rs2_is_immediat;
              rs2_is_csr_q           <= rs2_is_csr;
              immediat_q             <= immediat;
              access_size_q          <= instr_access_size_nxt;
              unsign_extension_q     <= unsign_extension;
              csrrw_q                <= csrrw_nxt;
              unit_q                 <= unit_nxt;
              operation_q            <= operation;
              rs2_ca2_v_q            <= rs2_ca2_v;
              illegal_inst_q         <= illegal_inst_nxt;
              mret_q                 <= mret_nxt;
              sret_q                 <= sret_nxt;
  end
// --------------------------------
//      Ouputs
// --------------------------------

// to rf reg bank
//---------------------------------
assign rf_rs1_adr_o           = rs1_adr;
assign rf_rs2_adr_o           = rs2_adr;

// to csr reg bank
//---------------------------------
assign wbk_csr_adr_q_o        = csr_adr;

// to dec1
//---------------------------------
// rd wbk
assign wbk_v_q_o              = wbk_v_q;
assign wbk_adr_q_o            = wbk_adr_q;
// csr wbk
assign csr_wbk_q_o            = csr_wbk_q;
assign csr_adr_q_o            = csr_adr_q;
assign csr_data_q_o           = csr_data_q;
// rs1
assign rs1_v_q_o              = rs1_v_q;
assign rs1_adr_q_o            = rs1_adr_q;
assign rs1_data_q_o           = rs1_data_q;
// rs2
assign rs2_v_q_o              = rs2_v_q;
assign rs2_adr_q_o            = rs2_adr_q;
assign rs2_data_q_o           = rs2_data_q;

// additionnal informations
assign csr_clear_q_o          = csr_clear_q;
assign ecall_q_o              = ecall_q;
assign ebreak_q_o             = ebreak_q;
assign auipc_q_o              = auipc_q;
assign rs1_is_immediat_q_o    = rs1_is_immediat_q;
assign rs2_is_immediat_q_o    = rs2_is_immediat_q;
assign rs2_is_csr_q_o         = rs2_is_csr_q;
assign immediat_q_o           = immediat_q;
assign access_size_q_o        = access_size_q;
assign unsign_extension_q_o   = unsign_extension_q;
assign csrrw_q_o              = csrrw_q;
assign unit_q_o               = unit_q;
assign operation_q_o          = operation_q;
assign rs2_ca2_v_q_o          = rs2_ca2_v_q;
assign illegal_inst_q_o       = illegal_inst_q;
assign mret_q_o               = mret_q;
assign sret_q_o               = sret_q;

endmodule