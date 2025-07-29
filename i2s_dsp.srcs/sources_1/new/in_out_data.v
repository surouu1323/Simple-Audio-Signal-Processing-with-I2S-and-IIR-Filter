`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 07:14:21 PM
// Design Name: 
// Module Name: in_out_data
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

module in_out_data #(
    parameter BIT_WIDTH = 24
)(
    input wire BCK,      // Bit Clock
    input wire LCK,      // Left/Right Clock (Word Select)
    input wire DIN,      // Serial Data In
    input wire signed [BIT_WIDTH-1:0] data_out, // Parallel Data Out

    output reg DOUT,                         // Serial Data Out
    output reg signed [BIT_WIDTH-1:0] data_in       // Parallel Data In
);

// ---------- Internal Registers ----------
reg signed [BIT_WIDTH-1:0] data_in_reg;
reg signed [BIT_WIDTH-1:0] data_out_reg;

reg [$clog2(BIT_WIDTH):0] count_in = 0; // Use $clog2 for efficient counting
reg data_in_channel = 0;
reg start;
// ---------- Input Process (on posedge BCK) ----------
always @(posedge BCK) begin
    if (LCK == data_in_channel) begin
        if (count_in > BIT_WIDTH - 1) begin
            data_in <= data_in_reg;
        end
        else begin
            data_in_reg <= {data_in_reg[BIT_WIDTH-2:0], DIN};
            count_in <= count_in + 1;
        end
        
        data_out_reg <= data_out_reg << 1;
    end else begin
        count_in <= 1'b0;
        data_out_reg <= data_out;
        data_in_channel <= LCK;
    end
end

// ---------- Output Process (on negedge BCK) ----------
always @(negedge BCK) begin
    DOUT  <= data_out_reg[BIT_WIDTH-1]; 
end

endmodule

