`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2025 09:58:54 PM
// Design Name: 
// Module Name: shift_register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module shift_register(
    input wire clk,        // Clock để shift
    input wire data,       // Dữ liệu serial vào
    input wire latch,      // Cạnh lên: chốt dữ liệu ra
    input wire reset,
    output reg [31:0] b0,
    output reg [31:0] b1,
    output reg [31:0] b2,
    output reg [31:0] a1,
    output reg [31:0] a2
);

    // Shift register tạm thời: 160 bit
    reg [159:0] shift_reg = 160'b0;


    always @(posedge clk, posedge reset) begin
        if(reset)   shift_reg <= 160'b0;
        else        shift_reg <= {shift_reg[158:0], data}; // Shift trái và đưa data mới vào bit 0
    end

    // Khi latch = 1, chốt dữ liệu sang các output
    always @(posedge latch, posedge reset) begin
     if(reset)begin
        b0 <= 0;
        b1 <= 0;
        b2 <= 0;
        a1 <= 0;
        a2 <= 0;
     end 
     else if (latch) begin
            b0 <= shift_reg[159:128];
            b1 <= shift_reg[127:96];
            b2 <= shift_reg[95:64];
            a1 <= shift_reg[63:32];
            a2 <= shift_reg[31:0];
        end
    end

endmodule

