module csa (
  input logic [63:0] A,
  input logic [63:0] B,
  input logic [63:0] C,
  output logic [63:0] S0,
  output logic [63:0] S1
);

  logic [63:0] AxB;
  logic [63:0] shf = 64'b0;

  assign AxB = A ^ B;
  assign shf = (A & B) | (AxB & C);

  assign S0 = AxB ^ C;
  assign S1 = {shf[62:0], 1'b0};

endmodule
