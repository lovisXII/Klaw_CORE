module fifo #(
  parameter int N = 1
) (
  input logic clk,
  input logic reset_n,
  input logic [N-1:0] DIN,
  input logic PUSH,
  input logic POP,
  output logic FULL,
  output logic EMPTY,
  output logic [N-1:0] DOUT
);

logic [N-1:0] data;
logic data_v = 0;

always_ff @(posedge clk) begin
  if (reset_n == 0) begin
    data_v <= 0;
  end 
  else begin
    if (data_v == 0) begin
      if (PUSH == 1) begin
        data_v <= 1;
      end else begin
        data_v <= 0;
      end
    end 
    else begin
      if (POP == 1) begin
        if (PUSH == 1) begin
          data_v <= 1;
        end else begin
          data_v <= 0;
        end
      end else begin
        data_v <= 1;
      end
    end
    if (data_v == 0) begin
      if (PUSH == 1) begin
        data <= DIN;
      end
    end else if (PUSH == 1 && POP == 1) begin
      data <= DIN;
    end
  end
end

assign FULL = (data_v == 1 && POP == 0) ? 1 : 0;
assign EMPTY = !data_v;
assign DOUT = data;

endmodule
