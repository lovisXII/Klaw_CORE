import riscv_pkg::*;

module exe
(
  input logic                 clk,
  input logic                 reset_n,
// --------------------------------
//      DEC
// --------------------------------
  // PC
  input logic [XLEN-1:0]            pc_q_i,
  // Registers
  // Destination
  input logic                       rd_v_q_i,
  input logic [4:0]                 rd_adr_q_i,
  // Csr
  input logic                       csr_wbk_i,
  input logic [11:0]                csr_adr_i,
  // Source 1
  input logic [XLEN:0]              rs1_data_qual_q_i,
  // Source 2
  input logic [XLEN:0]              rs2_data_qual_q_i,
  // Additionnal informations
  input logic [XLEN-1:0]            immediat_q_i,
  input logic [2:0]                 access_size_q_i,
  input logic                       unsign_extension_q_i,
  input logic                       csrrw_q_i,
  input logic [NB_UNIT-1:0]         unit_q_i,
  input logic [NB_OPERATION-1:0]    operation_q_i,
  input logic                       illegal_inst_q_i,
  input logic                       mret_q_i,
  input logic                       sret_q_i,
// --------------------------------
//      MEM
// --------------------------------
  output logic                     adr_v_o,
  output logic [XLEN-1:0]          adr_o,
  output logic                     is_store_o,
  output logic [XLEN-1:0]          store_data_o,
  input  logic  [XLEN-1:0]         load_data_i,
  output logic [2:0]               access_size_o,
// --------------------------------
//      Forwards
// --------------------------------
  // forwards rd
  output logic [XLEN-1:0]           exe_ff_res_data_o,
  // forwards csr
  output logic [XLEN-1:0]           exe_ff_csr_data_o,
// --------------------------------
//      exception_nxt/Interruptions
// --------------------------------
output logic [1:0]                core_mode_q_o,
output logic                      exception_q_o,
output logic [XLEN-1:0]           mcause_q_o,
output logic [XLEN-1:0]           mtval_q_o,
output logic [XLEN-1:0]           mepc_q_o,
output logic [XLEN-1:0]           mstatus_q_o,

input  logic [XLEN-1:0]           mepc_q_i,
input  logic [XLEN-1:0]           mtvec_q_i,
// --------------------------------
//      WBK
// --------------------------------
  // RF interface
  output logic                      wbk_v_q_o,
  output logic [XLEN-1:0]           wbk_data_q_o,
  output logic [NB_REGS-1:0]        wbk_adr_q_o,
  // CSR interface
  output logic                      csr_wbk_v_q_o,
  output logic [11:0]               csr_adr_q_o,
  output logic [XLEN-1:0]           csr_data_q_o,
  output logic                      flush_v_q_o,
  output logic [XLEN-1:0]           pc_data_q_o

);
// --------------------------------
//      Signals declaration
// --------------------------------
// ALU
logic                     alu_en;
logic [XLEN-1:0]          alu_res_data;
// Shifter
logic                     shifter_en;
logic [XLEN-1:0]          shifter_res_data;
// Branch Unit (BU)
logic                     bu_en;
logic                     branch_v;
logic [XLEN-1:0]          bu_pc_res;
logic [XLEN-1:0]          bu_data_res;
// Load-store unit (LSU)
logic                     lsu_en;
logic [XLEN-1:0]          lsu_res_data;
logic [XLEN-1:0]          mem_adr;
logic                     is_store;
// exception_nxt
logic                     exception_nxt;
logic                     exception_q;
logic                     flush_nxt;
logic [XLEN-1:0]          cause_nxt;
logic [XLEN-1:0]          mtval_nxt;
logic [XLEN-1:0]          mstatus_nxt;
logic [XLEN-1:0]          cause_q;
logic [XLEN-1:0]          mtval_q;
logic [XLEN-1:0]          mstatus_q;
logic [XLEN-1:0]          mepc_q;
logic                     adr_fault;
logic                     flush;
logic                     pc_missaligned;
logic                     adr_missaligned;
logic                     instr_access_fault;
logic                     break_point;
logic                     ld_adr_missaligned;
logic                     ld_access_fault;
logic                     st_adr_missaligned;
logic                     st_access_fault;
logic                     env_call_m_mode;
logic                     pc_missaligned_nxt;
logic                     adr_missaligned_nxt;
logic                     instr_access_fault_nxt;
logic                     break_point_nxt;
logic                     ld_adr_missaligned_nxt;
logic                     ld_access_fault_nxt;
logic                     st_adr_missaligned_nxt;
logic                     st_access_fault_nxt;
logic                     env_call_m_mode_nxt;
logic [1:0]               core_mode_nxt;
logic [1:0]               core_mode_q;
// Wbk signals
logic                     csr_wbk_v_nxt;
logic                     csr_wbk_v_q;
logic [11:0]              csr_adr_nxt;
logic [11:0]              csr_adr_q;
logic [XLEN-1:0]          csr_data_nxt;
logic [XLEN-1:0]          csr_data_q;
logic                     rd_v_nxt;
logic                     rd_v_q;
logic [4:0]               rd_adr_q;
logic [XLEN-1:0]          res_data_nxt;
logic [XLEN-1:0]          res_data_q;
logic                     branch_v_nxt;
logic [XLEN-1:0]          pc_data_nxt;
logic                     flush_v_q;
logic                     flush_v_dly1_q;
logic [XLEN-1:0]          pc_data_q;


