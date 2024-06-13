import riscv_pkg::*;

module decoder (
  input logic [XLEN-1:0]             instr_i,
  // Exception
  // Rd
  output logic                       wbk_v_o,
  output logic [4:0]                 wbk_adr_o,
  // Csr
  output logic                       csr_wbk_o,
  output logic                       csr_clear_o,
  output logic [11:0]                wbk_csr_adr_o,
  // rs1
  output logic                       rs1_v_o,
  output logic [4:0]                 rs1_adr_o,
  // rs2
  output logic                       rs2_v_o,
  output logic [4:0]                 rs2_adr_o,
  // Additionnal informations
  output logic                       ecall_o,
  output logic                       auipc_o,
  output logic                       rs1_is_immediat_o,
  output logic                       rs2_is_immediat_o,
  output logic                       rs2_is_csr_o,
  output logic [XLEN-1:0]            immediat_o,
  output logic [2:0]                 access_size_o,
  output logic                       unsign_extension_o,
  output logic                       csrrw_o,
  output logic [NB_UNIT-1:0]         unit_o,
  output logic [NB_OPERATION-1:0]    operation_o,
  output logic                       rs2_ca2_v_o,
  output logic                       illegal_inst_o,
  output logic                       mret_o,
  output logic                       sret_o
);


/*
  Instr_type encoding :

  r_type   0000000000001
  i_type   0000000000010
  l_type   0000000000100
  s_type   0000000001000
  b_type   0000000010000
  u_type   0000000100000
  p_type   0000001000000
  fence    0000010000000
  auipc    0000100000000
  jalr     0001000000000
  jal      0010000000000
  r64_type 0100000000000
  i64_type 1000000000000
*/
// Registers
logic wbk_v;
logic rs1_v;
logic rs2_v;
logic [4:0] wbk_adr;
logic [4:0] rs1_adr;
logic [4:0] rs2_adr;
// instr id parts
logic[6:0]  opcode;
logic[2:0]  funct3;
logic[6:0]  funct7;
// Additionnal informations
logic is_csr;
logic is_store;
logic is_load;
logic is_branch;
logic is_mul;
logic is_div;
logic is_arithm;
logic is_shift;
logic unsign_extension;
// Instruction type
logic r_type;
logic i_type;
logic l_type;
logic s_type;
logic b_type;
logic u_type;
logic p_type;
logic r64_type;
logic i64_type;
// Illegal instruction
logic unknow_opc;
// Instructions
// R-Type
logic add;
logic sub;
logic sll;
logic slt;
logic sltu;
logic xorr;
logic srl;
logic sra;
logic orr;
logic andd;
logic mul;
logic mulh;
logic mulhsu;
logic mulhu;
logic div;
logic divu;
logic rem;
logic remu;
// I-type
logic addi;
logic slti;
logic sltiu;
logic xori;
logic ori;
logic andi;
logic slli;
logic srli;
logic srai;
// B-type
logic beq;
logic bne;
logic blt;
logic bge;
logic bltu;
logic bgeu;
// U-type
logic lui;
logic auipc;
// J-type
logic jal;
logic jalr;
// L-type
logic lw;
logic lh;
logic lhu;
logic lb;
logic lbu;
logic lwu;
logic ld;
// S-type
logic sw;
logic sh;
logic sb;
logic sd;
// P-type
logic ecall;
logic ebreak;
logic csrrw;
logic csrrs;
logic csrrc;
logic csrrwi;
logic csrrsi;
logic csrrci;
logic mret;
logic sret;
logic fence;
logic illegal_inst;
logic [XLEN-1:0] imm;
//-------------------------
// Instruction decoding
//-------------------------

assign opcode = instr_i[6:0];
assign funct3 = instr_i[14:12];
assign funct7 = instr_i[31:25];

