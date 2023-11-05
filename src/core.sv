import riscv_pkg::*;

module core (
    // global interface
    input logic clk,
    input logic reset_n,
    input logic [XLEN-1:0] reset_adr_i,
    // --------------------------------
    //     Memory icache Interface
    // --------------------------------
    output logic [XLEN-1:0] icache_adr_o,
    input logic [31:0]      icache_instr_i,
    // --------------------------------
    //     Memory data interface
    // --------------------------------
    output logic            adr_v_o,
    output logic [XLEN-1:0] adr_o,
    output logic            is_store_o,
    output logic [XLEN-1:0] store_data_o,
    input logic  [XLEN-1:0] load_data_i,
    output logic [2:0]      access_size_o
);
// ifetch dec interface
logic                       flush_v_q;
logic[31:0]                 if_dec_q;
logic[31:0]                 if_dec_pc0_q;
logic[XLEN-1:0]             dec_exe_pc_q;
// dec rf interface
logic[NB_REGS-1:0]          dec_rf_rs1_adr;
logic[XLEN-1:0]             dec_rf_rs1_data;
logic[NB_REGS-1:0]          dec_rf_rs2_adr;
logic[XLEN-1:0]             dec_rf_rs2_data;
// dec exe interface
logic                       dec_exe_rd_v_q;
logic[NB_REGS-1:0]          dec_exe_rd_adr_q;
logic [XLEN:0]              dec_exe_rs1_data_q;
logic [XLEN:0]              dec_exe_rs2_data_q;
logic [XLEN-1:0]            exe_immediat_q;
logic [2:0]                 dec_exe_access_size_q;
logic                       dec_exe_unsign_extension_q;
logic [NB_UNIT-1:0]         dec_exe_unit_q;
logic [NB_OPERATION-1:0]    dec_exe_operation_q;
logic                       dec_exe_csr_wbk;
logic [11:0]                dec_exe_csr_adr_q;
// dec csr interface
logic [11:0]                dec_csr_adr;
logic [XLEN-1:0]            csr_dec_data;
// exe dec interface
logic                       exe_ff_write_v_q;
logic [NB_REGS-1:0]         exe_ff_rd_adr_q;
logic [XLEN-1:0]            exe_ff_res_data_q;
logic                       wbk_v_q;
logic [NB_REGS-1:0]         wbk_adr_q;
logic [XLEN-1:0]            wbk_data_q;
logic[XLEN-1:0]             exe_if_pc;
// exe csr interface
logic                       exe_csr_wbk_v_q;
logic [11:0]                exe_csr_adr_q;
logic [XLEN-1:0]            exe_csr_data;

ifetch u_ifetch (
    // global interface
    .clk            ( clk),
    .reset_n        ( reset_n),
    .reset_adr_i    ( reset_adr_i),
    // --------------------------------
    //     Icache
    // --------------------------------
    .icache_instr_i ( icache_instr_i),
    .icache_adr_o   ( icache_adr_o),
    // --------------------------------
    //      EXE
    // --------------------------------
    .flush_v_q_i    ( flush_v_q),
    .pc_data_q_i    ( exe_if_pc),
    // --------------------------------
    //      DEC
    // --------------------------------
    .instr_q_o      ( if_dec_q),
    .pc_q_o         ( if_dec_pc0_q)

);
dec u_decod(
  .clk                  ( clk),
  .reset_n              ( reset_n),
// --------------------------------
//      Ifetch Interface
// --------------------------------
  .instr_q_i            ( if_dec_q),
  .pc0_q_i              ( if_dec_pc0_q),
// --------------------------------
//      RF Interface
// --------------------------------
  .rfr_rs1_adr_o        ( dec_rf_rs1_adr),
  .rf_rs1_data_i        ( dec_rf_rs1_data),
  .rfr_rs2_adr_o        ( dec_rf_rs2_adr),
  .rf_rs2_data_i        ( dec_rf_rs2_data),
  .csr_adr_o            (dec_csr_adr),
  .csr_data_i           (csr_dec_data),
// --------------------------------
//      CSR Interface
// --------------------------------
  .exe_ff_write_v_q_i   ( exe_ff_write_v_q),
  .exe_ff_rd_adr_q_i    ( exe_ff_rd_adr_q),
  .exe_ff_res_data_q_i  ( exe_ff_res_data_q),
  .rf_write_v_q_i       ( wbk_v_q),
  .rf_ff_rd_adr_q_i     ( wbk_adr_q),
  .rf_ff_res_data_q_i   ( wbk_data_q),
  .pc_q_o               ( dec_exe_pc_q),
  .rd_v_q_o             ( dec_exe_rd_v_q),
  .csr_wbk_q_o          (dec_exe_csr_wbk),
  .csr_adr_q_o          (dec_exe_csr_adr_q),
  .rd_adr_q_o           ( dec_exe_rd_adr_q),
  .rs1_data_qual_q_o    ( dec_exe_rs1_data_q),
  .rs2_data_qual_q_o    ( dec_exe_rs2_data_q),
  .branch_imm_q_o       ( exe_immediat_q),
  .access_size_q_o      ( dec_exe_access_size_q),
  .unsign_ext_q_o       ( dec_exe_unsign_extension_q),
  .unit_q_o             ( dec_exe_unit_q),
  .operation_q_o        ( dec_exe_operation_q),
  .flush_v_q_i          ( flush_v_q)
);

