`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 14:33:14
// Design Name: 
// Module Name: sync_fifo_top
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


module sync_fifo_top(input       clk, reset,
                     input       wr_enable, rd_enable,
                     input [7:0] wr_data,
                     output      full, empty,
                     output[7:0] rd_data);
                     
        wire [3:0] wr_ptr, rd_ptr;     
        
        wire wr_enable_fifo = wr_enable & ~full;
        wire rd_enable_fifo = rd_enable & ~empty;
        
        fifo_memory fifo_mem(.clk(clk), .reset(reset),
                             .wr_enable(wr_enable_fifo), .rd_enable(rd_enable_fifo),
                             .wr_ptr(wr_ptr), .rd_ptr(rd_ptr),
                             .wr_data(wr_data),
                             .rd_data(rd_data)
                             );
                             
        write_logic wr_logic(.clk(clk), .reset(reset),
                             .wr_enable(wr_enable), .rd_ptr(rd_ptr),
                             .full(full), .wr_ptr(wr_ptr)
                             );
                             
        read_logic rd_logic (.clk(clk), .reset(reset),
                             .rd_enable(rd_enable), .wr_ptr(wr_ptr),
                             .empty(empty), .rd_ptr(rd_ptr)
                             );
                                            
endmodule