// --------------------------------
//      Unit instanciation
// --------------------------------
alu u_alu(
    .rs1_data_i     (rs1_data_qual_q_i),
    .rs2_data_i     (rs2_data_qual_q_i),
    .alu_en_i       (alu_en),
    .cmd_i          (operation_q_i ),
    .data_o         (alu_res_data)
);

shifter u_shifter(
    .rs1_data_i     (rs1_data_qual_q_i[XLEN-1:0]),
    .rs2_data_i     (rs2_data_qual_q_i[XLEN-1:0]),
    .shifter_en_i   (shifter_en),
    .cmd_i          (operation_q_i),
    .data_o         (shifter_res_data)
);

bu u_bu(
    .rs1_data_i         (rs1_data_qual_q_i),
    .rs2_data_i         (rs2_data_qual_q_i),
    .unsign_cmp_i       (unsign_extension_q_i),
    .immediat_i         (immediat_q_i),
    .pc_data_i          (pc_q_i),
    .bu_en_i            (bu_en),
    .cmd_i              (operation_q_i ),
    .branch_v_o         (branch_v),
    .pc_nxt_o           (bu_pc_res),
    .pc_missaligned_o   (pc_missaligned),
    .data_o             (bu_data_res)
);
lsu u_lsu(
    .rs1_data_i         (rs1_data_qual_q_i[XLEN-1:0]),
    .immediat_i         (immediat_q_i),
    .lsu_en_i           (lsu_en),
    .access_size_q_i    (access_size_q_i),
    .unsign_extension_i (unsign_extension_q_i),
    .load_data_i        (load_data_i),
    .adr_o              (mem_adr),
    .lsu_data_o         (lsu_res_data),
    .adr_missaligned_o  (adr_missaligned)
);
// --------------------------------
//      Internal architecture
// --------------------------------
// exception_nxt
assign ld_adr_missaligned   = adr_missaligned & ~is_store;
assign st_adr_missaligned   = adr_missaligned &  is_store;

assign adr_fault            = '0;

assign exception_nxt        = pc_missaligned  | instr_access_fault | illegal_inst_q_i
                            | break_point     | ld_adr_missaligned | ld_access_fault
                            | ld_access_fault | st_adr_missaligned | st_access_fault
                            | env_call_m_mode;

assign pc_missaligned_nxt     = pc_missaligned;
assign instr_access_fault_nxt = instr_access_fault  & ~pc_missaligned_nxt;
assign illegal_inst_nxt       = illegal_inst_q_i    & ~instr_access_fault_nxt;
assign break_point_nxt        = break_point         & ~illegal_inst_nxt;
assign ld_adr_missaligned_nxt = ld_adr_missaligned  & ~break_point_nxt;
assign ld_access_fault_nxt    = ld_access_fault     & ~ld_adr_missaligned_nxt;
assign st_adr_missaligned_nxt = st_adr_missaligned  & ~ld_access_fault_nxt;
assign st_access_fault_nxt    = st_access_fault     & ~st_adr_missaligned_nxt;
assign env_call_m_mode_nxt    = env_call_m_mode     & ~st_access_fault_nxt;

assign flush            = exception_nxt | branch_v_nxt;
assign flush_nxt        = flush & ~flush_v_q & ~flush_v_dly1_q;
assign cause_nxt        = {XLEN{pc_missaligned_nxt}}     & 32'b0
                        | {XLEN{instr_access_fault_nxt}} & 32'd1
                        | {XLEN{illegal_inst_nxt}}       & 32'd2
                        | {XLEN{break_point_nxt}}        & 32'd3
                        | {XLEN{ld_adr_missaligned_nxt}} & 32'd4
                        | {XLEN{ld_access_fault_nxt}}    & 32'd5
                        | {XLEN{st_adr_missaligned_nxt}} & 32'd6
                        | {XLEN{st_access_fault_nxt}}    & 32'd7
                        | {XLEN{env_call_m_mode_nxt}}    & 32'd11;

assign mtval_nxt        = {XLEN{pc_missaligned  | instr_access_fault}} & pc_data_nxt
                        | {XLEN{adr_missaligned | adr_fault}}          & mem_adr;

assign mstatus_nxt = '0;

