package riscv;

localparam XLEN                 = 64;
localparam XLEN_SIZE            = $clog2(64);
localparam FRONTEND_WIDTH       = 2;
localparam PHYS_REGS_SIZE       = 64;
localparam PHYS_REGS_ADDR_SIZE  = $clog2(PHYS_REGS_SIZE);
localparam NBR_UNIT             = 6;
localparam NBR_OPERATION        = 6;
typedef enum logic [6:0]{
    R_TYPE   = 7'b0110011,
    I_TYPE   = 7'b0010011,
    L_TYPE   = 7'b0000011, // loads
    S_TYPE   = 7'b0100011,
    B_TYPE   = 7'b1100011,
    U_TYPE   = 7'b0110111,
    AUIPC    = 7'b0010111, 
    JAL      = 7'b1101111,
    JALR     = 7'b1100111,
    P_TYPE   = 7'b1110011, // priviledge type
    FENCE    = 7'b0001111,
    R64_TYPE = 7'b0111011, // 64 bits mul & r
    I64_TYPE = 7'b0011011
} inst_type_t;

typedef enum logic [12:0] {
  R_TYPE_ONE_HOT   = 13'b0000000000001,
  I_TYPE_ONE_HOT   = 13'b0000000000010,
  L_TYPE_ONE_HOT   = 13'b0000000000100,
  S_TYPE_ONE_HOT   = 13'b0000000001000,
  B_TYPE_ONE_HOT   = 13'b0000000010000,
  U_TYPE_ONE_HOT   = 13'b0000000100000,
  P_TYPE_ONE_HOT   = 13'b0000001000000,
  FENCE_ONE_HOT    = 13'b0000010000000,
  AUIPC_ONE_HOT    = 13'b0000100000000,
  JALR_ONE_HOT     = 13'b0001000000000,
  JAL_ONE_HOT      = 13'b0010000000000,
  R64_TYPE_ONE_HOT = 13'b0100000000000,
  I64_TYPE_ONE_HOT = 13'b1000000000000
}instr_one_hot_t;

