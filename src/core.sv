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
    output logic [2:0]      access_size_o,

    //Added outputs for checking //

    output logic              write_valid_o,
    output logic[31:0]        write_data_o,
    output logic[NB_REGS-1:0] write_adr_o,
    output logic[31:0]        pc_val_o,
    output logic[31:0]        pc_val_mem_o,

    output logic              write_csr_v_o,
    output logic[11:0]        csr_adr_o,
    output logic[31:0]        csr_data_o

);
// priviledge
logic [1:0]                 core_mode_q;
logic                       illegal_inst_q;
logic                       sret_q;
logic                       mret_q;
logic                       exception_q;
logic [XLEN-1:0]            mcause_q;
logic [XLEN-1:0]            mtval_q;
logic [XLEN-1:0]            mepc_q;
logic [XLEN-1:0]            mepc_reg_q;
logic [XLEN-1:0]            mtvec_reg_q;
// ifetch dec interface
logic                       branch_v_q;
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
logic                       csrrw_q;
logic [NB_UNIT-1:0]         dec_exe_unit_q;
logic [NB_OPERATION-1:0]    dec_exe_operation_q;
logic                       dec_exe_csr_wbk;
logic [11:0]                dec_exe_csr_adr_q;
// dec csr interface
logic [11:0]                dec_csr_adr;
logic [XLEN-1:0]            csr_dec_data;
// exe dec interface
logic [XLEN-1:0]            exe_ff_res_data;
logic [XLEN-1:0]            exe_ff_csr_data;
logic                       wbk_v_q;
logic [NB_REGS-1:0]         wbk_adr_q;
logic [XLEN-1:0]            wbk_data_q;
logic[XLEN-1:0]             exe_if_pc;
// exe csr interface
logic                       exe_csr_wbk_v_q;
logic [11:0]                exe_csr_adr_q;
logic [XLEN-1:0]            exe_csr_data;
logic [XLEN-1:0]            pc_q_o;


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
    .core_mode_q_i  (core_mode_q),
    .branch_v_q_i   ( branch_v_q),
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
  .rf_rs1_adr_o        ( dec_rf_rs1_adr),
  .rf_rs1_data_i        ( dec_rf_rs1_data),
  .rf_rs2_adr_o        ( dec_rf_rs2_adr),
  .rf_rs2_data_i        ( dec_rf_rs2_data),
  .csr_adr_o            (dec_csr_adr),
  .csr_data_i           (csr_dec_data),
// --------------------------------
//      CSR Interface
// --------------------------------
  .core_mode_q_i        (core_mode_q),
  .exe_ff_res_data_i    (exe_ff_res_data),
  .exe_ff_csr_data_i    (exe_ff_csr_data),
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
  .csrrw_q_o            (csrrw_q),
  .unit_q_o             ( dec_exe_unit_q),
  .operation_q_o        ( dec_exe_operation_q),
  .illegal_inst_q_o     (illegal_inst_q),
  .mret_q_o             (mret_q),
  .sret_q_o             (sret_q),
  .branch_v_q_i         ( branch_v_q)
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
  .csr_adr_i            (dec_exe_csr_adr_q),
  .rs1_data_qual_q_i    ( dec_exe_rs1_data_q),
  .rs2_data_qual_q_i    ( dec_exe_rs2_data_q),
  .immediat_q_i         ( exe_immediat_q),
  .access_size_q_i      ( dec_exe_access_size_q),
  .unsign_extension_q_i ( dec_exe_unsign_extension_q),
  .csrrw_q_i            (csrrw_q),
  .unit_q_i             ( dec_exe_unit_q),
  .operation_q_i        ( dec_exe_operation_q),
  .illegal_inst_q_i     (illegal_inst_q),
  .mret_q_i             (mret_q),
  .sret_q_i             (sret_q),
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
  .exe_ff_res_data_o    (exe_ff_res_data),
  .exe_ff_csr_data_o    (exe_ff_csr_data),
  .core_mode_q_o        (core_mode_q),
  .exception_q_o        (exception_q),
  .mcause_q_o           (mcause_q),
  .mtval_q_o            (mtval_q),
  .mepc_q_o             (mepc_q),
  .mtvec_q_i            (mtvec_reg_q),
  .mepc_q_i             (mepc_reg_q),
  .wbk_v_q_o            ( wbk_v_q),
  .wbk_adr_q_o          ( wbk_adr_q),
  .wbk_data_q_o         ( wbk_data_q),
  .csr_wbk_v_q_o        (exe_csr_wbk_v_q),
  .csr_adr_q_o          (exe_csr_adr_q),
  .csr_data_q_o         (exe_csr_data),
  .branch_v_q_o         ( branch_v_q),
  .pc_data_q_o          ( exe_if_pc),
  .pc_q_o               ( pc_q_o)
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
  .exception_q_i    (exception_q),
  .mcause_q_i       (mcause_q),
  .mtval_q_i        (mtval_q),
  .mepc_q_i         (mepc_q),
  .mtvec_q_o        (mtvec_reg_q),
  .write_v_i        (exe_csr_wbk_v_q),
  .adr_read_i       (dec_csr_adr),
  .adr_write_i      (exe_csr_adr_q),
  .data_i           (exe_csr_data),
  .mepc_q_o         (mepc_reg_q),
  .data_o           (csr_dec_data)
);
//Checker
assign write_adr_o    = wbk_adr_q;
assign write_data_o   = wbk_data_q;
assign write_valid_o  = wbk_v_q;
assign pc_val_o       = pc_q_o;
assign pc_val_mem_o   = dec_exe_pc_q;
assign write_csr_v_o  = exe_csr_wbk_v_q;
assign csr_adr_o      = exe_csr_adr_q;
assign csr_data_o     = exe_csr_data;

endmodule