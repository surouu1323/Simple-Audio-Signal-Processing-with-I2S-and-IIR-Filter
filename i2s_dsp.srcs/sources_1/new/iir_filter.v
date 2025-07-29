`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2025 04:31:08 PM
// Design Name: 
// Module Name: iir_filter
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2025 04:31:08 PM
// Design Name: 
// Module Name: iir_filter
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


module iir_filter #(
    parameter bit_width = 24
)(
    input wire clk, reset,
    input wire signed [bit_width-1:0] iir_in,
    input wire sync_in,

    output reg signed [bit_width-1:0] iir_out,
    output wire sync_out,
    output wire busy,
    
    output reg [31:0] mult_in_a, mult_in_b, // Multiplier inputs and output
    input wire [63:0] mult_out,
    output reg mul_enable,

    input wire signed [31:0] b0,
    input wire signed [31:0] b1,
    input wire signed [31:0] b2,
    input wire signed [31:0] a1,
    input wire signed [31:0] a2,
    
    output wire [7:0] dm_vivado ,
    output wire [2:0] state_out
);

    reg [2:0] state = 0;
    assign state_out = state;
    // Delay and temp registers
    reg signed [31:0] temp = 0;
    reg signed [31:0] in_n =0, in_n_1 = 0, in_n_2 = 0;
    reg signed [31:0] out_n_1 = 0, out_n_2 = 0;
    
    assign dm_vivado = 8'd8;

//    parameter signed [31:0] GAIN_Q1_31 = 32'h40000000;
    
    initial begin
            mult_in_a = 0;
            mult_in_b = 0;
            temp = 0;
            in_n =0;
            in_n_1 =0;
            in_n_2 =0;
            out_n_1 =0;
            out_n_2 =0;
            iir_out =0;
            mul_enable = 0;
    end

     
    always @(posedge clk, posedge reset) begin
        if(reset)begin
            mult_in_a <= 0;
            mult_in_b <= 0;
            temp <= 0;
            in_n <=0;
            in_n_1 <=0;
            in_n_2 <=0;
            out_n_1 <=0;
            out_n_2 <=0;
            iir_out <=0;
            mul_enable <= 0;
        end
        else
        case (state)
            3'd0: begin
                if (sync_in) begin 
                    mul_enable <= 1'b1;
                    in_n <=  {{8{iir_in[23]}}, iir_in }; 
                    mult_in_a <= {{8{iir_in[23]}}, iir_in }; // b[0]* x[n]
                    mult_in_b <= b0; 
                    state <= 3'd1;
                end
                else mul_enable <= 0;
            end

            3'd1: begin
                temp <= mult_out >>> 30; 
                mult_in_a <= in_n_1; // b[1]* x[n-1]
                mult_in_b <= b1;
                state <= 3'd2;
            end

            3'd2: begin
                temp <= temp + (mult_out >>> 30); 
                mult_in_a <= in_n_2; // b[2]* x[n-2]
                mult_in_b <= b2;
                state <= 3'd3;
            end

            3'd3: begin
                temp <= temp + (mult_out >>> 30);
                mult_in_a <= out_n_1; // a[1]* y[n-1]
                mult_in_b <= a1;
                state <= 3'd4;
            end

            3'd4: begin
                temp <= temp + (mult_out >>> 30);
                mult_in_a <= out_n_2; // a[2]* y[n-2]
                mult_in_b <= a2;
                state <= 3'd5;
            end

            3'd5: begin
                temp <= temp + (mult_out >>> 30);
//                mult_in_a <= temp - (mult_out >>> 30);
//                mult_in_b <= GAIN_Q1_31; // bu gain
                mul_enable <= 1'b0;
                state <= 3'd7;
            end
            
//            3'd6: begin
//                temp <= (mult_out >>> 30);
//                mul_enable <= 1'b0;
//                state <= 3'd7;
//            end

            3'd7: begin
                iir_out <= {{1{temp[31]}}, temp[22:0]};
                out_n_1 <= iir_out;    
                out_n_2 <= out_n_1;
                in_n_1 <= in_n;
                in_n_2 <= in_n_1;
                state <= 3'd0;
            end

            default: state <= 3'd0;
        endcase
    end

    assign busy     = (state == 3'd0)? 0 : 1;
    assign sync_out = (state == 3'd7)? 0 : 1;
endmodule
