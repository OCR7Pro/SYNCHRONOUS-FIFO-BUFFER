`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 12:56:35
// Design Name: 
// Module Name: read_logic
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


module read_logic(input            clk, reset,
                  input            rd_enable,
                  input      [3:0] wr_ptr,
                  output reg       empty,
                  output reg [3:0] rd_ptr
                  );
    
     
        always@(posedge clk) begin
            if (reset) begin
                rd_ptr <= 4'b0000;
            end
            else begin
                if (rd_enable & ~empty) begin
                    rd_ptr <= rd_ptr + 1;
                end
            end
        end
        
        always@(*) begin
            if ( rd_ptr == wr_ptr ) begin
                empty = 1'b1;
            end
            else begin
                empty = 1'b0;
            end
        end
      
endmodule
