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
//      Exception/Interruptions
// --------------------------------

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
logic                     is_store;
// Exception
logic                     exception;
logic                     exception_q;
logic [XLEN-1:0]          cause;
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
    .adr_o              (adr_o),
    .lsu_data_o         (lsu_res_data),
    .adr_missaligned_o  (adr_missaligned)
);
// --------------------------------
//      Internal architecture
// --------------------------------
// Exception
assign exception          = pc_missaligned  | instr_access_fault | illegal_inst_q_i
                          | break_point     | ld_adr_missaligned | ld_access_fault
                          | ld_access_fault | st_adr_missaligned | st_access_fault
                          | env_call_m_mode;

assign ld_adr_missaligned = adr_missaligned & ~is_store;
assign st_adr_missaligned = adr_missaligned &  is_store;
assign flush              = exception | flush_v_q | flush_v_dly1_q;
assign cause              = pc_missaligned     & 32'b0
                          | instr_access_fault & 32'd1
                          | illegal_inst_q_i   & 32'd2
                          | break_point        & 32'd3
                          | ld_adr_missaligned & 32'd4
                          | ld_access_fault    & 32'd5
                          | st_adr_missaligned & 32'd6
                          | st_access_fault    & 32'd7
                          | env_call_m_mode    & 32'd11;
// ALU
assign alu_en           = unit_q_i[ALU];
assign shifter_en       = unit_q_i[SFT];
// Branch Units
assign bu_en            = unit_q_i[BU];
// Load/Store Units
assign lsu_en           = unit_q_i[LSU];
assign is_store         = lsu_en & operation_q_i[ST];
assign adr_v_o          = lsu_en;
assign is_store_o       = is_store;
assign store_data_o     = {XLEN{lsu_en}} & rs2_data_qual_q_i[XLEN-1:0] ;
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
assign branch_v_nxt = branch_v;
assign pc_data_nxt  = bu_pc_res;

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
  end else begin
    rd_v_q            <= rd_v_nxt;
    rd_adr_q          <= rd_adr_q_i;
    res_data_q        <= res_data_nxt;
    exception_q       <= exception;
    flush_v_q         <= branch_v_nxt;
    flush_v_dly1_q    <= flush_v_q;
    pc_data_q         <= pc_data_nxt;
    csr_wbk_v_q       <= csr_wbk_v_nxt;
    csr_data_q        <= csr_data_nxt;
    csr_adr_q         <= csr_adr_nxt;
end

// --------------------------------
//      Ouputs
// --------------------------------
// rd ff
assign exe_ff_res_data_o  = res_data_nxt;
// csr ff
assign exe_ff_csr_data_o  = csr_data_nxt;
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
