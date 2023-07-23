module shifter(
    input logic [31:0] data_i,
    input logic [4:0] shift_value_i,
    input logic [1:0] cmd_i,
    output logic [31:0] data_o
);

    logic [31:0] lshift16, lshift8, lshift4, lshift2, lshift1;
    logic [31:0] rshift16, rshift8, rshift4, rshift2, rshift1;

    logic [15:0] bits16;
    logic [7:0] bits8;
    logic [3:0] bits4;
    logic [1:0] bits2;
    logic bit1;

    // select right shifting bits in case of arithmetic shift
    assign bits16   = (cmd_i[1])       ? {16{data_i[31]}}          : 16'h0000;
    assign bits8    = (cmd_i[1])       ? {8{data_i[31]}}           : 8'h00;
    assign bits4    = (cmd_i[1])       ? {4{data_i[31]}}           : 4'h0;
    assign bits2    = (cmd_i[1])       ? {2{data_i[31]}}           : 2'h0;
    assign bit1     = (cmd_i[1])       ? data_i[31]                : 1'b0;

    // Shift Right
    assign rshift16 = (shift_value_i[4]) ? {bits16, data_i[31:16]}   : data_i;
    assign rshift8  = (shift_value_i[3]) ? {bits8, rshift16[31:8]}   : rshift16;
    assign rshift4  = (shift_value_i[2]) ? {bits4, rshift8[31:4]}    : rshift8;
    assign rshift2  = (shift_value_i[1]) ? {bits2, rshift4[31:2]}    : rshift4;
    assign rshift1  = (shift_value_i[0]) ? {bit1, rshift2[31:1]}     : rshift2;

    // Shift Left
    assign lshift16 = (shift_value_i[4]) ? {data_i[15:0], 16'h0000}  : data_i;
    assign lshift8  = (shift_value_i[3]) ? {lshift16[23:0], 8'h00}   : lshift16;
    assign lshift4  = (shift_value_i[2]) ? {lshift8[27:0], 4'h0}     : lshift8;
    assign lshift2  = (shift_value_i[1]) ? {lshift4[29:0], 2'h0}     : lshift4;
    assign lshift1  = (shift_value_i[0]) ? {lshift2[30:0], 1'b0}     : lshift2;

    // Output selection
    assign data_o = (cmd_i == 2'b00) ? lshift1 : rshift1;

endmodule