assign core_mode_nxt        = {2{exception_nxt}}                          & 2'b11
                            | {2{mret_q_i}}                               & 2'b00
                            | {2{sret_q_i}}                               & 2'b01
                            | {2{~exception_nxt & ~mret_q_i & ~sret_q_i}} & core_mode_q;
// ALU
assign alu_en           = unit_q_i[ALU];
assign shifter_en       = unit_q_i[SFT];
// Branch Units
assign bu_en            = unit_q_i[BU];
// Load/Store Units
assign lsu_en           = unit_q_i[LSU];
assign is_store         = lsu_en & operation_q_i[ST];
assign adr_v_o          = lsu_en;
assign adr_o            = mem_adr;
assign is_store_o       = is_store;
assign store_data_o     = rs2_data_qual_q_i[XLEN-1:0] ;
assign access_size_o    = access_size_q_i;
// --------------------------------
//      Write back data
// --------------------------------
// dly1 added to avoid an branch instrcution to succeed
// After another branch, the wbk/mem access is disabled
// in decod cycle but a branch after branch must be canceled here
// Example :
// beq : I D E
// add :   I D E
// j   :     I D E
// If dly1 is not taken in consideration j will branch
// but it's not suppose to branch, it should be flushed
assign branch_v_nxt = branch_v | mret_q_i | sret_q_i;
assign pc_data_nxt  = {XLEN{~exception_nxt}} & bu_pc_res
                    | {XLEN{ exception_nxt}} & mtvec_q_i
                    | {XLEN{ mret_q_i}}      & mepc_q_i;

assign rd_v_nxt     = rd_v_q_i & ~flush;
assign res_data_nxt = {XLEN{alu_en & ~csr_wbk_i}} & alu_res_data
                    | {XLEN{csr_wbk_i}}           & rs2_data_qual_q_i[XLEN-1:0]
                    | {XLEN{shifter_en}}          & shifter_res_data
                    | {XLEN{bu_en}}               & bu_data_res
                    | {XLEN{lsu_en}}              & lsu_res_data;

assign csr_wbk_v_nxt = csr_wbk_i;
assign csr_adr_nxt   = csr_adr_i;
assign csr_data_nxt  = {XLEN{~csrrw_q_i}} & alu_res_data
                     | {XLEN{ csrrw_q_i}} & rs1_data_qual_q_i[XLEN-1:0];
// --------------------------------
//      Flopping outputs
// --------------------------------
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
    rd_v_q            <= '0;
    rd_adr_q          <= '0;
    res_data_q        <= '0;
    exception_q       <= '0;
    flush_v_q         <= '0;
    flush_v_dly1_q    <= '0;
    pc_data_q         <= '0;
    csr_wbk_v_q       <= '0;
    csr_data_q        <= '0;
    csr_adr_q         <= '0;
    core_mode_q       <= 2'b11;
    exception_q       <= '0;
    cause_q           <= '0;
    mtval_q           <= '0;
    mepc_q            <= '0;
    mstatus_q         <= '0;
  end else begin
    rd_v_q            <= rd_v_nxt;
    rd_adr_q          <= rd_adr_q_i;
    res_data_q        <= res_data_nxt;
    exception_q       <= exception_nxt;
    flush_v_q         <= flush_nxt;
    flush_v_dly1_q    <= flush_v_q;
    pc_data_q         <= pc_data_nxt;
    csr_wbk_v_q       <= csr_wbk_v_nxt;
    csr_data_q        <= csr_data_nxt;
    csr_adr_q         <= csr_adr_nxt;
    core_mode_q       <= core_mode_nxt;
    exception_q       <= exception_nxt;
    cause_q           <= cause_nxt;
    mtval_q           <= mtval_nxt;
    mepc_q            <= dec_pc0_q_i;
    mstatus_q         <= mstatus_nxt;
end

// --------------------------------
//      Ouputs
// --------------------------------
// rd ff
assign exe_ff_res_data_o  = res_data_nxt;
// csr ff
assign exe_ff_csr_data_o  = csr_data_nxt;
// exceptions
assign exception_q_o    = exception_q;
assign mcause_q_o       = cause_q;
assign mtval_q_o        = mtval_q;
assign mepc_q_o         = mepc_q;
assign mstatus_q_o      = mstatus_q;
assign core_mode_q_o    = core_mode_q;
// wbk
assign wbk_v_q_o           = rd_v_q;
assign wbk_adr_q_o         = rd_adr_q;
assign wbk_data_q_o        = res_data_q;
assign flush_v_q_o         = flush_v_q | exception_q;
assign pc_data_q_o         = pc_data_q;
assign csr_wbk_v_q_o       = csr_wbk_v_q;
assign csr_adr_q_o         = csr_adr_nxt;
assign csr_data_q_o        = csr_data_q;

endmodule
