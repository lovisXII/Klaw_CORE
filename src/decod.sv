import riscv::*;

module dec (
  input logic                 clk,
  input logic                 resetn,
%% for i in range(1):
// -----------------------
//      LINE {<i>}
// -----------------------
  // Ifetch Interface
  input logic [XLEN-1:0]             line{<i>}_instr_i,
  input logic [XLEN-1:0]             line{<i>}_pc_i,
  // Exception
  output logic                       line{<i>}_exe_illegal_inst_o,
  // Registers Destination 
  output logic                       line{<i>}_rd_v_o, 
  output logic [4:0]                 line{<i>}_rd_o, 
  // Registers Source 1
  // RF Interface
  output logic                       line{<i>}_rs1_v_o,
  output logic [4:0]                 line{<i>}_rs1_o,
  input logic [XLEN-1:0]             line{<i>}_rs1_data_i, 
  // Execute Interface 
  output logic [XLEN-1:0]            line{<i>}_rs1_data_o,
  // Registers Source 2
  // RF Interface
  input logic [XLEN-1:0]             line{<i>}_rs2_data_i, 
  output logic [4:0]                 line{<i>}_rs2_o,   
  output logic                       line{<i>}_rs2_v_o,
  // Execute Interface 
  output logic [XLEN-1:0]            line{<i>}_rs2_data_o,
  // Execution Unit useful information
  output logic                       line{<i>}_rs2_is_immediat_o, 
  output logic                       line{<i>}_is_store_o,        
  output logic                       line{<i>}_is_load_o,          
  output logic                       line{<i>}_is_branch_o,         
  output logic [2:0]                 line{<i>}_access_size_o,
  output logic [12:0]                line{<i>}_instr_type_o,
  output logic                       line{<i>}_unsign_extension_o,
  output logic [NBR_UNIT-1:0]        line{<i>}_unit_o,
  output logic [NBR_OPERATION-1:0]   line{<i>}_operation_o, 
%% endfor
);
%% for i in range(1):
// -----------------------
//      LINE {<i>}
// -----------------------
  logic                       line{<i>}_illegal_inst;
  // Registers
  logic                       line{<i>}_rd_v; 
  logic [4:0]                 line{<i>}_rd; 
  logic                       line{<i>}_rs1_v;
  logic [4:0]                 line{<i>}_rs1;
  logic                       line{<i>}_rs2_v; 
  logic [4:0]                 line{<i>}_rs2;   
  // Additionnal informations
  logic                       line{<i>}_rs2_is_immediat; 
  logic                       line{<i>}_is_store;        
  logic                       line{<i>}_is_load;          
  logic                       line{<i>}_is_branch;         
  logic [31:0]                line{<i>}_immediat;
  logic [2:0]                 line{<i>}_access_size;
  logic [12:0]                line{<i>}_instr_type;
  logic                       line{<i>}_unsign_extension;
  logic [NBR_UNIT-1:0]        line{<i>}_unit;
  logic [NBR_OPERATION-1:0]   line{<i>}_operation; 
%% endfor
  // Instanciated the decoders
  %% for i in range(2):
  decoder dec{<i>}(
      .instr_i            (line{<i>}_instr_i),
      .pc_i               (line{<i>}_pc_i),          
      .illegal_inst_o     (line{<i>}_illegal_inst),
      .rd_v_o             (line{<i>}_rd_v), 
      .rd_o               (line{<i>}_rd), 
      .rs1_v_o            (line{<i>}_rs1_v),
      .rs1_o              (line{<i>}_rs1),
      .rs2_v_o            (line{<i>}_rs2_v), 
      .rs2_o              (line{<i>}_rs2),   
      .rs2_is_immediat_o  (line{<i>}_rs2_is_immediat), 
      .is_store_o         (line{<i>}_is_store),        
      .is_load_o          (line{<i>}_is_load),          
      .is_branch_o        (line{<i>}_is_branch),         
      .immediat_o         (line{<i>}_immediat),
      .access_size_o      (line{<i>}_access_size),
      .instr_type_o       (line{<i>}_instr_type),
      .unsign_extension_o (line{<i>}_unsign_extension), 
      .unit_o             (line{<i>}_unit),
      .operation_o        (line{<i>}_operation) 
  );
%% endfor
  // Flopping outputs
always_ff @(posedge clk, negedge resetn)
  if (!resetn) begin
%% for i in range(1):
            // -----------------------
            //      LINE {<i>}
            // -----------------------
              line{<i>}_illegal_inst_o     <= '0;
              line{<i>}_rd_v_o             <= '0;
              line{<i>}_rd_o               <= '0;
              line{<i>}_rs1_v_o            <= '0;
              line{<i>}_rs1_o              <= '0;
              line{<i>}_rs2_v_o            <= '0;
              line{<i>}_rs2_o              <= '0;
              line{<i>}_rs2_is_immediat_o  <= '0;
              line{<i>}_is_store_o         <= '0;
              line{<i>}_is_load_o          <= '0;
              line{<i>}_is_branch_o        <= '0;
              line{<i>}_immediat_o         <= '0;
              line{<i>}_access_size_o      <= '0;
              line{<i>}_instr_type_o       <= '0;
              line{<i>}_unsign_extension_o <= '0;
              line{<i>}_unit_o             <= '0;
              line{<i>}_operation_o        <= '0; 
%% endfor
  end else begin
%% for i in range(1):
            // -----------------------
            //      LINE {<i>}
            // -----------------------
              line{<i>}_illegal_inst_o     <= illegal_inst;
              line{<i>}_rd_v_o             <= rd_v;
              line{<i>}_rd_o               <= rd;
              line{<i>}_rs1_v_o            <= rs1_v;
              line{<i>}_rs1_o              <= rs1;
              line{<i>}_rs2_v_o            <= rs2_v;
              line{<i>}_rs2_o              <= rs2;
              line{<i>}_rs2_is_immediat_o  <= rs2_is_immediat;
              line{<i>}_is_store_o         <= is_store;
              line{<i>}_is_load_o          <= is_load;
              line{<i>}_is_branch_o        <= is_branch;
              line{<i>}_immediat_o         <= immediat;
              line{<i>}_access_size_o      <= access_size;
              line{<i>}_instr_type_o       <= instr_type;
              line{<i>}_unsign_extension_o <= unsign_extension;
              line{<i>}_unit_o             <= line{<i>}_unit;
              line{<i>}_operation_o        <= line{<i>}_unit; 
%% endfor
  end

%% for i in range(1)
assign line{<i>}_rs1_data_o = line{<i>}_rs1_v & line{<i>}_rs1_data_i;
assign line{<i>}_rs2_data_o = line{<i>}_rs2_v & ~line{<i>}rs2_is_immediat & line{<i>}_rs2_data_i
                            | line{<i>}_rs2_v &  line{<i>}rs2_is_immediat & line{<i>}_immediat
                            | line{<i>}_rs2_v &  line{<i>}rs2_is_immediat & line{<i>}_immediat;
%% endfor
endmodule