exe u_exe(
  .clk                  ( clk),
  .reset_n              ( reset_n),
// --------------------------------
//      DEC
// --------------------------------
  .pc_q_i               ( dec_exe_pc_q),
  .rd_v_q_i             ( dec_exe_rd_v_q),
  .rd_adr_q_i           ( dec_exe_rd_adr_q),
  .csr_wbk_i            (dec_exe_csr_wbk),
  .csr_adr_i            (dec_exe_csr_data),
  .rs1_data_qual_q_i    ( dec_exe_rs1_data_q),
  .rs2_data_qual_q_i    ( dec_exe_rs2_data_q),
  .immediat_q_i         ( exe_immediat_q),
  .access_size_q_i      ( dec_exe_access_size_q),
  .unsign_extension_q_i ( dec_exe_unsign_extension_q),
  .unit_q_i             ( dec_exe_unit_q),
  .operation_q_i        ( dec_exe_operation_q),
// --------------------------------
//      MEM
// --------------------------------
  .adr_v_o              ( adr_v_o),
  .adr_o                ( adr_o),
  .is_store_o           ( is_store_o),
  .store_data_o         ( store_data_o),
  .load_data_i          ( load_data_i),
  .access_size_o        ( access_size_o),
// --------------------------------
//      WBK
// --------------------------------
  .exe_ff_w_v_q_o       ( exe_ff_write_v_q),
  .exe_ff_rd_adr_q_o    ( exe_ff_rd_adr_q),
  .exe_ff_res_data_q_o  ( exe_ff_res_data_q),
  .wbk_v_q_o            ( wbk_v_q),
  .wbk_adr_q_o          ( wbk_adr_q),
  .wbk_data_q_o         ( wbk_data_q),
  .csr_wbk_v_q_o        (exe_csr_wbk_v_q),
  .csr_adr_q_o          (exe_csr_adr_q),
  .csr_data_q_o         (exe_csr_data),
  .flush_v_q_o          ( flush_v_q),
  .pc_data_q_o          ( exe_if_pc)
);

rf u_rf(
  .clk              ( clk),
  .reset_n          ( reset_n),
  .rs1_adr_i        ( dec_rf_rs1_adr),
  .rs1_data_o       ( dec_rf_rs1_data),
  .rs2_adr_i        ( dec_rf_rs2_adr),
  .rs2_data_o       ( dec_rf_rs2_data),
  .write_valid_i    ( wbk_v_q),
  .write_adr_i      ( wbk_adr_q),
  .write_data_i     ( wbk_data_q)

);

csr u_csr(
  .clk              (clk),
  .reset_n          (reset_n),
  .write_v_i        (exe_csr_wbk_v_q),
  .adr_read_i       (dec_csr_adr),
  .adr_write_i      (exe_csr_adr_q),
  .data_i           (exe_csr_data),
  .data_o           (csr_dec_data)
);

endmodule