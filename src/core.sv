// This module is the top level and instanciate all the stages of the core
// Each internal signal follow the following convention :
// stage_description where stage is the name of the stage where the signal is coming from.
// - if  : ifetch
// - dec0 : decode0
// - dec1 : decode1
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
    output logic            store_v_o,
    output logic [XLEN-1:0] store_data_o,
    input logic  [XLEN-1:0] load_data_i,
    output logic [2:0]      access_size_o
);
//----------------------------
//    IFETCH-DEC0 INTERFACE
//----------------------------
logic [31:0]             if__instr_q;
logic [31:0]             if__pc_q;
//----------------------------
//    DEC0-RF INTERFACE
//----------------------------
logic [NB_REGS-1:0]      dec0__rs1_adr;
logic [XLEN-1:0]         rf__rs1_data;
logic [NB_REGS-1:0]      dec0__rs2_adr;
logic [XLEN-1:0]         rf__rs2_data;
//----------------------------
//    DEC0-CSR INTERFACE
//----------------------------
logic [11:0]             dec0__csr_adr;
//----------------------------
//    DEC0-DEC1 INTERFACE
//----------------------------
logic [XLEN-1:0]         dec0__pc_q;
logic                    dec0__wbk_v_q;
logic [4:0]              dec0__wbk_adr_q;
logic                    dec0__csr_wbk_q;
logic [11:0]             dec0__csr_adr_q;
logic [XLEN-1:0]         dec0__csr_data_q;
logic                    dec0__rs1_v_q;
logic [4:0]              dec0__rs1_adr_q;
logic [XLEN-1:0]         dec0__rs1_data_q;
logic                    dec0__rs2_v_q;
logic [4:0]              dec0__rs2_adr_q;
logic [XLEN-1:0]         dec0__rs2_data_q;
logic                    dec0__csr_clear_q;
logic                    dec0__ecall_q;
logic                    dec0__ebreak_q;
logic                    dec0__auipc_q;
logic                    dec0__rs1_is_immediat_q;
logic                    dec0__rs2_is_immediat_q;
logic                    dec0__rs2_is_csr_q;
logic [XLEN-1:0]         dec0__immediat_q;
logic [2:0]              dec0__access_size_q;
logic                    dec0__unsign_extension_q;
logic                    dec0__csrrw_q;
logic [NB_UNIT-1:0]      dec0__unit_q;
logic [NB_OPERATION-1:0] dec0__operation_q;
logic                    dec0__rs2_ca2_v_q;
logic                    dec0__illegal_inst_q;
logic                    dec0__mret_q;
logic                    dec0__sret_q;
//----------------------------
//    DEC1-EXE INTERFACE
//----------------------------
logic [XLEN-1:0]         dec1__pc_q;
logic                    dec1__wbk_v_q;
logic [4:0]              dec1__rd_adr_q;
logic                    dec1__csr_wbk;
logic [11:0]             dec1__csr_adr_q;
logic [XLEN:0]           dec1__rs1_data_q;
logic [XLEN:0]           dec1__rs2_data_q;
logic [XLEN-1:0]         dec1__immediat_q;
logic [2:0]              dec1__access_size_q;
logic                    dec1__unsign_extension_q;
logic                    dec1__csrrw_q;
logic [NB_UNIT-1:0]      dec1__unit_q;
logic [NB_OPERATION-1:0] dec1__operation_q;
logic                    dec1__illegal_inst_q;
logic                    dec1__ecall_q;
logic                    dec1__ebreak_q;
//----------------------------
//    EXE-CORE INTERFACE
//----------------------------
logic                    exe__adr_v;
logic [XLEN-1:0]         exe__adr;
logic                    exe__store_v;
logic [XLEN-1:0]         store_data;
//----------------------------
//    EXE-RF INTERFACE
//----------------------------
logic [XLEN-1:0]         exe__if__pc;
logic [1:0]              exe__core_mode_q;
logic                    exe__sret_q;
logic                    exe__mret_q;
logic                    exe__exception_q;
logic [XLEN-1:0]         exe__mstatus_q;
logic [XLEN-1:0]         exe__mcause_q;
logic [XLEN-1:0]         exe__mtval_q;
logic [XLEN-1:0]         exe__mepc_q;
logic                    exe__wbk_v_q;
logic [NB_REGS-1:0]      exe__wbk_adr_q;
logic [XLEN-1:0]         exe__wbk_data_q;
//----------------------------
//    EXE-DEC1 INTERFACE
//----------------------------
logic                    exe__branch_v_q;
logic [XLEN-1:0]         exe__ff_res_data;
logic [XLEN-1:0]         exe__ff_csr_data;
//----------------------------
//    EXE-CSR INTERFACE
//----------------------------
logic                    exe__csr_wbk_v_q;
logic [11:0]             exe__csr_adr_q;
logic [XLEN-1:0]         exe__csr_data_q;
//----------------------------
//    CSR-EXE INTERFACE
//----------------------------
logic [XLEN-1:0]         mepc_reg_q;
logic [XLEN-1:0]         csr__mtvec_reg_q;
logic [XLEN-1:0]         csr__mstatus_reg_q;
//----------------------------
//    CSR-DEC INTERFACE
//----------------------------
logic [XLEN-1:0]         csr__dec__data;
// exe csr interface
`ifdef VALIDATION
logic [XLEN-1:0]         exe__pc_q;
logic                    val_adr_v_q;
logic [XLEN-1:0]         val_adr_q;
logic                    val_store_v_q;
logic [XLEN-1:0]         val_store_data_q;
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
    .branch_v_q_i   (exe__branch_v_q),
    .exception_q_i  (exe__exception_q),
    .pc_data_q_i    (exe__if__pc),
    // --------------------------------
    //      DEC
    // --------------------------------
    .instr_q_o      (if__instr_q),
    .pc_q_o         (if__pc_q)

);
dec0 u_decod0(
  .clk                  (clk),
  .reset_n              (reset_n),
  // --------------------------------
  //      Ifetch Interface
  // --------------------------------
  .instr_q_i           (if__instr_q),
  .pc_q_i              (if__pc_q),
  // --------------------------------
  //      RF Interface
  // --------------------------------
  .rf_rs1_adr_o         (dec0__rs1_adr),
  .rf_rs1_data_i        (rf__rs1_data),
  .rf_rs2_adr_o         (dec0__rs2_adr),
  .rf_rs2_data_i        (rf__rs2_data),
  // --------------------------------
  //      CSR Interface
  // --------------------------------
  .wbk_csr_adr_q_o      (dec0__csr_adr),
  .csr_data_i           (csr__dec__data),
  // --------------------------------
  //      Execute Interface
  // --------------------------------
  .branch_v_q_i          (exe__branch_v_q),
  .exe_wbk_v_adr_q_i     (exe__wbk_v_q),
  .exe_wbk_adr_q_i       (exe__wbk_adr_q),
  .exe_wbk_data_q_i      (exe__wbk_data_q),
  .exe_csr_wbk_v_adr_q_i (exe__csr_wbk_v_q),
  .exe_wbk_csr_q_i       (exe__csr_adr_q),
  .exe_csr_data_q_i      (exe__csr_data_q),
  // --------------------------------
  //      dec1 Interface
  // --------------------------------
  .pc_q_o               (dec0__pc_q),
  .wbk_v_q_o            (dec0__wbk_v_q),
  .wbk_adr_q_o          (dec0__wbk_adr_q),
  .csr_wbk_q_o          (dec0__csr_wbk_q),
  .csr_adr_q_o          (dec0__csr_adr_q),
  .csr_data_q_o         (dec0__csr_data_q),
  .rs1_v_q_o            (dec0__rs1_v_q),
  .rs1_adr_q_o          (dec0__rs1_adr_q),
  .rs1_data_q_o         (dec0__rs1_data_q),
  .rs2_v_q_o            (dec0__rs2_v_q),
  .rs2_adr_q_o          (dec0__rs2_adr_q),
  .rs2_data_q_o         (dec0__rs2_data_q),
  .csr_clear_q_o        (dec0__csr_clear_q),
  .ecall_q_o            (dec0__ecall_q),
  .ebreak_q_o           (dec0__ebreak_q),
  .auipc_q_o            (dec0__auipc_q),
  .rs1_is_immediat_q_o  (dec0__rs1_is_immediat_q),
  .rs2_is_immediat_q_o  (dec0__rs2_is_immediat_q),
  .rs2_is_csr_q_o       (dec0__rs2_is_csr_q),
  .immediat_q_o         (dec0__immediat_q),
  .access_size_q_o      (dec0__access_size_q),
  .unsign_extension_q_o (dec0__unsign_extension_q),
  .csrrw_q_o            (dec0__csrrw_q),
  .unit_q_o             (dec0__unit_q),
  .operation_q_o        (dec0__operation_q),
  .rs2_ca2_v_q_o        (dec0__rs2_ca2_v_q),
  .illegal_inst_q_o     (dec0__illegal_inst_q),
  .mret_q_o             (dec0__mret_q),
  .sret_q_o             (dec0__sret_q)
);

dec1 u_decod1(
  .clk                  (clk),
  .reset_n              (reset_n),
  // --------------------------------
  //      dec0 Interface
  // --------------------------------
  .pc_q_i               (dec0__pc_q),
  .wbk_v_q_i            (dec0__wbk_v_q),
  .wbk_adr_q_i          (dec0__wbk_adr_q),
  .csr_wbk_q_i          (dec0__csr_wbk_q),
  .csr_adr_q_i          (dec0__csr_adr_q),
  .csr_data_q_i         (dec0__csr_data_q),
  .rs1_v_q_i            (dec0__rs1_v_q),
  .rs1_adr_q_i          (dec0__rs1_adr_q),
  .rs1_data_q_i         (dec0__rs1_data_q),
  .rs2_v_q_i            (dec0__rs2_v_q),
  .rs2_adr_q_i          (dec0__rs2_adr_q),
  .rs2_data_q_i         (dec0__rs2_data_q),
  .csr_clear_q_i        (dec0__csr_clear_q),
  .ecall_q_i            (dec0__ecall_q),
  .ebreak_q_i           (dec0__ebreak_q),
  .auipc_q_i            (dec0__auipc_q),
  .rs1_is_immediat_q_i  (dec0__rs1_is_immediat_q),
  .rs2_is_immediat_q_i  (dec0__rs2_is_immediat_q),
  .rs2_is_csr_q_i       (dec0__rs2_is_csr_q),
  .immediat_q_i         (dec0__immediat_q),
  .access_size_q_i      (dec0__access_size_q),
  .unsign_extension_q_i (dec0__unsign_extension_q),
  .csrrw_q_i            (dec0__csrrw_q),
  .unit_q_i             (dec0__unit_q),
  .operation_q_i        (dec0__operation_q),
  .rs2_ca2_v_q_i        (dec0__rs2_ca2_v_q),
  .illegal_inst_q_i     (dec0__illegal_inst_q),
  .mret_q_i             (dec0__mret_q),
  .sret_q_i             (dec0__sret_q),
  // --------------------------------
  //      Execute Interface
  // --------------------------------
  .exe_ff_res_data_i    (exe__ff_res_data),
  .exe_ff_csr_data_i    (exe__ff_csr_data),
  .rf_write_v_q_i       (exe__wbk_v_q),
  .rf_ff_rd_adr_q_i     (exe__wbk_adr_q),
  .rf_ff_res_data_q_i   (exe__wbk_data_q),
  .pc_q_o               (dec1__pc_q),
  .rd_v_q_o             (dec1__wbk_v_q),
  .rd_adr_q_o           (dec1__rd_adr_q),
  .csr_wbk_q_o          (dec1__csr_wbk),
  .csr_adr_q_o          (dec1__csr_adr_q),
  .rs1_data_qual_q_o    (dec1__rs1_data_q),
  .rs2_data_qual_q_o    (dec1__rs2_data_q),
  .branch_imm_q_o       (dec1__immediat_q),
  .access_size_q_o      (dec1__access_size_q),
  .unsign_ext_q_o       (dec1__unsign_extension_q),
  .csrrw_q_o            (dec1__csrrw_q),
  .unit_q_o             (dec1__unit_q),
  .operation_q_o        (dec1__operation_q),
  .illegal_inst_q_o     (dec1__illegal_inst_q),
  .mret_q_o             (exe__mret_q),
  .sret_q_o             (exe__sret_q),
  .ecall_q_o            (dec1__ecall_q),
  .ebreak_q_o           (dec1__ebreak_q),
  .branch_v_q_i         (exe__branch_v_q)
);
exe u_exe(
  .clk                  ( clk),
  .reset_n              ( reset_n),
  // --------------------------------
  //      DEC
  // --------------------------------
  .pc_q_i               (dec1__pc_q),
  .wbk_v_q_i            (dec1__wbk_v_q),
  .wbk_adr_q_i          (dec1__rd_adr_q),
  .csr_wbk_i            (dec1__csr_wbk),
  .csr_adr_i            (dec1__csr_adr_q),
  .rs1_data_qual_q_i    (dec1__rs1_data_q),
  .rs2_data_qual_q_i    (dec1__rs2_data_q),
  .ecall_q_i            (dec1__ecall_q),
  .ebreak_q_i           (dec1__ebreak_q),
  .immediat_q_i         (dec1__immediat_q),
  .access_size_q_i      (dec1__access_size_q),
  .unsign_extension_q_i (dec1__unsign_extension_q),
  .csrrw_q_i            (dec1__csrrw_q),
  .unit_q_i             (dec1__unit_q),
  .operation_q_i        (dec1__operation_q),
  .illegal_inst_q_i     (dec1__illegal_inst_q),
  .mret_q_i             (exe__mret_q),
  .sret_q_i             (exe__sret_q),
  // --------------------------------
  //      MEM
  // --------------------------------
  .adr_v_o              (exe__adr_v),
  .adr_o                (exe__adr),
  .store_v_o            (exe__store_v),
  .store_data_o         (store_data),
  .load_data_i          (load_data_i),
  .access_size_o        (access_size_o),
  // --------------------------------
  //      WBK
  // --------------------------------
  .exe_ff_res_data_o    (exe__ff_res_data),
  .exe_ff_csr_data_o    (exe__ff_csr_data),
  .core_mode_q_o        (exe__core_mode_q),
  .exception_q_o        (exe__exception_q),
  .mstatus_q_o          (exe__mstatus_q),
  .mcause_q_o           (exe__mcause_q),
  .mtval_q_o            (exe__mtval_q),
  .mepc_q_o             (exe__mepc_q),
  .mtvec_q_i            (csr__mtvec_reg_q),
  .mstatus_q_i          (csr__mstatus_reg_q),
  .mepc_q_i             (mepc_reg_q),
  .wbk_v_q_o            (exe__wbk_v_q),
  .wbk_adr_q_o          (exe__wbk_adr_q),
  .wbk_data_q_o         (exe__wbk_data_q),
  .csr_wbk_v_q_o        (exe__csr_wbk_v_q),
  .csr_adr_q_o          (exe__csr_adr_q),
  .csr_data_q_o         (exe__csr_data_q),
  .branch_v_q_o         (exe__branch_v_q),
  `ifdef VALIDATION
  .pc_q_o               (exe__pc_q),
  `endif
  .pc_data_q_o          (exe__if__pc)
);

rf u_rf(
  .clk              (clk),
  .reset_n          (reset_n),
  .rs1_adr_i        (dec0__rs1_adr),
  .rs1_data_o       (rf__rs1_data),
  .rs2_adr_i        (dec0__rs2_adr),
  .rs2_data_o       (rf__rs2_data),
  .write_valid_i    (exe__wbk_v_q),
  .write_adr_i      (exe__wbk_adr_q),
  .write_data_i     (exe__wbk_data_q)

);

csr u_csr(
  .clk              (clk),
  .reset_n          (reset_n),
  .exception_q_i    (exe__exception_q),
  .mstatus_q_i      (exe__mstatus_q),
  .mcause_q_i       (exe__mcause_q),
  .mtval_q_i        (exe__mtval_q),
  .mepc_q_i         (exe__mepc_q),
  .mtvec_q_o        (csr__mtvec_reg_q),
  .mstatus_q_o      (csr__mstatus_reg_q),
  .write_v_i        (exe__csr_wbk_v_q),
  .adr_read_i       (dec0__csr_adr),
  .adr_write_i      (exe__csr_adr_q),
  .data_i           (exe__csr_data_q),
  .mepc_q_o         (mepc_reg_q),
  .data_o           (csr__dec__data)
);

// --------------------------------
//      OUTPUTS
// --------------------------------

assign adr_v_o        = exe__adr_v;
assign adr_o          = exe__adr;
assign store_v_o      = exe__store_v;
assign store_data_o   = store_data;

// --------------------------------
//      VALIDATION
// --------------------------------
`ifdef VALIDATION
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
    val_adr_v_q      <= '0;
    val_adr_q        <= '0;
    val_store_v_q    <= '0;
    val_store_data_q <= '0;
  end else begin
    val_adr_v_q      <= exe__adr_v;
    val_adr_q        <= exe__adr;
    val_store_v_q    <= exe__store_v;
    val_store_data_q <= store_data;
end
// rd
assign val_wbk_v_q_o          = exe__wbk_v_q;
assign val_wbk_adr_q_o        = exe__wbk_adr_q;
assign val_wbk_data_q_o       = exe__wbk_data_q;
// csr
assign val_wbk_csr_v_q_o      = exe__csr_wbk_v_q;
assign val_wbk_csr_adr_q_o    = exe__csr_adr_q;
assign val_wbk_csr_data_q_o   = exe__csr_data_q;
// branch
assign val_pc_o               = exe__pc_q;
// memory access
assign val_adr_v_q_o          = val_adr_v_q;
assign val_adr_q_o            = val_adr_q;
assign val_store_v_q_o        = val_store_v_q;
assign val_store_data_q_o     = val_store_data_q;
`endif

endmodule