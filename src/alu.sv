module ALU #(parameter int bitWidth = 32) 
(
    input logic[bitWidth-1:0]  rs1_data_i,
    input logic[bitWidth-1:0]  rs2_data_i,
    input logic                Cin_i,
    input logic[1:0]           cmd_i,
    output logic[bitWidth-1:0] data_o
);

always_comb begin
    case(cmd)
    2'b00: out = rs1 + rs2 + Cin; //add
    2'b01: out = rs1 & rs2; //and
    2'b10: out = rs1 | rs2; //OR
    2'b11: out = rs1 ^ rs2; //XOR  
    endcase
end
endmodule