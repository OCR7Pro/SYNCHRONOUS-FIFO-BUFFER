`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 12:23:53
// Design Name: 
// Module Name: write_logic
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


module write_logic(input            clk, reset,
                   input            wr_enable,
                   input      [3:0] rd_ptr,
                   output reg       full,                 
                   output reg [3:0] wr_ptr
                   );
      
        always@(posedge clk) begin
            if (reset) begin
                wr_ptr <= 4'b0000;
            end
            else begin
                if (wr_enable & ~full) begin
                    wr_ptr <= wr_ptr + 1;
                end
            end
        end
        
        always@(*) begin
            if ( {~wr_ptr[3], wr_ptr[2:0]} == rd_ptr ) begin
                full = 1'b1;
            end
            else begin
                full = 1'b0;
            end
        end
        
endmodule