always_comb begin
    r_type         = 1'b0;
    i_type         = 1'b0;
    l_type         = 1'b0;
    s_type         = 1'b0;
    b_type         = 1'b0;
    u_type         = 1'b0;
    p_type         = 1'b0;
    r64_type       = 1'b0;
    i64_type       = 1'b0;
    unknow_opc     = 1'b0;
    add            = 1'b0;
    sub            = 1'b0;
    sll            = 1'b0;
    slt            = 1'b0;
    sltu           = 1'b0;
    xorr           = 1'b0;
    srl            = 1'b0;
    sra            = 1'b0;
    orr            = 1'b0;
    andd           = 1'b0;
    mul            = 1'b0;
    mulh           = 1'b0;
    mulhsu         = 1'b0;
    mulhu          = 1'b0;
    div            = 1'b0;
    divu           = 1'b0;
    rem            = 1'b0;
    remu           = 1'b0;
    addi           = 1'b0;
    slti           = 1'b0;
    sltiu          = 1'b0;
    xori           = 1'b0;
    ori            = 1'b0;
    andi           = 1'b0;
    slli           = 1'b0;
    srli           = 1'b0;
    srai           = 1'b0;
    beq            = 1'b0;
    bne            = 1'b0;
    blt            = 1'b0;
    bge            = 1'b0;
    bltu           = 1'b0;
    bgeu           = 1'b0;
    lui            = 1'b0;
    auipc          = 1'b0;
    jal            = 1'b0;
    jalr           = 1'b0;
    lw             = 1'b0;
    lh             = 1'b0;
    lhu            = 1'b0;
    lb             = 1'b0;
    lbu            = 1'b0;
    ld             = 1'b0;
    sw             = 1'b0;
    sh             = 1'b0;
    sb             = 1'b0;
    sd             = 1'b0;
    ecall          = 1'b0;
    ebreak         = 1'b0;
    csrrw          = 1'b0;
    csrrs          = 1'b0;
    csrrc          = 1'b0;
    csrrwi         = 1'b0;
    csrrsi         = 1'b0;
    csrrci         = 1'b0;
    mret           = 1'b0;
    sret           = 1'b0;
    fence          = 1'b0;
    illegal_inst   = 1'b0;
  case(opcode)
    R_TYPE   : r_type     = 1'b1;
    I_TYPE   : i_type     = 1'b1;
    L_TYPE   : l_type     = 1'b1;
    S_TYPE   : s_type     = 1'b1;
    B_TYPE   : b_type     = 1'b1;
    U_TYPE   : u_type     = 1'b1;
    P_TYPE   : p_type     = 1'b1;
    R64_TYPE : r64_type   = 1'b1;
    I64_TYPE : i64_type   = 1'b1;
    default  :
              unknow_opc = 1'b1;
  endcase
  casez({opcode, funct3, funct7})
    // R-Type
    {R_TYPE, 3'b000, 7'b0000000}        : add    = 1'b1;
    {R_TYPE, 3'b000, 7'b0100000}        : sub    = 1'b1;
    {R_TYPE, 3'b001, 7'b0000000}        : sll    = 1'b1;
    {R_TYPE, 3'b010, 7'b0000000}        : slt    = 1'b1;
    {R_TYPE, 3'b011, 7'b0000000}        : sltu   = 1'b1;
    {R_TYPE, 3'b100, 7'b0000000}        : xorr   = 1'b1;
    {R_TYPE, 3'b101, 7'b0000000}        : srl    = 1'b1;
    {R_TYPE, 3'b101, 7'b0100000}        : sra    = 1'b1;
    {R_TYPE, 3'b110, 7'b0000000}        : orr    = 1'b1;
    {R_TYPE, 3'b111, 7'b0000000}        : andd   = 1'b1;
    {R_TYPE, 3'b000, 7'b0000001}        : mul    = 1'b1;
    {R_TYPE, 3'b001, 7'b0000001}        : mulh   = 1'b1;
    {R_TYPE, 3'b010, 7'b0000001}        : mulhsu = 1'b1;
    {R_TYPE, 3'b011, 7'b0000001}        : mulhu  = 1'b1;
    {R_TYPE, 3'b100, 7'b0000001}        : div    = 1'b1;
    {R_TYPE, 3'b101, 7'b0000001}        : divu   = 1'b1;
    {R_TYPE, 3'b110, 7'b0000001}        : rem    = 1'b1;
    {R_TYPE, 3'b111, 7'b0000001}        : remu   = 1'b1;
    // I-type
    {I_TYPE, 3'b000, 7'b???????}        : addi   = 1'b1;
    {I_TYPE, 3'b010, 7'b???????}        : slti   = 1'b1;
    {I_TYPE, 3'b011, 7'b???????}        : sltiu  = 1'b1;
    {I_TYPE, 3'b100, 7'b???????}        : xori   = 1'b1;
    {I_TYPE, 3'b110, 7'b???????}        : ori    = 1'b1;
    {I_TYPE, 3'b111, 7'b???????}        : andi   = 1'b1;
    {I_TYPE, 3'b001, 7'b0000000}        : slli   = 1'b1;
    {I_TYPE, 3'b101, 7'b0000000}        : srli   = 1'b1;
    {I_TYPE, 3'b101, 7'b0100000}        : srai   = 1'b1;
    // B-type
    {B_TYPE, 3'b000, 7'b???????}        : beq    = 1'b1;
    {B_TYPE, 3'b001, 7'b???????}        : bne    = 1'b1;
    {B_TYPE, 3'b100, 7'b???????}        : blt    = 1'b1;
    {B_TYPE, 3'b101, 7'b???????}        : bge    = 1'b1;
    {B_TYPE, 3'b110, 7'b???????}        : bltu   = 1'b1;
    {B_TYPE, 3'b111, 7'b???????}        : bgeu   = 1'b1;
    // U-type
    {U_TYPE, 3'b???, 7'b???????}        : lui    = 1'b1;
    {AUIPC_TYPE, 3'b???, 7'b???????}    : auipc  = 1'b1;
    // J-type
    {JAL_TYPE, 3'b???, 7'b???????}      : jal    = 1'b1;
    {JALR_TYPE, 3'b???, 7'b???????}     : jalr   = 1'b1;
    // L-type
    {L_TYPE, 3'b010, 7'b???????}        : lw     = 1'b1;
    {L_TYPE, 3'b001, 7'b???????}        : lh     = 1'b1;
    {L_TYPE, 3'b101, 7'b???????}        : lhu    = 1'b1;
    {L_TYPE, 3'b000, 7'b???????}        : lb     = 1'b1;
    {L_TYPE, 3'b100, 7'b???????}        : lbu    = 1'b1;
    {L_TYPE, 3'b011, 7'b???????}        : ld     = 1'b1;
    // S-type
    {S_TYPE, 3'b010, 7'b???????}        : sw     = 1'b1;
    {S_TYPE, 3'b001, 7'b???????}        : sh     = 1'b1;
    {S_TYPE, 3'b000, 7'b???????}        : sb     = 1'b1;
    {S_TYPE, 3'b011, 7'b???????}        : sd     = 1'b1;
    // P-type
    {P_TYPE, 3'b000, 7'b0000000}        : ecall  = ~instr_i[20];
    {P_TYPE, 3'b000, 7'b0000000}        : ebreak =  instr_i[20];
    {P_TYPE, 3'b001, 7'b???????}        : csrrw  = 1'b1;
    {P_TYPE, 3'b010, 7'b???????}        : csrrs  = 1'b1;
    {P_TYPE, 3'b011, 7'b???????}        : csrrc  = 1'b1;
    {P_TYPE, 3'b101, 7'b???????}        : csrrwi = 1'b1;
    {P_TYPE, 3'b110, 7'b???????}        : csrrsi = 1'b1;
    {P_TYPE, 3'b111, 7'b???????}        : csrrci = 1'b1;
    {P_TYPE, 3'b000, 7'b0011000}        : mret   = instr_i[21];
    {P_TYPE, 3'b000, 7'b0001000}        : sret   = instr_i[21];
    {FENCE_TYPE , 3'b000, 7'b???????}   : fence  = 1'b1;
    default : illegal_inst = 1'b1;
  endcase
