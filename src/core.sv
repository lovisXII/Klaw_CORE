// This module is the top level and instanciate all the stages of the core
// Each internal signal follow the following convention :
// stage_description where stage is the name of the stage where the signal is coming from.
// - if  : ifetch
// - dec : decode
// - exe : execute
// - csr : csr register bank
// - rf  : register file
import riscv_pkg::*;

module core (
    // global interface
    input logic            clk,
    input logic            reset_n,
    input logic [XLEN-1:0] reset_adr_i,
    // --------------------------------
    //     Memory icache Interface
    // --------------------------------
    output logic [XLEN-1:0] icache_adr_o,
    input logic [31:0]      icache_instr_i,
    // --------------------------------
    //    Validation ports
    // --------------------------------
    `ifdef VALIDATION
    // rd
    output logic              val_wbk_v_q_o,
    output logic[NB_REGS-1:0] val_wbk_adr_q_o,
    output logic[XLEN-1:0]    val_wbk_data_q_o,
    // csr
    output logic              val_wbk_csr_v_q_o,
    output logic[11:0]        val_wbk_csr_adr_q_o,
    output logic[XLEN-1:0]    val_wbk_csr_data_q_o,
    // memory access
    output logic              val_adr_v_q_o,
    output logic [XLEN-1:0]   val_adr_q_o,
    output logic              val_store_v_q_o,
    output logic [XLEN-1:0]   val_store_data_q_o,
    // pc
    output logic[XLEN-1:0]    val_pc_o,
    `endif
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
// priviledge
logic [1:0]                 exe__core_mode_q;
logic                       dec__illegal_inst_q;
logic                       exe__sret_q;
logic                       dec__ecall_q;
logic                       dec__ebreak_q;
logic                       exe__mret_q;
logic                       exe__exception_q;
logic [XLEN-1:0]            exe__mcause_q;
logic [XLEN-1:0]            exe__mtval_q;
logic [XLEN-1:0]            exe__mepc_q;
logic [XLEN-1:0]            mepc_reg_q;
logic [XLEN-1:0]            csr__mtvec_reg_q;
// ifetch dec interface
logic                       exe__branch_v_q;
logic[31:0]                 if__instr_q;
logic[31:0]                 if__pc_q;
logic[XLEN-1:0]             dec__pc_q;
// dec rf interface
logic[NB_REGS-1:0]          dec__rs1_adr;
logic[XLEN-1:0]             rf__rs1_data;
logic[NB_REGS-1:0]          dec__rs2_adr;
logic[XLEN-1:0]             rf__rs2_data;
// dec exe interface
logic                       dec__rd_v_q;
logic[NB_REGS-1:0]          dec__rd_adr_q;
logic [XLEN:0]              dec__rs1_data_q;
logic [XLEN:0]              dec__rs2_data_q;
logic [XLEN-1:0]            dec__immediat_q;
logic [2:0]                 dec__access_size_q;
logic                       dec__unsign_extension_q;
logic                       dec__csrrw_q;
logic [NB_UNIT-1:0]         dec__unit_q;
logic [NB_OPERATION-1:0]    dec__operation_q;
logic                       dec__csr_wbk;
logic [11:0]                dec__csr_adr_q;
// dec csr interface
logic [11:0]                dec__csr__adr;
logic [XLEN-1:0]            csr__dec__data;
// exe dec interface
logic [XLEN-1:0]            exe__dec__ff_res_data;
logic [XLEN-1:0]            exe__dec__ff_csr_data;
logic                       exe__wbk_v_q;
logic [NB_REGS-1:0]         exe__wbk_adr_q;
logic [XLEN-1:0]            exe__wbk_data_q;
logic[XLEN-1:0]             exe__if__pc;
// exe csr interface
logic                       exe__csr_wbk_v_q;
logic [11:0]                exe__csr_adr_q;
logic [XLEN-1:0]            exe__csr_data;
logic                       exe__adr_v;
logic [XLEN-1:0]            adr;
logic                       store_v;
logic [XLEN-1:0]            store_data;
`ifdef VALIDATION
logic [XLEN-1:0]   exe__pc_q;
logic              val_adr_v_q;
logic [XLEN-1:0]   val_adr_q;
logic              val_store_v_q;
logic [XLEN-1:0]   val_store_data_q;
`endif

ifetch u_ifetch (
    // global interface
    .clk            (clk),
    .reset_n        (reset_n),
    .reset_adr_i    (reset_adr_i),
    // --------------------------------
    //     Icache
    // --------------------------------
    .icache_instr_i  (icache_instr_i),
    .icache_adr_o    (icache_adr_o),
    // --------------------------------
    //      EXE
    // --------------------------------
    .core_mode_q_i  (exe__core_mode_q),
    .branch_v_q_i   (exe__branch_v_q),
    .exception_q_i  (exe__exception_q),
    .pc_data_q_i    (exe__if__pc),
    // --------------------------------
    //      DEC
    // --------------------------------
    .instr_q_o      (if__instr_q),
    .pc_q_o         (if__pc_q)

);
dec u_decod(
  .clk                  (clk),
  .reset_n              (reset_n),
  // --------------------------------
  //      Ifetch Interface
  // --------------------------------
  .instr_q_i            (if__instr_q),
  .pc0_q_i              (if__pc_q),
  // --------------------------------
  //      RF Interface
  // --------------------------------
  .rf_rs1_adr_o         (dec__rs1_adr),
  .rf_rs1_data_i        (rf__rs1_data),
  .rf_rs2_adr_o         (dec__rs2_adr),
  .rf_rs2_data_i        (rf__rs2_data),
  .wbk_csr_adr_q_o      (dec__csr__adr),
  .csr_data_i           (csr__dec__data),
  // --------------------------------
  //      CSR Interface
  // --------------------------------
  .core_mode_q_i        (exe__core_mode_q),
  .exe_ff_res_data_i    (exe__dec__ff_res_data),
  .exe_ff_csr_data_i    (exe__dec__ff_csr_data),
  .rf_write_v_q_i       (exe__wbk_v_q),
  .rf_ff_rd_adr_q_i     (exe__wbk_adr_q),
  .rf_ff_res_data_q_i   (exe__wbk_data_q),
  .pc_q_o               (dec__pc_q),
  .rd_v_q_o             (dec__rd_v_q),
  .csr_wbk_q_o          (dec__csr_wbk),
  .csr_adr_q_o          (dec__csr_adr_q),
  .rd_adr_q_o           (dec__rd_adr_q),
  .rs1_data_qual_q_o    (dec__rs1_data_q),
  .rs2_data_qual_q_o    (dec__rs2_data_q),
  .branch_imm_q_o       (dec__immediat_q),
  .access_size_q_o      (dec__access_size_q),
  .unsign_ext_q_o       (dec__unsign_extension_q),
  .csrrw_q_o            (dec__csrrw_q),
  .unit_q_o             (dec__unit_q),
  .operation_q_o        (dec__operation_q),
  .illegal_inst_q_o     (dec__illegal_inst_q),
  .mret_q_o             (exe__mret_q),
  .sret_q_o             (exe__sret_q),
  .ecall_q_o            (dec__ecall_q),
  .ebreak_q_o           (dec__ebreak_q),
  .branch_v_q_i         (exe__branch_v_q)
);

exe u_exe(
  .clk                  ( clk),
  .reset_n              ( reset_n),
  // --------------------------------
  //      DEC
  // --------------------------------
  .pc_q_i               (dec__pc_q),
  .wbk_v_q_i            (dec__rd_v_q),
  .wbk_adr_q_i          (dec__rd_adr_q),
  .csr_wbk_i            (dec__csr_wbk),
  .csr_adr_i            (dec__csr_adr_q),
  .rs1_data_qual_q_i    (dec__rs1_data_q),
  .rs2_data_qual_q_i    (dec__rs2_data_q),
  .ecall_q_i            (dec__ecall_q),
  .ebreak_q_i           (dec__ebreak_q),
  .immediat_q_i         (dec__immediat_q),
  .access_size_q_i      (dec__access_size_q),
  .unsign_extension_q_i (dec__unsign_extension_q),
  .csrrw_q_i            (dec__csrrw_q),
  .unit_q_i             (dec__unit_q),
  .operation_q_i        (dec__operation_q),
  .illegal_inst_q_i     (dec__illegal_inst_q),
  .mret_q_i             (exe__mret_q),
  .sret_q_i             (exe__sret_q),
  // --------------------------------
  //      MEM
  // --------------------------------
  .adr_v_o              (exe__adr_v),
  .adr_o                (adr),
  .is_store_o           (is_store),
  .store_data_o         (store_data),
  .load_data_i          (load_data_i),
  .access_size_o        (access_size_o),
  // --------------------------------
  //      WBK
  // --------------------------------
  .exe_ff_res_data_o    (exe__dec__ff_res_data),
  .exe_ff_csr_data_o    (exe__dec__ff_csr_data),
  .core_mode_q_o        (exe__core_mode_q),
  .exception_q_o        (exe__exception_q),
  .mcause_q_o           (exe__mcause_q),
  .mtval_q_o            (exe__mtval_q),
  .mepc_q_o             (exe__mepc_q),
  .mtvec_q_i            (csr__mtvec_reg_q),
  .mepc_q_i             (mepc_reg_q),
  .wbk_v_q_o            (exe__wbk_v_q),
  .wbk_adr_q_o          (exe__wbk_adr_q),
  .wbk_data_q_o         (exe__wbk_data_q),
  .csr_wbk_v_q_o        (exe__csr_wbk_v_q),
  .csr_adr_q_o          (exe__csr_adr_q),
  .csr_data_q_o         (exe__csr_data),
  .branch_v_q_o         (exe__branch_v_q),
  `ifdef VALIDATION
  .pc_q_o               (exe__pc_q),
  `endif
  .pc_data_q_o          (exe__if__pc)
);

rf u_rf(
  .clk              (clk),
  .reset_n          (reset_n),
  .rs1_adr_i        (dec__rs1_adr),
  .rs1_data_o       (rf__rs1_data),
  .rs2_adr_i        (dec__rs2_adr),
  .rs2_data_o       (rf__rs2_data),
  .write_valid_i    (exe__wbk_v_q),
  .write_adr_i      (exe__wbk_adr_q),
  .write_data_i     (exe__wbk_data_q)

);

csr u_csr(
  .clk              (clk),
  .reset_n          (reset_n),
  .exception_q_i    (exe__exception_q),
  .mcause_q_i       (exe__mcause_q),
  .mtval_q_i        (exe__mtval_q),
  .mepc_q_i         (exe__mepc_q),
  .mtvec_q_o        (csr__mtvec_reg_q),
  .write_v_i        (exe__csr_wbk_v_q),
  .adr_read_i       (dec__csr__adr),
  .adr_write_i      (exe__csr_adr_q),
  .data_i           (exe__csr_data),
  .mepc_q_o         (mepc_reg_q),
  .data_o           (csr__dec__data)
);

// --------------------------------
//      OUTPUTS
// --------------------------------

assign adr_v_o        = exe__adr_v;
assign adr_o          = adr;
assign is_store_o     = is_store;
assign store_data_o   = store_data;

// --------------------------------
//      VALIDATION
// --------------------------------
`ifdef VALIDATION
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
    val_adr_v_q      <= '0;
    val_adr_q        <= '0;
    val_store_v_q   <= '0;
    val_store_data_q <= '0;
  end else begin
    val_adr_v_q      <= exe__adr_v;
    val_adr_q        <= adr;
    val_store_v_q    <= is_store;
    val_store_data_q <= store_data;
end
// rd
assign val_wbk_v_q_o          = exe__wbk_v_q;
assign val_wbk_adr_q_o        = exe__wbk_adr_q;
assign val_wbk_data_q_o       = exe__wbk_data_q;
// csr
assign val_wbk_csr_v_q_o      = exe__csr_wbk_v_q;
assign val_wbk_csr_adr_q_o    = exe__csr_adr_q;
assign val_wbk_csr_data_q_o   = exe__csr_data;
// branch
assign val_pc_o               = exe__pc_q;
// memory access
assign val_adr_v_q_o          = val_adr_v_q;
assign val_adr_q_o            = val_adr_q;
assign val_store_v_q_o        = val_store_v_q;
assign val_store_data_q_o     = val_store_data_q;
`endif

endmodule