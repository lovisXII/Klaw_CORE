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
logic                       flush_v_q;
logic[31:0]                 if_dec_instr_q;
logic[31:0]                 if_dec_pc0_q;
logic[XLEN-1:0]             dec_exe_pc0_q;
logic[NB_REGS-1:0]          dec_rf_instr_rs1_adr;
logic[XLEN-1:0]             dec_rf_instr_rs1_data;
logic[NB_REGS-1:0]          dec_rf_instr_rs2_adr;
logic[XLEN-1:0]             dec_rf_instr_rs2_data;
logic                       dec_exe_instr_rd_v_q;
logic[NB_REGS-1:0]          dec_exe_rd_adr_q;
logic [XLEN:0]              dec_exe_rs1_data_q;
logic [XLEN:0]              dec_exe_rs2_data_q;
logic [XLEN-1:0]            exe_immediat_q;
logic [2:0]                 dec_exe_instr_access_size_q;
logic                       dec_exe_unsign_extension_q;
logic [NB_UNIT-1:0]         dec_exe_instr_unit_q;
logic [NB_OPERATION-1:0]    dec_exe_instr_operation_q;
logic                       exe_ff_write_v_q;
logic [NB_REGS-1:0]         exe_ff_rd_adr_q;
logic [XLEN-1:0]            exe_ff_res_data_q;
logic                       exe_rf_instr_write_valid;
logic [NB_REGS-1:0]         exe_rf_instr_write_adr;
logic [XLEN-1:0]            exe_rf_instr_write_data;
logic[XLEN-1:0]             exe_if_pc0_write_data;


ifetch u_ifetch (
    .clk            ( clk),
    .reset_n        ( reset_n),
    .reset_adr_i    ( reset_adr_i),
    .icache_instr_i ( icache_instr_i),
    .icache_adr_o   ( icache_adr_o),
    .flush_v_q_i    ( flush_v_q),
    .pc_data_q_i    ( exe_if_pc0_write_data),
    .instr_q_o      ( if_dec_instr_q),
    .pc_q_o         ( if_dec_pc0_q)

);
dec u_decod(
  .clk                  ( clk),
  .reset_n              ( reset_n),
  .instr_q_i            ( if_dec_instr_q),
  .pc0_q_i              ( if_dec_pc0_q),
  .rfr_rs1_adr_o        ( dec_rf_instr_rs1_adr),
  .rf_rs1_data_i        ( dec_rf_instr_rs1_data),
  .rfr_rs2_adr_o        ( dec_rf_instr_rs2_adr),
  .rf_rs2_data_i        ( dec_rf_instr_rs2_data),
  .exe_ff_write_v_q_i   ( exe_ff_write_v_q),
  .exe_ff_rd_adr_q_i    ( exe_ff_rd_adr_q),
  .exe_ff_res_data_q_i  ( exe_ff_res_data_q),
  .rf_write_v_q_i       ( exe_rf_instr_write_valid),
  .rf_ff_rd_adr_q_i     ( exe_rf_instr_write_adr),
  .rf_ff_res_data_q_i   ( exe_rf_instr_write_data),
  .pc_q_o               ( dec_exe_pc0_q),
  .rd_v_q_o             ( dec_exe_instr_rd_v_q),
  .rd_adr_q_o           ( dec_exe_rd_adr_q),
  .rs1_data_qual_q_o    ( dec_exe_rs1_data_q),
  .rs2_data_qual_q_o    ( dec_exe_rs2_data_q),
  .branch_imm_q_o       ( exe_immediat_q),
  .access_size_q_o      ( dec_exe_instr_access_size_q),
  .unsign_ext_q_o       ( dec_exe_unsign_extension_q),
  .unit_q_o             ( dec_exe_instr_unit_q),
  .operation_q_o        ( dec_exe_instr_operation_q),
  .flush_v_q_i          ( flush_v_q)

);

exe u_exe(
  .clk                  ( clk),
  .reset_n              ( reset_n),
  .dec_pc0_q_i          ( dec_exe_pc0_q),
  .rd_v_q_i             ( dec_exe_instr_rd_v_q),
  .rd_adr_q_i           ( dec_exe_rd_adr_q),
  .rs1_data_qual_q_i    ( dec_exe_rs1_data_q),
  .rs2_data_qual_q_i    ( dec_exe_rs2_data_q),
  .immediat_q_i         ( exe_immediat_q),
  .access_size_q_i      ( dec_exe_instr_access_size_q),
  .unsign_extension_q_i ( dec_exe_unsign_extension_q),
  .unit_q_i             ( dec_exe_instr_unit_q),
  .operation_q_i        ( dec_exe_instr_operation_q),
  .adr_v_o              ( adr_v_o),
  .adr_o                ( adr_o),
  .is_store_o           ( is_store_o),
  .store_data_o         ( store_data_o),
  .load_data_i          ( load_data_i),
  .access_size_o        ( access_size_o),
  .exe_ff_write_v_q_o   ( exe_ff_write_v_q),
  .exe_ff_rd_adr_q_o    ( exe_ff_rd_adr_q),
  .exe_ff_res_data_q_o  ( exe_ff_res_data_q),
  .res_w_v_q_o          ( exe_rf_instr_write_valid),
  .instr_write_adr_q_o  ( exe_rf_instr_write_adr),
  .instr_wbk_data_q_o   ( exe_rf_instr_write_data),
  .flush_v_q_o          ( flush_v_q),
  .pc_data_q_o          ( exe_if_pc0_write_data)
);

rf u_rf(
  .clk              ( clk),
  .reset_n          ( reset_n),
  .rs1_adr_i        ( dec_rf_instr_rs1_adr),
  .rs1_data_o       ( dec_rf_instr_rs1_data),
  .rs2_adr_i        ( dec_rf_instr_rs2_adr),
  .rs2_data_o       ( dec_rf_instr_rs2_data),
  .write_valid_i    ( exe_rf_instr_write_valid),
  .write_adr_i      ( exe_rf_instr_write_adr),
  .write_data_i     ( exe_rf_instr_write_data)

);

endmodule