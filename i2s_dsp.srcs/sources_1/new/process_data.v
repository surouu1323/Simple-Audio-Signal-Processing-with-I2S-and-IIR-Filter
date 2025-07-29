`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2025 07:12:22 AM
// Design Name: 
// Module Name: process_data
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


module process_data(
    input wire MCK,LCK,
    input wire signed[23:0] FIFO_data_in,
    output reg signed[23:0] FIFO_data_out,
    output wire busy,
    output wire start_iir,
    
    input wire  signed[23:0] from_iir,
    output reg signed [23:0] to_iir    
    );
    
   reg RL_state;
   reg state;  
    always @(posedge MCK)begin
        case(state)
            1'b0:   if(RL_state != LCK) begin
                        state <= 1'b1;
                    end
            1'b1:   begin
                        FIFO_data_out <= from_iir;
                        to_iir <= FIFO_data_in;
                        //FIFO_data_out = {from_iir[31],from_iir[22:0]};
                        RL_state <= LCK;
                        state <= 1'b0;
                    end
        endcase
        

    end
    assign start_iir = state;    
    
endmodule
