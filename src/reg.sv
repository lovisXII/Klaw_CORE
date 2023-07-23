import riscv::*;

module register_file(
    input logic clk,
    input logic reset_n,
    // read ports
    input  logic               rs1_v_i,
    input  logic [NB_REGS-1:0] rs1_adr_i,
    output logic [XLEN-1:0]    rs1_data_o,
    input  logic               rs2_v_i,
    input  logic [NB_REGS-1:0] rs2_adr_i,
    output logic [XLEN-1:0]    rs2_data_o,

    // write ports
    input logic               write_valid_i,
    input logic [NB_REGS-1:0] write_adr_i,
    input logic [XLEN-1:0]    write_data_i
);

logic            reg0_next_valid;
logic [XLEN-1:0] reg0_q;
logic            reg1_next_valid;
logic [XLEN-1:0] reg1_q;
logic            reg2_next_valid;
logic [XLEN-1:0] reg2_q;
logic            reg3_next_valid;
logic [XLEN-1:0] reg3_q;
logic            reg4_next_valid;
logic [XLEN-1:0] reg4_q;
logic            reg5_next_valid;
logic [XLEN-1:0] reg5_q;
logic            reg6_next_valid;
logic [XLEN-1:0] reg6_q;
logic            reg7_next_valid;
logic [XLEN-1:0] reg7_q;
logic            reg8_next_valid;
logic [XLEN-1:0] reg8_q;
logic            reg9_next_valid;
logic [XLEN-1:0] reg9_q;
logic            reg10_next_valid;
logic [XLEN-1:0] reg10_q;
logic            reg11_next_valid;
logic [XLEN-1:0] reg11_q;
logic            reg12_next_valid;
logic [XLEN-1:0] reg12_q;
logic            reg13_next_valid;
logic [XLEN-1:0] reg13_q;
logic            reg14_next_valid;
logic [XLEN-1:0] reg14_q;
logic            reg15_next_valid;
logic [XLEN-1:0] reg15_q;
logic            reg16_next_valid;
logic [XLEN-1:0] reg16_q;
logic            reg17_next_valid;
logic [XLEN-1:0] reg17_q;
logic            reg18_next_valid;
logic [XLEN-1:0] reg18_q;
logic            reg19_next_valid;
logic [XLEN-1:0] reg19_q;
logic            reg20_next_valid;
logic [XLEN-1:0] reg20_q;
logic            reg21_next_valid;
logic [XLEN-1:0] reg21_q;
logic            reg22_next_valid;
logic [XLEN-1:0] reg22_q;
logic            reg23_next_valid;
logic [XLEN-1:0] reg23_q;
logic            reg24_next_valid;
logic [XLEN-1:0] reg24_q;
logic            reg25_next_valid;
logic [XLEN-1:0] reg25_q;
logic            reg26_next_valid;
logic [XLEN-1:0] reg26_q;
logic            reg27_next_valid;
logic [XLEN-1:0] reg27_q;
logic            reg28_next_valid;
logic [XLEN-1:0] reg28_q;
logic            reg29_next_valid;
logic [XLEN-1:0] reg29_q;
logic            reg30_next_valid;
logic [XLEN-1:0] reg30_q;
logic            reg31_next_valid;
logic [XLEN-1:0] reg31_q;


