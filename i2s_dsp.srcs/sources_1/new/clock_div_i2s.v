
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 05:50:47 PM
// Design Name: 
// Module Name: clock_div_i2s
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

module clock_div_i2s(
    input wire clk_in,      // 100 MHz input
    output reg mclk,        // 24.576 MHz
    output reg bck,         // 2.304 MHz
    output reg lrck         // 48 kHz
);


parameter Fs = 48_000;
parameter Main_clk = 300_000_000;
parameter MCLK_n_factor = 256;

parameter MCLK_DIV =  (Main_clk/(MCLK_n_factor*Fs))/2-1;
parameter BCK_DIV =  ((MCLK_n_factor*Fs)/(Fs*32*2))/2;
parameter LRCK_DIV =  32-1;

initial begin
    lrck = 0;
    bck = 0;
    mclk = 0;
end

wire resetn = 1'b1;
// === MCLK ===
reg [7:0] mclk_cnt;
always @(posedge clk_in) begin
    if (!resetn) begin
        mclk_cnt <= 8'd0;
        mclk <= 1'b0;
    end 
    else begin 
        if (mclk_cnt >= MCLK_DIV) begin  // chia đều 25/25
            mclk <= ~mclk;
            mclk_cnt <= 8'd0;
        end else begin
            mclk_cnt <= mclk_cnt + 1'b1;
        end
    end
end

//dcmm vivado
// === BCK ===
reg [6:0] bck_cnt;
always @(posedge mclk) begin
    if (!resetn) begin
        bck_cnt <= 7'd0;
        bck <= 1'b0;
    end 
    else begin
        if (bck_cnt >= BCK_DIV) begin
            bck <= ~bck;
            bck_cnt <= 0;
        end 
        else bck_cnt <= bck_cnt + 1'b1;
    end
end

// === LRCK ===
reg [11:0] lrck_cnt;
always @(negedge bck ) begin
    if (!resetn) begin
        lrck_cnt <= 12'd0;
        lrck <= 1'b0;
    end 
    else begin
        if (lrck_cnt >= LRCK_DIV) begin
            lrck <= ~lrck;
            lrck_cnt <= 0;
        end 
        else lrck_cnt <= lrck_cnt + 1'b1;
    end
end

endmodule
