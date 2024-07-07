import riscv_pkg::*;

module exe
(
  input logic                       clk,
  input logic                       reset_n,
// --------------------------------
//      DEC
// --------------------------------
  // PC
  input logic [XLEN-1:0]            pc_q_i,
  // Registers
  // Destination
  input logic                       wbk_v_q_i,
  input logic [4:0]                 wbk_adr_q_i,
  // Csr
  input logic                       csr_wbk_i,
  input logic [11:0]                csr_adr_i,
  // Source 1
  input logic [XLEN:0]              rs1_data_qual_q_i,
  // Source 2
  input logic [XLEN:0]              rs2_data_qual_q_i,
  // Additionnal informations
  input logic                       ecall_q_i,
  input logic                       ebreak_q_i,
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
  output logic                     store_v_o,
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
 output logic                       exception_q_o,
 output logic [XLEN-1:0]            mstatus_q_o,
 output logic [XLEN-1:0]            mcause_q_o,
 output logic [XLEN-1:0]            mtval_q_o,
 output logic [XLEN-1:0]            mepc_q_o,

 input  logic [XLEN-1:0]            mepc_q_i,
 input  logic [XLEN-1:0]            mtvec_q_i,
 input  logic [XLEN-1:0]            mstatus_q_i,
 // --------------------------------
 //      CHECKER
 // --------------------------------
  `ifdef VALIDATION
  output logic [XLEN-1:0]            pc_q_o,
  `endif
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
  output logic                      branch_v_q_o,
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
logic                     store_v;
// exception_nxt
logic                     exception_nxt;
logic                     exception_q;
logic                     exception_dly1_q;
logic                     exception_dly2_q;
logic [XLEN-1:0]          cause_nxt;
logic [XLEN-1:0]          mtval_nxt;
logic [XLEN-1:0]          mstatus_old;
logic [12:11]             mpp_old;
logic                     mpie_old;
logic                     mie_old;
logic [12:11]             mpp_new;
logic                     mpie_new;
logic                     mie_new;
logic [XLEN-1:0]          mstatus_nxt;
logic [XLEN-1:0]          cause_q;
logic [XLEN-1:0]          mstatus_q;
logic [XLEN-1:0]          mtval_q;
logic [XLEN-1:0]          mepc_q;
logic                     adr_fault;
logic                     pc_missaligned;
logic                     adr_missaligned;
logic                     ld_adr_missaligned;
logic                     st_adr_missaligned;
logic                     pc_missaligned_nxt;
logic                     adr_missaligned_nxt;
logic                     illegal_inst_nxt;
logic                     breakpoint_nxt;
logic                     ld_adr_missaligned_nxt;
logic                     st_adr_missaligned_nxt;
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
logic                     wbk_v_nxt;
logic                     wbk_v_q;
logic [4:0]               wbk_adr_q;
logic [XLEN-1:0]          wbk_data_nxt;
logic [XLEN-1:0]          wbk_data_q;
logic                     flush_v;
logic                     branch_v_nxt;
logic                     branch_v_q;
logic                     branch_v_dly1_q;
logic                     branch_v_dly2_q;
logic [XLEN-1:0]          pc_data_nxt;
logic [XLEN-1:0]          pc_data_q;

// --------------------------------
//      VALIDATION
// --------------------------------

`ifdef VALIDATION
logic [XLEN-1:0]          pc_q;
`endif

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
// =====================================================
//                         Internal architecture
// =====================================================

//--------------
// Exceptions
//--------------
assign ld_adr_missaligned   = adr_missaligned & ~store_v;
assign st_adr_missaligned   = adr_missaligned &  store_v;

assign adr_fault            = '0;

assign exception_nxt        = ~exception_q & ~branch_v_q & ~exception_dly1_q & ~branch_v_dly1_q & ~exception_dly2_q & ~branch_v_dly2_q
                            & (
                                 pc_missaligned
                               | illegal_inst_q_i
                               | ebreak_q_i
                               | ld_adr_missaligned
                               | st_adr_missaligned
                               | ecall_q_i
                               );

assign pc_missaligned_nxt     = pc_missaligned;
assign illegal_inst_nxt       = illegal_inst_q_i    & ~pc_missaligned_nxt;
assign breakpoint_nxt         = ebreak_q_i          & ~illegal_inst_nxt;
assign ld_adr_missaligned_nxt = ld_adr_missaligned  & ~breakpoint_nxt;
assign st_adr_missaligned_nxt = st_adr_missaligned  & ~ld_adr_missaligned_nxt;
assign env_call_m_mode_nxt    = ecall_q_i           & ~st_adr_missaligned_nxt;

//---------------------------
// System registers update
//---------------------------
assign cause_nxt        = {XLEN{pc_missaligned_nxt    }} & 32'b0
                        | {XLEN{illegal_inst_nxt      }} & 32'd2
                        | {XLEN{breakpoint_nxt        }} & 32'd3
                        | {XLEN{ld_adr_missaligned_nxt}} & 32'd4
                        | {XLEN{st_adr_missaligned_nxt}} & 32'd6
                        | {XLEN{env_call_m_mode_nxt   }} & 32'd11;

assign mtval_nxt        = {XLEN{pc_missaligned             }} & bu_pc_res
                        | {XLEN{breakpoint_nxt             }} & pc_q_i
                        | {XLEN{adr_missaligned | adr_fault}} & mem_adr;

assign mstatus_old    = mstatus_q_i[XLEN-1:0];
assign mpp_old[12:11] = mstatus_old[12:11];
assign mpie_old       = mstatus_old[7];
assign mie_old        = mstatus_old[3];

assign mpp_new[12:11] = 2'b11;
assign mpie_new       =  mret_q_i & 1'b1
                      | ~mret_q_i & 1'b0;
assign mie_new        = mpie_old;
assign mstatus_nxt = {
                        mstatus_old[31:13],
                        mpp_new[12:11],
                        mstatus_old[10:8],
                        mpie_new,
                        mstatus_old[6:4],
                        mie_new,
                        mstatus_old[2:0]
                      };

assign core_mode_nxt  = {2{exception_nxt}}                          & 2'b11
                      | {2{mret_q_i}}                               & mpp_old[12:11]
                      | {2{sret_q_i}}                               & 2'b01
                      | {2{~exception_nxt & ~mret_q_i & ~sret_q_i}} & core_mode_q;
// ALU
assign alu_en           = unit_q_i[ALU];
assign shifter_en       = unit_q_i[SFT];
// Branch Units
assign bu_en            = unit_q_i[BU];
// Load/Store Units
assign lsu_en           = unit_q_i[LSU] & ~flush_v;
assign store_v         = lsu_en & operation_q_i[ST];
assign adr_v_o          = lsu_en & ~exception_nxt;
assign adr_o            = mem_adr;
assign store_v_o       = store_v;
assign store_data_o     = rs2_data_qual_q_i[XLEN-1:0] ;
assign access_size_o    = access_size_q_i;
// --------------------------------
//      Write back data
// --------------------------------
// dly1 and dly2 added to avoid an branch instrcution to succeed
// After another branch, the wbk/mem access is disabled
// in decod cycle but a branch after branch must be canceled here
// Example :
// beq : I D0 D1 E
// add :   I D0 D1 E
// j   :     I D0 D1 E
// If dly1 is not taken in consideration j will branch
// but it's not suppose to branch, it should be flushed
assign flush_v        = branch_v_q | branch_v_dly1_q | branch_v_dly2_q |  exception_q | exception_dly1_q | exception_dly2_q;

assign branch_v_nxt = (branch_v | mret_q_i | sret_q_i) & ~flush_v & ~exception_nxt;
assign pc_data_nxt  = {XLEN{~exception_nxt}} & bu_pc_res
                    | {XLEN{ exception_nxt}} & mtvec_q_i
                    | {XLEN{ mret_q_i}}      & mepc_q_i;

assign wbk_v_nxt     = wbk_v_q_i  & ~flush_v & ~exception_nxt;
assign wbk_data_nxt = {XLEN{alu_en & ~csr_wbk_i}} & alu_res_data
                    | {XLEN{csr_wbk_i}}           & rs2_data_qual_q_i[XLEN-1:0]
                    | {XLEN{shifter_en}}          & shifter_res_data
                    | {XLEN{bu_en}}               & bu_data_res
                    | {XLEN{lsu_en}}              & lsu_res_data;

assign csr_wbk_v_nxt = csr_wbk_i  & ~flush_v & ~exception_nxt;
assign csr_adr_nxt   = csr_adr_i;
assign csr_data_nxt  = {XLEN{~csrrw_q_i & ~mret_q_i}} & alu_res_data
                     | {XLEN{ csrrw_q_i            }} & rs1_data_qual_q_i[XLEN-1:0]
                     | {XLEN{ mret_q_i             }} & mstatus_nxt;
// --------------------------------
//      Flopping outputs
// --------------------------------
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
    wbk_v_q            <= '0;
    wbk_adr_q          <= '0;
    wbk_data_q        <= '0;
    exception_q       <= '0;
    pc_data_q         <= '0;
    csr_wbk_v_q       <= '0;
    csr_data_q        <= '0;
    csr_adr_q         <= '0;
    core_mode_q       <= 2'b11;
    exception_q       <= '0;
    cause_q           <= '0;
    mtval_q           <= '0;
    mepc_q            <= '0;
    branch_v_q        <= '0;
    branch_v_dly1_q   <= '0;
    branch_v_dly2_q   <= '0;
  end else begin
    wbk_v_q           <= wbk_v_nxt;
    wbk_adr_q         <= wbk_adr_q_i;
    wbk_data_q        <= wbk_data_nxt;
    exception_q       <= exception_nxt;
    exception_dly1_q  <= exception_q;
    exception_dly2_q  <= exception_dly1_q;
    pc_data_q         <= pc_data_nxt;
    csr_wbk_v_q       <= csr_wbk_v_nxt;
    csr_data_q        <= csr_data_nxt;
    csr_adr_q         <= csr_adr_nxt;
    core_mode_q       <= core_mode_nxt;
    mstatus_q         <= mstatus_nxt;
    cause_q           <= cause_nxt;
    mtval_q           <= mtval_nxt;
    mepc_q            <= pc_q_i;
    branch_v_q        <= branch_v_nxt;
    branch_v_dly1_q   <= branch_v_q;
    branch_v_dly2_q   <= branch_v_dly1_q;
`ifdef VALIDATION
    pc_q              <= pc_q_i;
`endif
end

// --------------------------------
//      Ouputs
// --------------------------------
// rd ff
assign exe_ff_res_data_o  = wbk_data_nxt;
// csr ff
assign exe_ff_csr_data_o  = csr_data_nxt;
// exceptions
assign exception_q_o    = exception_q;
assign mstatus_q_o      = mstatus_q;
assign mcause_q_o       = cause_q;
assign mtval_q_o        = mtval_q;
assign mepc_q_o         = mepc_q;
assign core_mode_q_o    = core_mode_q;
// wbk
assign wbk_v_q_o        = wbk_v_q;
assign wbk_adr_q_o      = wbk_adr_q;
assign wbk_data_q_o     = wbk_data_q;
assign branch_v_q_o     = branch_v_q;
assign pc_data_q_o      = pc_data_q;
assign csr_wbk_v_q_o    = csr_wbk_v_q;
assign csr_adr_q_o      = csr_adr_q;
assign csr_data_q_o     = csr_data_q;
`ifdef VALIDATION
assign pc_q_o           = pc_q;
`endif
endmodule