assign reg0_next_valid    = (5'd0 == write_adr_i);
assign reg1_next_valid    = (5'd1 == write_adr_i);
assign reg2_next_valid    = (5'd2 == write_adr_i);
assign reg3_next_valid    = (5'd3 == write_adr_i);
assign reg4_next_valid    = (5'd4 == write_adr_i);
assign reg5_next_valid    = (5'd5 == write_adr_i);
assign reg6_next_valid    = (5'd6 == write_adr_i);
assign reg7_next_valid    = (5'd7 == write_adr_i);
assign reg8_next_valid    = (5'd8 == write_adr_i);
assign reg9_next_valid    = (5'd9 == write_adr_i);
assign reg10_next_valid   = (5'd10 == write_adr_i);
assign reg11_next_valid   = (5'd11 == write_adr_i);
assign reg12_next_valid   = (5'd12 == write_adr_i);
assign reg13_next_valid   = (5'd13 == write_adr_i);
assign reg14_next_valid   = (5'd14 == write_adr_i);
assign reg15_next_valid   = (5'd15 == write_adr_i);
assign reg16_next_valid   = (5'd16 == write_adr_i);
assign reg17_next_valid   = (5'd17 == write_adr_i);
assign reg18_next_valid   = (5'd18 == write_adr_i);
assign reg19_next_valid   = (5'd19 == write_adr_i);
assign reg20_next_valid   = (5'd20 == write_adr_i);
assign reg21_next_valid   = (5'd21 == write_adr_i);
assign reg22_next_valid   = (5'd22 == write_adr_i);
assign reg23_next_valid   = (5'd23 == write_adr_i);
assign reg24_next_valid   = (5'd24 == write_adr_i);
assign reg25_next_valid   = (5'd25 == write_adr_i);
assign reg26_next_valid   = (5'd26 == write_adr_i);
assign reg27_next_valid   = (5'd27 == write_adr_i);
assign reg28_next_valid   = (5'd28 == write_adr_i);
assign reg29_next_valid   = (5'd29 == write_adr_i);
assign reg30_next_valid   = (5'd30 == write_adr_i);
assign reg31_next_valid   = (5'd31 == write_adr_i);


always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg0_q <= 32'h0;
    end else begin
        if (reg0_next_valid) begin
            reg0_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg1_q <= 32'h0;
    end else begin
        if (reg1_next_valid) begin
            reg1_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg2_q <= 32'h0;
    end else begin
        if (reg2_next_valid) begin
            reg2_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg3_q <= 32'h0;
    end else begin
        if (reg3_next_valid) begin
            reg3_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg4_q <= 32'h0;
    end else begin
        if (reg4_next_valid) begin
            reg4_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg5_q <= 32'h0;
    end else begin
        if (reg5_next_valid) begin
            reg5_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg6_q <= 32'h0;
    end else begin
        if (reg6_next_valid) begin
            reg6_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg7_q <= 32'h0;
    end else begin
        if (reg7_next_valid) begin
            reg7_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg8_q <= 32'h0;
    end else begin
        if (reg8_next_valid) begin
            reg8_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg9_q <= 32'h0;
    end else begin
        if (reg9_next_valid) begin
            reg9_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg10_q <= 32'h0;
    end else begin
        if (reg10_next_valid) begin
            reg10_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg11_q <= 32'h0;
    end else begin
        if (reg11_next_valid) begin
            reg11_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg12_q <= 32'h0;
    end else begin
        if (reg12_next_valid) begin
            reg12_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg13_q <= 32'h0;
    end else begin
        if (reg13_next_valid) begin
            reg13_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg14_q <= 32'h0;
    end else begin
        if (reg14_next_valid) begin
            reg14_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg15_q <= 32'h0;
    end else begin
        if (reg15_next_valid) begin
            reg15_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg16_q <= 32'h0;
    end else begin
        if (reg16_next_valid) begin
            reg16_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg17_q <= 32'h0;
    end else begin
        if (reg17_next_valid) begin
            reg17_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg18_q <= 32'h0;
    end else begin
        if (reg18_next_valid) begin
            reg18_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg19_q <= 32'h0;
    end else begin
        if (reg19_next_valid) begin
            reg19_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg20_q <= 32'h0;
    end else begin
        if (reg20_next_valid) begin
            reg20_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg21_q <= 32'h0;
    end else begin
        if (reg21_next_valid) begin
            reg21_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg22_q <= 32'h0;
    end else begin
        if (reg22_next_valid) begin
            reg22_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg23_q <= 32'h0;
    end else begin
        if (reg23_next_valid) begin
            reg23_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg24_q <= 32'h0;
    end else begin
        if (reg24_next_valid) begin
            reg24_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg25_q <= 32'h0;
    end else begin
        if (reg25_next_valid) begin
            reg25_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg26_q <= 32'h0;
    end else begin
        if (reg26_next_valid) begin
            reg26_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg27_q <= 32'h0;
    end else begin
        if (reg27_next_valid) begin
            reg27_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg28_q <= 32'h0;
    end else begin
        if (reg28_next_valid) begin
            reg28_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg29_q <= 32'h0;
    end else begin
        if (reg29_next_valid) begin
            reg29_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg30_q <= 32'h0;
    end else begin
        if (reg30_next_valid) begin
            reg30_q <= write_data_i;
        end
    end
end
always_ff @(posedge clk, negedge reset_n) begin
    if (~reset_n) begin
            reg31_q <= 32'h0;
    end else begin
        if (reg31_next_valid) begin
            reg31_q <= write_data_i;
        end
    end
end


assign rs1_data_o   = 32'b0
                    | {XLEN{5'd0 == rs1_adr_i}} & reg0_q
                    | {XLEN{5'd1 == rs1_adr_i}} & reg1_q
                    | {XLEN{5'd2 == rs1_adr_i}} & reg2_q
                    | {XLEN{5'd3 == rs1_adr_i}} & reg3_q
                    | {XLEN{5'd4 == rs1_adr_i}} & reg4_q
                    | {XLEN{5'd5 == rs1_adr_i}} & reg5_q
                    | {XLEN{5'd6 == rs1_adr_i}} & reg6_q
                    | {XLEN{5'd7 == rs1_adr_i}} & reg7_q
                    | {XLEN{5'd8 == rs1_adr_i}} & reg8_q
                    | {XLEN{5'd9 == rs1_adr_i}} & reg9_q
                    | {XLEN{5'd10 == rs1_adr_i}} & reg10_q
                    | {XLEN{5'd11 == rs1_adr_i}} & reg11_q
                    | {XLEN{5'd12 == rs1_adr_i}} & reg12_q
                    | {XLEN{5'd13 == rs1_adr_i}} & reg13_q
                    | {XLEN{5'd14 == rs1_adr_i}} & reg14_q
                    | {XLEN{5'd15 == rs1_adr_i}} & reg15_q
                    | {XLEN{5'd16 == rs1_adr_i}} & reg16_q
                    | {XLEN{5'd17 == rs1_adr_i}} & reg17_q
                    | {XLEN{5'd18 == rs1_adr_i}} & reg18_q
                    | {XLEN{5'd19 == rs1_adr_i}} & reg19_q
                    | {XLEN{5'd20 == rs1_adr_i}} & reg20_q
                    | {XLEN{5'd21 == rs1_adr_i}} & reg21_q
                    | {XLEN{5'd22 == rs1_adr_i}} & reg22_q
                    | {XLEN{5'd23 == rs1_adr_i}} & reg23_q
                    | {XLEN{5'd24 == rs1_adr_i}} & reg24_q
                    | {XLEN{5'd25 == rs1_adr_i}} & reg25_q
                    | {XLEN{5'd26 == rs1_adr_i}} & reg26_q
                    | {XLEN{5'd27 == rs1_adr_i}} & reg27_q
                    | {XLEN{5'd28 == rs1_adr_i}} & reg28_q
                    | {XLEN{5'd29 == rs1_adr_i}} & reg29_q
                    | {XLEN{5'd30 == rs1_adr_i}} & reg30_q
                    | {XLEN{5'd31 == rs1_adr_i}} & reg31_q
                    ;

assign rs2_data_o   = 32'b0
                    | {XLEN{5'd0 == rs2_adr_i}} & reg0_q
                    | {XLEN{5'd1 == rs2_adr_i}} & reg1_q
                    | {XLEN{5'd2 == rs2_adr_i}} & reg2_q
                    | {XLEN{5'd3 == rs2_adr_i}} & reg3_q
                    | {XLEN{5'd4 == rs2_adr_i}} & reg4_q
                    | {XLEN{5'd5 == rs2_adr_i}} & reg5_q
                    | {XLEN{5'd6 == rs2_adr_i}} & reg6_q
                    | {XLEN{5'd7 == rs2_adr_i}} & reg7_q
                    | {XLEN{5'd8 == rs2_adr_i}} & reg8_q
                    | {XLEN{5'd9 == rs2_adr_i}} & reg9_q
                    | {XLEN{5'd10 == rs2_adr_i}} & reg10_q
                    | {XLEN{5'd11 == rs2_adr_i}} & reg11_q
                    | {XLEN{5'd12 == rs2_adr_i}} & reg12_q
                    | {XLEN{5'd13 == rs2_adr_i}} & reg13_q
                    | {XLEN{5'd14 == rs2_adr_i}} & reg14_q
                    | {XLEN{5'd15 == rs2_adr_i}} & reg15_q
                    | {XLEN{5'd16 == rs2_adr_i}} & reg16_q
                    | {XLEN{5'd17 == rs2_adr_i}} & reg17_q
                    | {XLEN{5'd18 == rs2_adr_i}} & reg18_q
                    | {XLEN{5'd19 == rs2_adr_i}} & reg19_q
                    | {XLEN{5'd20 == rs2_adr_i}} & reg20_q
                    | {XLEN{5'd21 == rs2_adr_i}} & reg21_q
                    | {XLEN{5'd22 == rs2_adr_i}} & reg22_q
                    | {XLEN{5'd23 == rs2_adr_i}} & reg23_q
                    | {XLEN{5'd24 == rs2_adr_i}} & reg24_q
                    | {XLEN{5'd25 == rs2_adr_i}} & reg25_q
                    | {XLEN{5'd26 == rs2_adr_i}} & reg26_q
                    | {XLEN{5'd27 == rs2_adr_i}} & reg27_q
                    | {XLEN{5'd28 == rs2_adr_i}} & reg28_q
                    | {XLEN{5'd29 == rs2_adr_i}} & reg29_q
                    | {XLEN{5'd30 == rs2_adr_i}} & reg30_q
                    | {XLEN{5'd31 == rs2_adr_i}} & reg31_q
                    ;
endmodule