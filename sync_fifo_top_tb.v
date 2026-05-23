`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 15:17:21
// Design Name: 
// Module Name: sync_fifo_top_tb
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


module sync_fifo_top_tb();
        
        reg       clk, reset;
        reg       wr_enable, rd_enable;
        reg [7:0] wr_data;
        wire      full, empty;
        wire[7:0] rd_data;
        
        sync_fifo_top dut(.clk(clk), .reset(reset),
                          .wr_enable(wr_enable), .rd_enable(rd_enable),
                          .wr_data(wr_data),
                          .full(full), .empty(empty),
                          .rd_data(rd_data)
                          );
                          
        always #5 clk = ~clk;
        
        integer i;
        
        initial begin
            // 1. Initialization
            clk = 1'b0;
            wr_enable = 1'b0;
            rd_enable = 1'b0;   
            wr_data = 8'd0;
            i = 0;
            
            // 2. Reset Sequence
            reset = 1'b1;
            #10
            reset = 1'b0; 
            
            @(posedge clk);
            #1;

                    // --- CASE 3: Write Faster than Read (Net Fill) ---
                $display("--- Starting Case 3: Write Rate > Read Rate ---");
                
                // Reset pointers to start fresh
                reset = 1'b1; 
                @(posedge clk); #1; // Wait one cycle
                reset = 1'b0;
                
                // Logic: Write EVERY cycle. Read EVERY OTHER cycle.
                // Net result: +1 item every 2 clocks. 
                // FIFO Depth 8 -> Should fill in approx 16 cycles.
                
                for (i = 0; i < 20; i = i + 1) begin
                    wr_enable = 1'b1;         // Always Write
                    rd_enable = (i % 2 != 0); // Read only when 'i' is ODD (0, 1(R), 2, 3(R)...)
                    wr_data = i;
                    
                    @(posedge clk);
                    #1;
                    
                    if (full) $display("Time: %0t | FIFO became FULL at count %0d", $time, i);
                end
        
                // --- CASE 4: Read Faster than Write (Net Drain) ---
                $display("--- Starting Case 4: Read Rate > Write Rate ---");
                
                // FIFO is currently FULL from Case 3.
                // Logic: Read EVERY cycle. Write EVERY OTHER cycle.
                // Net result: -1 item every 2 clocks.
                
                for (i = 0; i < 20; i = i + 1) begin
                    rd_enable = 1'b1;         // Always Read
                    wr_enable = (i % 2 != 0); // Write only when 'i' is ODD
                    wr_data = 8'hFF;          // Dummy data
                    
                    @(posedge clk);
                    #1;
                    
                    if (empty) $display("Time: %0t | FIFO became EMPTY at count %0d", $time, i);
                end
                
                wr_enable = 0;
                rd_enable = 0;
                $stop;
                                        
            end      
        
endmodule