end

//-------------------------
// Register affectation
//-------------------------
// rd
// Clamp rd as not valid
assign wbk_v      = (r_type | i_type | l_type | fence | p_type & ~(ecall | ebreak) | lui | auipc | jal | jalr) & |wbk_adr;
assign wbk_adr    = instr_i[11:7];
// src1
assign rs1_v     = (r_type | i_type | jalr | b_type | s_type | l_type | fence
                  | csrrw | csrrc | csrrs | jalr) & |rs1_adr;
assign rs1_adr   = instr_i[19:15];
// src2
assign rs2_v     = (r_type | b_type | s_type) & |rs2_adr;
assign rs2_adr   = instr_i[24:20];

//-------------------------
// Additionnal informations
//-------------------------
assign is_csr              = csrrw | csrrs | csrrc | csrrwi | csrrsi | csrrci;
assign is_store            = s_type ;
assign is_load             = lb | lh | lw | lbu | lhu;
assign is_branch           = b_type | jal | jalr;
assign is_mul              = mul | mulh | mulhsu | mulhu;
assign is_div              = div | divu | rem | remu;
assign is_arithm           = (r_type | i_type) & ~(sll | srl | sra | slli | srli | srai) | lui | auipc;
assign is_shift            = (r_type | i_type) & (sll | srl | sra | slli | srli | srai);
assign unsign_extension    = bltu | bgeu | lbu | lhu | sltiu | sltu;

