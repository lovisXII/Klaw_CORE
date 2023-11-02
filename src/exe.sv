import riscv::*;

module exe
(
  input logic                 clk,
  input logic                 reset_n,
// --------------------------------
//      DEC
// --------------------------------
  // PC
  input logic                       v_q_i,
  input logic [XLEN-1:0]            dec_pc0_q_i,
  // Registers
  // Destination
  input logic                       rd_v_q_i,
  input logic [4:0]                 rd_adr_q_i,
  // Source 1
  input logic [XLEN:0]              rs1_data_qual_q_i,
  // Source 2
  input logic [XLEN:0]              rs2_data_qual_q_i,
  // Additionnal informations
  input logic [XLEN-1:0]            immediat_q_i,
  input logic [2:0]                 access_size_q_i,
  input logic                       unsign_extension_q_i,
  input logic [NB_UNIT-1:0]         unit_q_i,
  input logic [NB_OPERATION-1:0]    operation_q_i,
// --------------------------------
//      MEM 
// --------------------------------
  output logic                     adr_v_o,
  output logic [XLEN-1:0]          adr_o,
  output logic                     is_store_o,
  output logic [XLEN-1:0]          store_data_o,
  input  logic  [XLEN-1:0]          load_data_i,
  output logic [2:0]                access_size_o,
// --------------------------------
//      WBK 
// --------------------------------
  output logic                      exe_ff_write_v_q_o,
  output logic [NB_REGS-1:0]        exe_ff_rd_adr_q_o,
  output logic [XLEN-1:0]           exe_ff_res_data_q_o,
  output logic                      res_w_v_q_o,
  output logic [XLEN-1:0]           instr_wbk_data_q_o,
  output logic [NB_REGS-1:0]        instr_write_adr_q_o,
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
logic [XLEN-1:0]          bu_op1_data;
logic [XLEN-1:0]          bu_op2_data;
logic                     bu_en;
logic                     branch_v;
logic [XLEN-1:0]          bu_pc_res;
logic [XLEN-1:0]          bu_data_res;
// Load-store unit (LSU)
logic [XLEN-1:0]          lsu_op2_data;
logic [XLEN-1:0]          lsu_op1_data;
logic                     lsu_en;
logic [NB_OPERATION-1:0]  lsu_cmd;
logic [XLEN-1:0]          lsu_res_data;
// Wbk signals
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
    .pc_data_i          (dec_pc0_q_i),
    .bu_en_i            (bu_en),
    .cmd_i              (operation_q_i ),
    .branch_v_o         (branch_v),
    .pc_nxt_o           (bu_pc_res),
    .data_o             (bu_data_res)
);
lsu u_lsu(
    .rs1_data_i         (rs1_data_qual_q_i[XLEN-1:0]),
    .rs2_data_i         (rs2_data_qual_q_i[XLEN-1:0]),
    .immediat_i         (immediat_q_i),
    .lsu_en_i           (lsu_en),
    .cmd_i              (operation_q_i),
    .access_size_q_i    (access_size_q_i),
    .unsign_extension_i (unsign_extension_q_i),
    .load_data_i        (load_data_i),
    .adr_o              (adr_o),
    .lsu_data_o         (lsu_res_data)
);
// --------------------------------
//      Internal architecture
// --------------------------------
// ALU
assign alu_en           = unit_q_i[ALU] & ~flush_v_q & ~flush_v_dly1_q;
assign shifter_en       = unit_q_i[SFT] & ~flush_v_q & ~flush_v_dly1_q;
// Branch Units
assign bu_en            = unit_q_i[BU]  & ~flush_v_q & ~flush_v_dly1_q;
// Load/Store Units
assign lsu_en           = unit_q_i[LSU] & ~flush_v_q & ~flush_v_dly1_q;
assign adr_v_o          = lsu_en;
assign is_store_o       = lsu_en & operation_q_i[ST];
assign store_data_o     = {XLEN{lsu_en}} & rs2_data_qual_q_i ;
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

assign rd_v_nxt     = rd_v_q_i & ~flush_v_q & ~flush_v_dly1_q;
assign res_data_nxt = {XLEN{alu_en}}        & alu_res_data
                    | {XLEN{shifter_en}}    & shifter_res_data
                    | {XLEN{bu_en}}         & bu_data_res
                    | {XLEN{lsu_en}}        & lsu_res_data;


// --------------------------------
//      Flopping outputs
// --------------------------------
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n) begin
    rd_v_q            <= '0;
    rd_adr_q          <= '0;
    res_data_q        <= '0;
    flush_v_q         <= '0;
    flush_v_dly1_q    <= '0;
    pc_data_q         <= '0;
  end else begin
    rd_v_q            <= rd_v_nxt;
    rd_adr_q          <= rd_adr_q_i;
    res_data_q        <= res_data_nxt;
    flush_v_q         <= branch_v_nxt;
    flush_v_dly1_q    <= flush_v_q;
    pc_data_q         <= pc_data_nxt;
end

// --------------------------------
//      Ouputs
// --------------------------------
assign exe_ff_write_v_q_o    = rd_v_nxt;
assign exe_ff_rd_adr_q_o     = rd_adr_q_i;
assign exe_ff_res_data_q_o   = res_data_nxt;
assign res_w_v_q_o           = rd_v_q;
assign instr_write_adr_q_o   = rd_adr_q;
assign instr_wbk_data_q_o    = res_data_q;
assign flush_v_q_o           = flush_v_q;
assign pc_data_q_o           = pc_data_q;

endmodule
