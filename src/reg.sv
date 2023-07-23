module register_file(
    input logic clk,
    input logic reset_n,
    // read ports
%% for i in range(2):
    input logic [5:0]   read_adr{<i>}_i,
    output logic [31:0] read_data{<i>}_o,
%% endfor
    // write ports
    input logic        write_valid_i,
    input logic [5:0]  write_adr_i,
    input logic [31:0] write_data_i,

);
%% for i in range(32):
logic[XLEN-1:0] reg{<i>}_next;
logic [31:0]    reg{<i>}_q;
%% endfor

%% for bank in range(32):
assign reg{<bank>}_next = {XLEN{{6'b{{<bank>}}} & write_adr_i}} & write_data_i;
%% endfor

%% for adr in range(32):
always_ff @(posedge clk, negedge reset_n) begin        
    if (~reset_n) begin
            reg{<adr>}_q <= 32'h0;
    end else begin
        if (write_valid_i) begin
            reg{<adr>}_q <= reg{<adr>}_next; 
        end
    end
end
%% endfor

%% for adr in range(32):
    assign read_data1_o = {XLEN{{6'b{{<adr>}}} & read_adr1_i}} & reg{<adr>}_q;
    assign read_data2_o = {XLEN{{6'b{{<adr>}}} & read_adr2_i}} & reg{<adr>}_q;
%% endfor
endmodule