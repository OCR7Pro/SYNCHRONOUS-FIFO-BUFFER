`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 11:19:06
// Design Name: 
// Module Name: fifo_memory
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


module fifo_memory(input      clk, reset,
                   input      wr_enable, rd_enable,
                   input      [3:0] wr_ptr, rd_ptr,
                   input      [7:0] wr_data,
                   output reg [7:0] rd_data
                   );
        
        reg [7:0] mem [0:7];
        
        always@(posedge clk) begin
                if (wr_enable) begin
                    mem[wr_ptr[2:0]] <= wr_data;
                end                            
        end
             
        always@(posedge clk) begin
            if (reset) begin
                rd_data <= 8'd0;
            end
            else begin
                if (rd_enable) begin
                    rd_data <= mem[rd_ptr[2:0]];
                end                       
            end          
        end
endmodule
