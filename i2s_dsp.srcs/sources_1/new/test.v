`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2025 05:07:32 PM
// Design Name: 
// Module Name: test
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


module test(
    input wire clk, rst_n,sig_in,
    output wire pulse_out_p, pulse_out_n
    );
        
    reg sig_in_old;

    initial begin
        sig_in_old = 0;
    end
    
    always @(posedge clk, negedge rst_n)begin
            if(!rst_n) sig_in_old <= 0;
            else sig_in_old <= sig_in;
    end
    
    assign pulse_out_p = (sig_in & (~sig_in_old) & rst_n);
    assign pulse_out_n = (sig_in_old & (~sig_in) & rst_n);
    
endmodule