//-------------------------
// Outputs
//-------------------------
// rd
assign wbk_v_o             = wbk_v;
assign wbk_adr_o           = wbk_adr;
// Csr register
assign csr_wbk_o          = mret | csrrw | csrrwi
                          | (csrrc  | csrrs ) & |rs1_adr
                          | (csrrci | csrrsi) & |imm;
assign csr_clear_o        = csrrc | csrrci;
assign wbk_csr_adr_o      = {12{~mret}} & instr_i[31:20]
                          | {12{ mret}} & CSR_MSTATUS;
// rs1
assign rs1_v_o      = rs1_v;
assign rs1_adr_o    = rs1_adr;
// rs2
assign rs2_v_o      = rs2_v;
assign rs2_adr_o    = rs2_adr;
// additionnal informations
assign ecall_o             = ecall;
assign auipc_o             = auipc;
assign rs1_is_immediat_o   = csrrwi | csrrsi | csrrci;
assign rs2_is_immediat_o   = lui | auipc | jalr | jalr | i_type | l_type;
assign rs2_is_csr_o        = csrrw | csrrs | csrrc | csrrwi | csrrsi | csrrci | mret;
assign imm                 = {32{(i_type | jalr | l_type)}}  & {{20{instr_i[31]}}, instr_i[31:20]}
                           | {32{s_type}}                    & {{20{instr_i[31]}}, instr_i[31:25],instr_i[11:7]}
                           | {32{b_type}}                    & {{19{instr_i[31]}}, instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0}
                           | {32{jal}}                       & {{11{instr_i[31]}}, instr_i[31],instr_i[19:12],instr_i[20],instr_i[30:21],1'b0}
                           | {32{auipc | lui}}               & {instr_i[31:12], 12'b0}
                           | {32{csrrwi | csrrsi | csrrci}}  & {27'd0, instr_i[19:15]};
assign immediat_o          = imm;
assign illegal_inst_o      = illegal_inst;
assign rs2_ca2_v_o         = sub | bge | blt | bgeu | bltu | slt | sltu | slti | sltiu;
//-------------------------
// Unit/op encoding
//-------------------------

// should encode the operation, add, sub, sll, slr, sra...etc
// msb encodes the unit, lsb encodes the operation
// 00001 xxx : alu
// 00010 xxx : shifter
// 00100 xxx : branch
// 01000 xxx : lsu
// lsb encodes the operation :
// Arithmetic unit :
  // 00001 000001 : add, sub
  // 00001 000010 : and
  // 00001 000100 : or
  // 00001 001000 : xor
  // 00001 010000 : slt
// Shifter unit :
  // 00010 000001 : sll
  // 00010 000010 : srl
  // 00010 000100 : sra
// Branch unit :
  // 00100 000001 : beq
  // 00100 000010 : bne
  // 00100 000100 : blt
  // 00100 001000 : bge
  // 00100 010000 : jal
  // 00100 100000 : jalr
// lsu unit :
  // 01000 000001 : store
  // 01000 000010 : load

assign unit_o           = {1'b0, 1'b0, is_load | is_store, is_branch, is_shift, is_arithm | is_csr};
assign operation_o[5]   = jalr;
assign operation_o[4]   = slt  | sltu | slti | sltiu | jal;
assign operation_o[3]   = xorr | xori | bge  | bgeu;
assign operation_o[2]   = orr  | ori  | sra  | srai | blt | bltu | csrrs |csrrsi;
assign operation_o[1]   = andd | andi | srl  | srli | bne   | is_load | csrrc |csrrci;
assign operation_o[0]   = add  | sub  | addi | sll  | slli  | lui  | auipc | beq | s_type;
// Access size :
  // 001 : byte
  // 010 : half-word
  // 100 : word
assign access_size_o      = {{lw | sw}, {lh | lhu | sh}, {lb | lbu | sb}};
assign unsign_extension_o = unsign_extension;
// Optimisation made to avoid using alu
assign csrrw_o            = csrrw | csrrwi;
assign mret_o             = mret;
assign sret_o             = sret;
endmodule