typedef enum logic [11:0] {
        // Floating-Point CSRs
        CSR_FFLAGS         = 12'h001,
        CSR_FRM            = 12'h002,
        CSR_FCSR           = 12'h003,
        CSR_FTRAN          = 12'h800,
        // Supervisor Mode CSRs
        CSR_SSTATUS        = 12'h100,
        CSR_SIE            = 12'h104,
        CSR_STVEC          = 12'h105,
        CSR_SCOUNTEREN     = 12'h106,
        CSR_SSCRATCH       = 12'h140,
        CSR_SEPC           = 12'h141,
        CSR_SCAUSE         = 12'h142,
        CSR_STVAL          = 12'h143,
        CSR_SIP            = 12'h144,
        CSR_SATP           = 12'h180,
        CSR_ADR_PROTECTED  = 12'hDC0, // Custom CSR : address protection top
        // Machine Mode CSRs
        CSR_MSTATUS        = 12'h300,
        CSR_MISA           = 12'h301,
        CSR_MEDELEG        = 12'h302,
        CSR_MIDELEG        = 12'h303,
        CSR_MIE            = 12'h304,
        CSR_MTVEC          = 12'h305,
        CSR_MCOUNTEREN     = 12'h306,
        CSR_MSCRATCH       = 12'h340,
        CSR_MEPC           = 12'h341,
        CSR_MCAUSE         = 12'h342,
        CSR_MTVAL          = 12'h343,
        CSR_MIP            = 12'h344,
        CSR_PMPCFG0        = 12'h3A0,
        CSR_PMPCFG1        = 12'h3A1,
        CSR_PMPCFG2        = 12'h3A2,
        CSR_PMPCFG3        = 12'h3A3,
        CSR_PMPADDR0       = 12'h3B0,
        CSR_PMPADDR1       = 12'h3B1,
        CSR_PMPADDR2       = 12'h3B2,
        CSR_PMPADDR3       = 12'h3B3,
        CSR_PMPADDR4       = 12'h3B4,
        CSR_PMPADDR5       = 12'h3B5,
        CSR_PMPADDR6       = 12'h3B6,
        CSR_PMPADDR7       = 12'h3B7,
        CSR_PMPADDR8       = 12'h3B8,
        CSR_PMPADDR9       = 12'h3B9,
        CSR_PMPADDR10      = 12'h3BA,
        CSR_PMPADDR11      = 12'h3BB,
        CSR_PMPADDR12      = 12'h3BC,
        CSR_PMPADDR13      = 12'h3BD,
        CSR_PMPADDR14      = 12'h3BE,
        CSR_PMPADDR15      = 12'h3BF,
        CSR_MVENDORID      = 12'hF11,
        CSR_MARCHID        = 12'hF12,
        CSR_MIMPID         = 12'hF13,
        CSR_MHARTID        = 12'hF14,
        CSR_MCYCLE         = 12'hB00,
        CSR_MINSTRET       = 12'hB02,
        // Performance counters (Machine Mode)
        CSR_ML1_ICACHE_MISS = 12'hB03,  // L1 Instr Cache Miss
        CSR_ML1_DCACHE_MISS = 12'hB04,  // L1 Data Cache Miss
        CSR_MITLB_MISS      = 12'hB05,  // ITLB Miss
        CSR_MDTLB_MISS      = 12'hB06,  // DTLB Miss
        CSR_MLOAD           = 12'hB07,  // Loads
        CSR_MSTORE          = 12'hB08,  // Stores
        CSR_MEXCEPTION      = 12'hB09,  // Taken exceptions
        CSR_MEXCEPTION_RET  = 12'hB0A,  // Exception return
        CSR_MBRANCH_JUMP    = 12'hB0B,  // Software change of PC
        CSR_MCALL           = 12'hB0C,  // Procedure call
        CSR_MRET            = 12'hB0D,  // Procedure Return
        CSR_MMIS_PREDICT    = 12'hB0E,  // Branch mis-predicted
        CSR_MSB_FULL        = 12'hB0F,  // Scoreboard full
        CSR_MIF_EMPTY       = 12'hB10,  // instruction fetch queue empty
        CSR_MHPM_COUNTER_17 = 12'hB11,  // reserved
        CSR_MHPM_COUNTER_18 = 12'hB12,  // reserved
        CSR_MHPM_COUNTER_19 = 12'hB13,  // reserved
        CSR_MHPM_COUNTER_20 = 12'hB14,  // reserved
        CSR_MHPM_COUNTER_21 = 12'hB15,  // reserved
        CSR_MHPM_COUNTER_22 = 12'hB16,  // reserved
        CSR_MHPM_COUNTER_23 = 12'hB17,  // reserved
        CSR_MHPM_COUNTER_24 = 12'hB18,  // reserved
        CSR_MHPM_COUNTER_25 = 12'hB19,  // reserved
        CSR_MHPM_COUNTER_26 = 12'hB1A,  // reserved
        CSR_MHPM_COUNTER_27 = 12'hB1B,  // reserved
        CSR_MHPM_COUNTER_28 = 12'hB1C,  // reserved
        CSR_MHPM_COUNTER_29 = 12'hB1D,  // reserved
        CSR_MHPM_COUNTER_30 = 12'hB1E,  // reserved
        CSR_MHPM_COUNTER_31 = 12'hB1F,  // reserved
        // Cache Control (platform specifc)
        CSR_DCACHE         = 12'h701,
        CSR_ICACHE         = 12'h700,
        // Triggers
        CSR_TSELECT        = 12'h7A0,
        CSR_TDATA1         = 12'h7A1,
        CSR_TDATA2         = 12'h7A2,
        CSR_TDATA3         = 12'h7A3,
        CSR_TINFO          = 12'h7A4,
        // Debug CSR
        CSR_DCSR           = 12'h7b0,
        CSR_DPC            = 12'h7b1,
        CSR_DSCRATCH0      = 12'h7b2, // optional
        CSR_DSCRATCH1      = 12'h7b3, // optional
        // Counters and Timers (User Mode - R/O Shadows)
        CSR_CYCLE          = 12'hC00,
        CSR_TIME           = 12'hC01,
        CSR_INSTRET        = 12'hC02,
        // Performance counters (User Mode - R/O Shadows)
        CSR_L1_ICACHE_MISS = 12'hC03,  // L1 Instr Cache Miss
        CSR_L1_DCACHE_MISS = 12'hC04,  // L1 Data Cache Miss
        CSR_ITLB_MISS      = 12'hC05,  // ITLB Miss
        CSR_DTLB_MISS      = 12'hC06,  // DTLB Miss
        CSR_LOAD           = 12'hC07,  // Loads
        CSR_STORE          = 12'hC08,  // Stores
        CSR_EXCEPTION      = 12'hC09,  // Taken exceptions
        CSR_EXCEPTION_RET  = 12'hC0A,  // Exception return
        CSR_BRANCH_JUMP    = 12'hC0B,  // Software change of PC
        CSR_CALL           = 12'hC0C,  // Procedure call
        CSR_RET            = 12'hC0D,  // Procedure Return
        CSR_MIS_PREDICT    = 12'hC0E,  // Branch mis-predicted
        CSR_SB_FULL        = 12'hC0F,  // Scoreboard full
        CSR_IF_EMPTY       = 12'hC10,  // instruction fetch queue empty
        CSR_HPM_COUNTER_17 = 12'hC11,  // reserved
        CSR_HPM_COUNTER_18 = 12'hC12,  // reserved
        CSR_HPM_COUNTER_19 = 12'hC13,  // reserved
        CSR_HPM_COUNTER_20 = 12'hC14,  // reserved
        CSR_HPM_COUNTER_21 = 12'hC15,  // reserved
        CSR_HPM_COUNTER_22 = 12'hC16,  // reserved
        CSR_HPM_COUNTER_23 = 12'hC17,  // reserved
        CSR_HPM_COUNTER_24 = 12'hC18,  // reserved
        CSR_HPM_COUNTER_25 = 12'hC19,  // reserved
        CSR_HPM_COUNTER_26 = 12'hC1A,  // reserved
        CSR_HPM_COUNTER_27 = 12'hC1B,  // reserved
        CSR_HPM_COUNTER_28 = 12'hC1C,  // reserved
        CSR_HPM_COUNTER_29 = 12'hC1D,  // reserved
        CSR_HPM_COUNTER_30 = 12'hC1E,  // reserved
        CSR_HPM_COUNTER_31 = 12'hC1F  // reserved
    } csr_reg_t;

    // instr decoded
    // operation can be :
    // addition         000
    // shift left       001
    // shift right      101
    // xor              100
    // or               110
    // and              111
    // multiplication   
    typedef struct packed {
        logic [4:0] rs1;
        logic [4:0] rs2;
        logic [4:0] rd;
        logic       rs1_v;
        logic       rs2_v;
        logic       rd_v;
        logic [3:0] operation;
        logic       is_load;
        logic       is_store;
        logic       is_branch;
        logic       is_csr;
    } instr_dec_t;
endpackage